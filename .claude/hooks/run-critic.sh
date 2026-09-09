#!/bin/bash
# Runs after the generator's turn ends (Stop hook). Only acts when the last
# assistant message carries the "---DRAFT READY---" marker that
# generate-social-post prints once a full social post draft (captions
# inline, not just a file path) has been presented — everything else (mid-
# conversation chatter, questions to Giusi, non-post turns) is a no-op.
#
# When the marker is present: calls the social-critic subagent, parses its
# JSON verdict, and blocks the Stop event (forcing a revision turn) if the
# post doesn't pass — capped at 3 attempts, after which it stands down and
# flags the post for human review instead of looping forever.
set -uo pipefail

# Tries increasingly permissive strategies to pull a valid JSON object out of
# $1 (the critic's raw text output), then confirms it actually has the shape
# this script relies on (not just "some JSON"). Prints the JSON on stdout and
# returns 0 on success; prints nothing and returns 1 otherwise.
extract_verdict_json() {
  local text="$1" stripped candidate tail_after_close

  # 1. Already valid JSON as-is.
  if jq -e . >/dev/null 2>&1 <<< "$text"; then
    stripped="$text"
  else
    # 2. Strip markdown code-fence lines (``` or ```json) — common even with
    #    --json-schema and an explicit "respond ONLY with JSON" instruction.
    stripped=$(sed -e '/^[[:space:]]*```/d' <<< "$text")
    if ! jq -e . >/dev/null 2>&1 <<< "$stripped"; then
      # 3. Fall back to the substring from the first "{" through the last
      #    "}" — covers leading/trailing prose ("Here's the verdict:",
      #    commentary after the JSON) around an otherwise well-formed
      #    object. Pure bash (no extra subprocess), guarded so it never
      #    injects a stray brace when neither is present.
      if [[ "$stripped" == *"{"* && "$stripped" == *"}"* ]]; then
        candidate="${stripped#*\{}"
        candidate="{${candidate}"
        tail_after_close="${candidate##*\}}"
        candidate="${candidate%$tail_after_close}"
        stripped="$candidate"
      fi
      if ! jq -e . >/dev/null 2>&1 <<< "$stripped"; then
        return 1
      fi
    fi
  fi

  # Shape check: every field this script reads must actually be the type it
  # expects, not just present. Catches a dropped field, a score sent as a
  # string, or overall_pass as text — cases valid-but-wrong-shaped JSON would
  # otherwise sail through and corrupt scoring downstream.
  if ! jq -e '
        (.voice_match.score   | type == "number")  and
        (.hook_strength.score | type == "number")  and
        (.platform_fit.score  | type == "number")  and
        (.cliche_density.score| type == "number")  and
        (.overall_pass        | type == "boolean") and
        (.specific_fixes      | type == "array")
      ' >/dev/null 2>&1 <<< "$stripped"; then
    return 1
  fi

  printf '%s' "$stripped"
  return 0
}

input=$(cat)
session_id=$(jq -r '.session_id // empty' <<< "$input")
transcript_path=$(jq -r '.transcript_path // empty' <<< "$input")

if [[ -z "$transcript_path" || ! -f "$transcript_path" ]]; then
  exit 0
fi

# The transcript is JSONL, one JSON object per line. Filter structurally on
# the role field (jq reads a stream of concatenated top-level values just
# fine) rather than grepping the raw text for a role marker — a draft that
# happens to quote `"role": "assistant"` in its own text, or a nested
# tool-result echoing part of a transcript, would otherwise false-match.
draft=$(jq -c 'select(.message.role? == "assistant")' "$transcript_path" 2>/dev/null \
  | tail -n1 \
  | jq -r '.message.content[]? | select(.type=="text") | .text' 2>/dev/null \
  | paste -sd '\n' -)

if [[ -z "$draft" ]] || [[ "$draft" != *"---DRAFT READY---"* ]]; then
  # Not a finished post draft (mid-chat, a question, a non-post turn) —
  # never run the critic or block on these.
  exit 0
fi

iteration_file="/tmp/critic_iter_${session_id}"
count=$(cat "$iteration_file" 2>/dev/null || echo 0)
[[ "$count" =~ ^[0-9]+$ ]] || count=0

if [[ "$count" -ge 3 ]]; then
  rm -f "$iteration_file"
  echo '{"decision":"block","reason":"Critic loop hit the 3-attempt cap. Flag this post for human review instead of finalizing it — do not attempt a 4th automatic revision."}'
  exit 0
fi

schema='{"type":"object","properties":{"voice_match":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"hook_strength":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"platform_fit":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"cliche_density":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"overall_pass":{"type":"boolean"},"specific_fixes":{"type":"array","items":{"type":"string"}}},"required":["voice_match","hook_strength","platform_fit","cliche_density","overall_pass","specific_fixes"]}'

cli_failed=0
result=$(claude --agent social-critic -p "Evaluate this post draft:

${draft}" --output-format json --json-schema "$schema" 2>/dev/null) || cli_failed=1

raw_verdict=$(jq -r '.result // .content // empty' <<< "$result" 2>/dev/null)

verdict_json=""
if [[ "$cli_failed" -eq 0 && -n "$raw_verdict" ]]; then
  verdict_json=$(extract_verdict_json "$raw_verdict") || verdict_json=""
fi

if [[ -n "$verdict_json" ]]; then
  overall_pass=$(jq -r '.overall_pass' <<< "$verdict_json")
else
  overall_pass=""
fi

if [[ "$overall_pass" == "true" ]]; then
  rm -f "$iteration_file"
  exit 0
fi

# Failed, unparseable, or un-runnable verdict — increment and block.
next_count=$((count + 1))
echo "$next_count" > "$iteration_file"

if [[ "$cli_failed" -eq 1 ]]; then
  reason="Critic subagent invocation failed (attempt ${next_count}/3) — the \`claude --agent social-critic\` call itself returned a non-zero exit. Check that the CLI is on PATH and the social-critic agent is registered, then retry; treating this draft as unreviewed, not as a content failure."
elif [[ -z "$verdict_json" ]]; then
  # The verdict never became valid, correctly-shaped JSON (empty response,
  # malformed JSON survived all extraction attempts, or a required field was
  # missing/mistyped) — surface that distinctly from an actual content
  # rejection below.
  reason="Critic verdict could not be parsed into the expected shape (attempt ${next_count}/3) — treating as a failed check, not a content rejection. Raw output: ${raw_verdict:0:500}"
else
  fixes=$(jq -r '.specific_fixes | join("; ")' <<< "$verdict_json")
  reason="Critic rejected this draft (attempt ${next_count}/3). Fixes needed: ${fixes:-see critic output above}"
fi

jq -n --arg reason "$reason" '{decision: "block", reason: $reason}'
