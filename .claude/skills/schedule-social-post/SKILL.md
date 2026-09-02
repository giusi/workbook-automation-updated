---
name: schedule-social-post
description: Send an already-approved HDH social post (Canva design + captions) to Make for scheduling, and record the approved captions in the repo. Use only when Giusi says a specific post is approved and asks to schedule/send it — never as a follow-on to drafting. Refuses to send anything still carrying a placeholder.
---

# Schedule an approved HDH social post

This skill hands one **already-approved** post to Make, and writes the approved
copy into `approved/social/` so the repo keeps a permanent record of what was
actually published.

**It is invoked by a human, never automatically.** Same shape as
`generate-workbook` → `finalize-workbook`: drafting and deciding-to-publish are
two different decisions, and this skill only ever runs after the second one.

If Giusi has not said, in this conversation, that this specific post is
approved — stop and ask. "The draft looks finished" is not approval. Neither is
"the design is done in Canva". Only she decides.

## Inputs

- The post to send: a date (`2026-08-15`) or a review-package path
  (`out/social/2026-08-15-....json`). If ambiguous or missing, ask — never pick
  the most recent draft and assume.

## Steps

1. **Confirm approval explicitly.** Say which post you are about to send —
   date, thesis, Canva URL — and get a yes before doing anything else. This is
   the last human gate before content leaves the repo.

2. **Load the review package** from `out/social/`. If it isn't there (`out/` is
   gitignored, so it won't survive a fresh session), rebuild it from
   `approved/social/` if a record exists, otherwise stop and say so — never
   reconstruct captions from memory or re-draft them here. Re-drafting at
   scheduling time would send text Giusi never actually approved.

3. **Refuse on placeholders.** Scan every caption and CTA field for `<...>`
   placeholders — the CTA keyword and the episode link especially. If any
   remain, **stop and report which fields**. Do not send, do not substitute a
   plausible value, do not ask Make to sort it out. Make's own filter blocks
   these too; this is the first of the two checks, not a replacement for it.

4. **Write the approved record** to `approved/social/<date>-<slug>.md` and
   `.json`. Unlike `out/`, this directory is **committed** — it is the durable
   answer to "what did we actually approve and send?", and it survives the
   container that `out/` does not. Include: date, fonte, stile, thesis, avatar,
   the Canva design URL and id, every platform caption verbatim, the CTA
   keyword as sent, and the approval timestamp.

5. **POST to Make.** Send the payload described in
   [`references/make_handoff.md`](references/make_handoff.md) to the URL in
   `MAKE_WEBHOOK_URL`. If that variable isn't set, stop and tell Giusi the
   webhook isn't configured yet — don't guess a URL, and don't fall back to
   any other delivery route.

6. **Update `posting_log.md`**: set `Make webhook: sent <timestamp>`, point
   `Review package` at the `approved/social/` path, and set `Stato: inviato a
   Make`. Never mark a post `pubblicato` — Claude doesn't know whether it went
   out, and shouldn't claim to.

7. **Commit** the `approved/social/` files and the log entry, so the record of
   what was sent is in git rather than in a container that will be reclaimed.

8. **Report back**: what was sent, where the approved record lives, and that
   scheduling/publishing now happens in Make with a human still deciding the
   final publish.

## What this skill must never do

- **Never publish to a platform.** Claude holds no Instagram, Facebook,
  YouTube or Telegram connection, by design. Make owns every platform
  connection. If a task seems to need one, raise it with Giusi rather than
  solving it.
- **Never create, modify, activate or delete anything in Giusi's Make
  account** — scenarios, webhooks, connections, folders — without asking her
  first and getting a yes. Reading and validating are fine. This is her
  standing instruction (2026-09-02), and it holds even when the Make write
  tools are available.
- **Never re-draft or "improve" a caption here.** If the copy needs changing,
  that is `generate-social-post`'s job, followed by a fresh approval.
- **Never send a post twice.** Check `posting_log.md` and `approved/social/`
  first; if it's already been sent, say so and stop.
