# Make hand-off — payload contract and scenario spec

Status: **Blueprints written and schema-validated; not yet imported into Make.**
The Make connector is authorized, but this session's Make tools are read and
validate only — there is no `scenarios_create` — so the two scenarios ship as
importable blueprints in [`make/`](../../../../make/) rather than being created
directly. See `make/README.md` for the import steps and the platform limits.

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
- A human approves every post between the webhook and any platform. The review
  email is not a formality to route around.
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
  — that check belongs in the scenario, not only in Claude's self-review.
- `hashtag` is empty for `facebook_gruppo`, `youtube` and `telegram` by design
  (see `hdh-social-copy`, "Adattamento per piattaforma"). An empty array is
  correct, not missing data.
- `aperti` carries the open questions Claude surfaced. They belong in the review
  email so Giusi sees them before approving, not buried in the repo.
- `schema_version` exists so the scenario can fail loudly on a payload shape it
  doesn't know, instead of publishing a half-mapped post.

## Scenario spec — current design

One scenario, no approval email (Giusi's decision, 2026-09-02):

```
webhook  →  Canva: exportDesign  →  Facebook Page: create post (unpublished)
```

The review that an email round-trip used to provide now happens twice over:
once when Giusi approves the post before `schedule-social-post` is invoked at
all, and again on the Facebook Page, where the draft lands unpublished and she
decides whether to publish it.

See `make/` in the repo root for the importable blueprint and the test plan.

**Giusi already has a scenario for this** — "Publish Done Canva Designs"
(id 9724996, inactive, never run), built around polling a Canva folder rather
than a webhook. It cannot carry captions, which is why the webhook design
exists. Any move to reconcile the two is **hers to approve first**.

## Standing rule: never change Make without asking

Giusi's instruction, 2026-09-02: **never create, modify, activate or delete
anything in her Make account without asking her first and getting a yes.**
That covers scenarios, webhooks, connections and folders, and it holds even
when the Make write tools are available in a session. Reading and validating
are fine.
