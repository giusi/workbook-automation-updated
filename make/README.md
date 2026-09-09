# Make — HDH social hand-off (v2: one scenario, router per platform)

Status (2026-09-09): **built directly in Make and verified working.**
Scenario **`HDH Social — Canva → FB / IG / Telegram`** (id `9724996`, team
`11942`) — this reuses the scenario Giusi had already started as "Publish
Done Canva Designs": same Canva connection (id `14550076`), renamed and
restructured. Facebook/Instagram/Telegram are all connected, and multiple
happy-path test runs confirm real execution data: Facebook gets the full
5-page album, Instagram gets page 1, Telegram gets the full album with the
caption correctly on page 1 only. It's still **off** — every branch also
carries a hardcoded "always false" safety filter, so nothing has actually
published anywhere yet.

`hdh-canva-to-social-router.json` in this folder is kept as an importable
blueprint of the same structure (useful for recreating the scenario, or
importing into a different team) — it mirrors what's live, not a separate
design.

```
                                                        ┌─ Facebook Page: full album, all pages (unpublished draft)
webhook → filter → Canva: export (5 pages) → Aggregator ┼─ [if "instagram" confirmed] → Instagram: page 1 only (LIVE — no draft)
                                                        └─ [if "telegram" confirmed]  → Feeder → Aggregator → Telegram: full album (LIVE — no draft)
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

## YouTube community posts and Facebook Groups — not automatable, not a Make gap

Checked directly against Make's YouTube module list: video upload/update/
delete, channel/playlist management, comment replies, and a raw API-call
module. No community-post module exists, because the YouTube Data API has
never exposed one publicly, for anyone.

Same wall for **Facebook Groups — public or private, no exceptions.** Make
has no "Facebook Groups" app at all (checked: no such app exists in its
catalog, only "Facebook Pages"). This isn't a Make gap either — Meta locked
down the Groups API for third-party publishing in 2018 and only grants it to
a small number of specially-reviewed apps. No generic automation tool has
it.

So Facebook profile, the Podcast Group, and YouTube community posts all stay
copy-paste from the review package. Permanently, not "until we find a way."

## What's left before going live

Connections, image mapping, and the Telegram carousel logic are all done
and verified (see status above). What remains:

1. **Remove the "always false" safety filter** on each of the three
   platform branches — added deliberately during testing, needs taking out
   before any real send.
2. **Facebook: check whether the module exposes unpublished/scheduled**
   (see the caveat below) — hasn't come up yet since the branch stayed
   disabled throughout testing.
3. Once you're happy, tell me and I'll set `MAKE_WEBHOOK_URL` and
   `MAKE_WEBHOOK_API_KEY` in the environment where `generate-social-post`/
   `schedule-social-post` run. **Never commit either to the repo** — anyone
   holding both could push a post into your pipeline.

## Webhook authentication (added 2026-09-04)

The webhook now requires an `x-make-apikey` header (Make's own webhook
API-key feature — locked header name, key value is whatever you added in
the module). A leaked URL alone is no longer enough to trigger the
scenario; the caller also needs the key. Every payload Claude sends,
including test curls, carries this header — never just the URL.

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

## Architecture note: why there's an Aggregator (and a Feeder+Aggregator for Telegram)

Canva's `exportDesign` with `as_single_image: false` returns **multiple
bundles** (one per page), not one bundle with an array field — every
downstream module would otherwise re-run once per page instead of once per
post. A `builtin:BasicAggregator` right after it collects all pages into
one bundle holding a real array, which Facebook (full album) and Instagram
(indexed to page 1) consume directly. Telegram needs its own
Feeder→Aggregator pair on top of that, because each item in its media
group needs per-item shaping (`type`, `httpUrl`, `sendType`) with the
caption applied to page 1 only — `if(9.__IMTINDEX__ = 1; ...)`. Make's
bundle/feeder indices are 1-based (confirmed against the scenario's own
cached sample data) — an earlier `= 0` version of this condition was a
real bug that shipped once and was caught by inspecting real execution
output, not by guessing.
