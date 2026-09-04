# Make — HDH social hand-off (v2: one scenario, router per platform)

Status (2026-09-04): **built directly in Make, not just a blueprint file.**
Scenario **`HDH Social — Canva → FB / IG / Telegram`** (id `9724996`, team
`11942`) — this reuses the scenario Giusi had already started as "Publish
Done Canva Designs": same Canva connection (id `14550076`), renamed and
restructured. It's currently **off**, with Facebook/Instagram/Telegram
connections unset — Giusi connects those by hand before anything can run.

`hdh-canva-to-social-router.json` in this folder is kept as an importable
blueprint of the same structure (useful for recreating the scenario, or
importing into a different team) — it mirrors what's live, not a separate
design.

```
                                    ┌─ Facebook Page: create post (unpublished draft)
webhook → filter → Canva: export ──┼─ [if "instagram" confirmed] → Instagram: create post  (LIVE — no draft)
                                    └─ [if "telegram" confirmed]  → Telegram bot: send photo (LIVE — no draft)
```

Full contract and reasoning: `.claude/skills/schedule-social-post/references/make_handoff.md`.

## Why one scenario with a router, not one scenario per platform

A single execution log per post beats three separate scenario histories to
cross-reference when debugging "did this post go out everywhere correctly."
Each router branch keeps its own filter and can be disabled independently in
the Make designer — no isolation is lost versus separate scenarios.

## Why Instagram and Telegram need a second gate Facebook doesn't

Facebook posts land as an **unpublished draft** — a human looks at it on the
Page before it's ever public. Instagram and Telegram have **no draft state
in their APIs** — the moment their module runs, it's live. So those two
branches carry an extra filter: they only fire if the payload's
`canali_live_confermati` array names them. `schedule-social-post` asks Giusi
explicitly, per channel, per send — never inferred from "the post is
approved." Facebook needs no such flag.

## YouTube community posts — not automatable, not a Make gap

Checked directly against Make's YouTube module list: video upload/update/
delete, channel/playlist management, comment replies, and a raw API-call
module. No community-post module exists, because the YouTube Data API has
never exposed one publicly, for anyone. Same story for Facebook profile and
the Podcast Group — no API. All three stay copy-paste from the review
package. Permanently, not "until we find a way."

## Setup Giusi still needs to do (Claude holds no platform credentials)

1. Open scenario `HDH Social — Canva → FB / IG / Telegram` in Make.
2. **Facebook Pages module** → add your connection → pick the Page → map the
   exported Canva images into the photos field → check whether the module
   exposes unpublished/scheduled (see the caveat below).
3. **Instagram Business module** → add your connection → map the exported
   image into the photo field. **The caption field mapping
   (`{{1.captions.instagram.testo}}`) is Claude's best guess** — this
   session had no schema-read access to Make's app definitions to confirm
   it against the actual module fields, so check it lands in the right
   place once connected.
4. **Telegram module** → create a bot via @BotFather if you haven't, add the
   connection, set the target `chat_id` (your channel), map the exported
   image and the caption field (`{{1.captions.telegram.testo}}` — same
   best-guess caveat as Instagram).
5. **Leave the scenario off** until you've tested per `make/TESTING.md`.
6. Once you're happy, tell me the webhook URL is ready to use and I'll set
   `MAKE_WEBHOOK_URL` in the environment where `generate-social-post`/
   `schedule-social-post` run. **Never commit it to the repo** — anyone
   holding that URL can push a post into your pipeline.

## The caveat that decides whether this is really a "draft"

- **Facebook Page — yes.** Meta's API supports unpublished and scheduled
  posts, which is what makes the review step real. Confirm the module
  exposes it; if it only publishes live, schedule it a few hours out instead.
- **Instagram — no.** The API publishes; there is no draft state. That's
  what `canali_live_confermati` exists to gate.
- **Telegram — no.** Sending is delivering. Same gate.

Your Facebook **personal profile**, the **Podcast Group** and **YouTube**
can't be automated at all (no API for any of them), so those captions stay
copy-paste from the review package.

## Not yet validated

Module-level field names for Instagram and Telegram — see point 3 and 4
above. Facebook's `message` field is confirmed (it's what was already in
Giusi's original Facebook module, untouched). The team ID (`11942`) that the
old version of this doc needed is no longer a blocker — resolved this
session via `environment_get`.
