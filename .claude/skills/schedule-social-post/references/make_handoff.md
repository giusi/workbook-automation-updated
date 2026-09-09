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
held in the `MAKE_WEBHOOK_URL` environment variable, with an
`x-make-apikey: <MAKE_WEBHOOK_API_KEY>` header (added 2026-09-04 — the
webhook rejects any request missing or mismatching this). Never hardcode
either value in the repo — together they're the credential: anyone holding
both can inject a post into the review queue; the API key means the URL
alone (e.g. leaked in a chat transcript) is no longer sufficient by itself.

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
                                                        ┌─ Facebook Page: create post, full album, all pages (unpublished draft)
webhook → filter → Canva: export (5 pages) → Aggregator ┼─ [if "instagram" confirmed] → Instagram: create post, page 1 only (LIVE, no draft)
                                                        └─ [if "telegram" confirmed]  → Feeder → per-item caption (page 1 only) → Aggregator → Telegram: send media group, full album (LIVE, no draft)
```

The Aggregator after Canva's export exists because `exportDesign` with
`as_single_image: false` returns **multiple bundles** (one per page), not
one bundle with an array field — every downstream module would otherwise
re-run once per page. The Aggregator collects them into one bundle holding
a real array (`{{7.array}}`), which Facebook and Instagram consume
directly/indexed. Telegram needs a second Feeder→Aggregator pair because
its media-group items each need per-item shaping (`type`, `httpUrl`,
`sendType`) with the caption applied to page 1 only — done via
`if(9.__IMTINDEX__ = 1; ...)` (Make's bundle/feeder indices are 1-based,
confirmed against the scenario's own cached sample data, not assumed —
an earlier `= 0` version of this condition was a real bug, since fixed and
verified both by execution output and independent blueprint read-back).

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
profile and **the Podcast Group — public or private, no exceptions**: Make
has no "Facebook Groups" app at all (only "Facebook Pages"), because Meta
locked down third-party publishing to Groups in 2018 and only grants that
API to a small number of specially-reviewed apps. All three stay copy-paste
from the review package, permanently, not "until automated."

### What's wired vs. what's still open (status 2026-09-09)

**Fully wired, verified working end to end** (guard-filter and multiple
happy-path tests, real execution output inspected — Facebook full album,
Instagram page-1, Telegram media group with correct per-item captions all
confirmed against actual bundle data, not assumed):
- Webhook trigger (`x-make-apikey` auth), guard filter, Canva export
  (5 pages, jpg) → Aggregator → Router with 3 branches.
- **Facebook Pages, Instagram Business, and Telegram Bot connections are
  all made** — real Page/account/chat IDs wired in (Make UI, not Claude,
  which never holds these credentials).
- Facebook: full album (`{{7.array}}`). Instagram: page 1 only
  (`{{7.array[1].url}}`). Telegram: full media group via a second
  Feeder→Aggregator pair, caption correctly on page 1 only.

Still open, in the Make UI, before any real send:
1. **Remove the "always false" safety filters** on all three branches —
   they currently block every branch unconditionally (correct for
   testing, wrong for going live).
2. **Facebook: confirm unpublished/scheduled is actually set** — open
   question on whether Make's module exposes it; hasn't been checked yet
   since the branch has stayed disabled throughout testing.
3. **Telegram's `SendMediaGroup` requires `minItems: 2`** (a real Make
   constraint, confirmed in its schema) — fine for every current post
   (5 pages), but would break on a hypothetical 1-page design. Not an
   issue now, worth remembering later.

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
