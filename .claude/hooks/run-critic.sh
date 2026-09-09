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

input=$(cat)
session_id=$(jq -r '.session_id // empty' <<< "$input")
transcript_path=$(jq -r '.transcript_path // empty' <<< "$input")

if [[ -z "$transcript_path" || ! -f "$transcript_path" ]]; then
  exit 0
fi

# The transcript is JSONL, one entry per line. Find the most recent
# assistant message and concatenate its text blocks.
draft=$(tac "$transcript_path" 2>/dev/null \
  | grep -m1 '"role"[[:space:]]*:[[:space:]]*"assistant"' \
  | jq -r '.message.content[]? | select(.type=="text") | .text' 2>/dev/null \
  | paste -sd '\n' -)

if [[ -z "$draft" ]] || [[ "$draft" != *"---DRAFT READY---"* ]]; then
  # Not a finished post draft (mid-chat, a question, a non-post turn) —
  # never run the critic or block on these.
  exit 0
fi

iteration_file="/tmp/critic_iter_${session_id}"
count=$(cat "$iteration_file" 2>/dev/null || echo 0)

if [[ "$count" -ge 3 ]]; then
  rm -f "$iteration_file"
  echo '{"decision":"block","reason":"Critic loop hit the 3-attempt cap. Flag this post for human review instead of finalizing it — do not attempt a 4th automatic revision."}'
  exit 0
fi

schema='{"type":"object","properties":{"voice_match":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"hook_strength":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"platform_fit":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"cliche_density":{"type":"object","properties":{"score":{"type":"integer"},"note":{"type":"string"}},"required":["score","note"]},"overall_pass":{"type":"boolean"},"specific_fixes":{"type":"array","items":{"type":"string"}}},"required":["voice_match","hook_strength","platform_fit","cliche_density","overall_pass","specific_fixes"]}'

result=$(claude --agent social-critic -p "Evaluate this post draft:

${draft}" --output-format json --json-schema "$schema" 2>/dev/null)

raw_verdict=$(jq -r '.result // .content // empty' <<< "$result")
# The critic sometimes wraps its JSON in a ```json ... ``` fence despite
# --json-schema and the "respond ONLY with JSON" instruction — strip any
# line that is purely a code-fence marker before parsing.
verdict_json=$(sed -e '/^```/d' <<< "$raw_verdict")
overall_pass=$(jq -r '.overall_pass' <<< "$verdict_json" 2>/dev/null)

if [[ "$overall_pass" == "true" ]]; then
  rm -f "$iteration_file"
  exit 0
fi

# Failed or unparseable verdict — increment and block.
next_count=$((count + 1))
echo "$next_count" > "$iteration_file"

if [[ "$overall_pass" != "false" ]]; then
  # The verdict didn't parse at all (malformed JSON, empty response, CLI
  # error) — surface that distinctly instead of silently treating it as a
  # content failure.
  reason="Critic verdict could not be parsed (attempt ${next_count}/3) — treating as a failed check. Raw output: ${raw_verdict:0:500}"
else
  fixes=$(jq -r '.specific_fixes | join("; ")' <<< "$verdict_json" 2>/dev/null)
  reason="Critic rejected this draft (attempt ${next_count}/3). Fixes needed: ${fixes:-see critic output above, JSON may have been malformed}"
fi

jq -n --arg reason "$reason" '{decision: "block", reason: $reason}'
