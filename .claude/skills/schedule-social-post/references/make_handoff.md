# Make hand-off — payload contract and scenario spec

Status (2026-09-04): **Built and live in Make, inactive.** Scenario
`HDH Social — Canva → FB / IG / Telegram` (id `9724996`, team `11942`,
reusing what Giusi had already started as "Publish Done Canva Designs") is
webhook-triggered with a router branching per platform. Webhook `hdh-social-draft`
(id `4354566`) exists — ask Giusi or check the scenario's first module for the
URL; it is never written into this repo (see "Never commit the URL" below).

The scenario is **off** and Facebook/Instagram/Telegram connections are
**unset** — Giusi connects those by hand in the Make UI (this repo/Claude
never holds platform credentials, see the hard constraint below). Nothing
sends anywhere until she tests per `make/TESTING.md` and switches it on
herself.

## The hard constraint (do not weaken this)

**Claude must never hold a direct connection to Instagram, Facebook, YouTube or
Telegram.** No platform MCP connector, no posting API, no credentials in this
repo. Make owns every platform connection; Claude's only contact with the
outside world is a **one-way webhook POST** carrying a draft.

Consequences that follow from it, and that any future change must preserve:

- Claude never publishes, schedules, or deletes a post. It hands over a draft
  and stops.
- The webhook is fire-and-forget. Claude does not read back from Make, does not
  poll for approval, and does not learn whether a post went out — `posting_log.md`
  is updated by hand (or later by Make writing to the repo, never by Claude
  querying Make).
- A human approves every post before the webhook fires, and for Facebook a
  second time on the Page, where the draft lands unpublished and she decides
  whether to publish it. **Instagram and Telegram have no draft state** — the
  webhook firing IS the live publish for those two, which is exactly why
  `canali_live_confermati` (below) exists as a second, explicit per-channel gate.
- If someone proposes giving Claude a platform connector "just for reading
  metrics", that is a change to this constraint and needs Giusi's explicit
  decision, not a convenience call.

## Payload contract (Claude → Make)

One POST per drafted post, `Content-Type: application/json`, to the webhook URL
held in the `MAKE_WEBHOOK_URL` environment variable. Never hardcode the URL in
the repo — a Make webhook URL is a credential: anyone holding it can inject a
post into the review queue.

```json
{
  "schema_version": 1,
  "post_id": "2026-08-15-non-sei-dipendente-dal-telefono",
  "data_post": "2026-08-15",
  "fonte": "workbook",
  "stile": "unpopular_opinion",
  "tesi": "Non è dipendenza da schermo. È dipendenza dal non sentire.",
  "avatar": "Giulia",
  "canva_design_url": "https://www.canva.com/design/DAHUDZQXSi0/edit",
  "canva_design_id": "DAHUDZQXSi0",
  "mese_anno_tag": "Agosto 2026",
  "cta_keyword": "<PAROLA-CHIAVE>",
  "canali_live_confermati": [],
  "captions": {
    "instagram":        { "testo": "...", "hashtag": ["#..."] },
    "facebook_profilo": { "testo": "...", "hashtag": ["#..."] },
    "facebook_gruppo":  { "testo": "...", "hashtag": [] },
    "youtube":          { "testo": "...", "hashtag": [], "link_episodio": null },
    "telegram":         { "testo": "...", "hashtag": [] }
  },
  "aperti": ["..."],
  "review_package_path": "out/social/2026-08-15-....json"
}
```

Rules for the payload:

- `cta_keyword` and `link_episodio` may be placeholders or `null`. **Make must
  refuse to publish a post whose payload still carries a `<...>` placeholder**
  — that check belongs in the scenario (the "Solo payload completi" filter on
  the Canva-export module), not only in Claude's self-review.
- `canali_live_confermati` — array, e.g. `["instagram"]`, `["instagram",
  "telegram"]`, or `[]`. Gates the Instagram and Telegram router branches,
  which have no draft state and publish live the instant they run. **Never
  auto-populate this from "the post is approved"** — `schedule-social-post`
  asks Giusi per channel, per send, and only lists what she said yes to *this
  time*. An empty array is the safe default: Facebook still gets its
  (draft) post, Instagram/Telegram branches just don't fire.
- `hashtag` is empty for `facebook_gruppo`, `youtube` and `telegram` by design
  (see `hdh-social-copy`, "Adattamento per piattaforma"). An empty array is
  correct, not missing data.
- `aperti` carries the open questions Claude surfaced. They belong in the review
  email so Giusi sees them before approving, not buried in the repo.
- `schema_version` exists so the scenario can fail loudly on a payload shape it
  doesn't know, instead of publishing a half-mapped post.

## Scenario spec — as actually built (2026-09-04)

```
                                    ┌─ Facebook Page: create post (unpublished draft)
webhook → filter → Canva: export ──┼─ [if "instagram" in canali_live_confermati] → Instagram: create post  (LIVE, no draft)
                                    └─ [if "telegram" in canali_live_confermati]  → Telegram bot: send photo (LIVE, no draft)
```

One scenario (not one per platform) — reasoning: a single execution log per
post lets you see every platform's outcome together when debugging "did
Tuesday's post go out correctly," instead of cross-referencing separate
scenario histories by post_id. Each router branch keeps its own filter and
can be individually disabled in the Make designer without touching the
others.

**YouTube community posts are not in this scenario and never will be** — the
YouTube Data API has no public endpoint for them (confirmed against Make's
own YouTube module list: video/channel/playlist/comment actions only, no
community-post module, for anyone, not a Make gap). Same for Facebook
profile and the Podcast Group — no API exists. All three stay copy-paste
from the review package, permanently, not "until automated."

### What's wired vs. what Giusi still does by hand

Wired already (reusing her existing Canva connection, id `14550076`):
- Webhook trigger, the "Solo payload completi" guard filter, Canva export by
  `canva_design_id`.
- Router with 3 branches, each already filtered/named.
- Facebook and Instagram/Telegram caption text mapped from the payload
  (`{{1.captions.facebook_profilo.testo}}`, etc.).
- The `canali_live_confermati` gate on the Instagram and Telegram branches.

Still needs Giusi, in the Make UI (Claude holds no platform credentials, see
the hard constraint):
1. **Connect Facebook Pages, Instagram Business, and Telegram Bot** — none of
   these three connections exist yet on this scenario.
2. **Map the exported Canva images into each branch's photo field** — the
   Canva-export module's output was never wired into any of the three
   platform modules' image fields. This is a manual drag in the Make UI in
   each module (same as the original single-scenario plan already noted).
3. **Verify the Instagram and Telegram caption field names.** This session
   had no `apps:read` scope, so those two mappings (`caption`) are
   Claude's best-effort guess from each platform's own API docs, not
   confirmed against Make's actual module schema — check they land in the
   right field once the modules are connected; Facebook's `message` field
   *is* confirmed (it's the field already used in Giusi's original,
   untouched Facebook module).
4. **Facebook: pick the Page and set the post to unpublished/scheduled** —
   same caveat as before on whether Make exposes that option; see below.

## The caveat that decides whether this is really a "draft"

"Draft" means something different on each platform:

- **Facebook Page — yes.** Meta's API supports unpublished and scheduled posts.
  Confirm in the module whether Make exposes the unpublished/scheduled option;
  if it only publishes live, the fallback is to schedule it a few hours out.
- **Instagram — no.** The API publishes; there is no draft state.
- **Telegram — no.** Sending is delivering.

That's why the `canali_live_confermati` gate exists specifically for those two
— it's the closest equivalent to a draft review that a live-only API allows:
a second explicit yes from Giusi, separate from "the post is approved,"
required before the branch runs at all.

## Testing Instagram and Telegram, given neither has a draft state

`make/TESTING.md` covers Facebook (disable the module, inspect the mapped
input, then a real unpublished draft). The same "disable + inspect input"
technique is the actual safety mechanism there — the draft state was always
a second, bonus safety net on top, not the only one. It generalizes to any
module regardless of whether the downstream platform has a draft state:

1. **Disable the Instagram and Telegram modules** (right-click → Disable) —
   same as Facebook. Run a real payload through with both disabled and
   inspect each module's mapped input bubble: is the right caption in the
   right field, is the CTA keyword real (not a placeholder), does the image
   reference look right? This alone catches most mapping bugs without a
   single live send.
2. **For Instagram specifically**, since a live post can't be un-published:
   either connect a secondary/test Instagram professional account for the
   first real send (swap to the real `@giusivalentinicoach` connection only
   after confirming the mapping looks right there), or do the first real
   send on the real account at a moment Giusi is watching and ready to
   delete it within seconds if something's wrong. Her call — flag it as an
   open decision, don't default to either silently.
3. **For Telegram**, de-risking is cheap: create a private test channel
   (just Giusi, or Giusi + Claude's operator) in about 30 seconds, point the
   bot at that `chat_id` for the first real send, verify formatting and the
   caption/image render correctly, then switch the module's `chat_id` to the
   real Happy Daily Body channel for the actual go-live.
4. Only after both have had one clean real-destination test does
   `canali_live_confermati` get populated for a real post — see the gate
   above.

## Standing rule: never change Make without asking

Giusi's instruction, 2026-09-02: **never create, modify, activate or delete
anything in her Make account without asking her first and getting a yes —
every time**, not just once for "this kind of change." It covers scenarios,
webhooks, connections, folders and any tool that can write to her account,
regardless of which write tools happen to be available in a given session.
Reading and validating are always fine without asking.
