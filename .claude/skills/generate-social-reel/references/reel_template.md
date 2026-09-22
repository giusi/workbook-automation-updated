# HDH Podcast Reel — Canva brand template

Brand template id **`EAHV8Iu7jbk`** — https://www.canva.com/brand/brand-templates/EAHV8Iu7jbk

3 pages, 1080x1920 (portrait, 9:16 — Reels/Stories ratio). Built 2026-09-22
from Giusi's real "Come non perderti di nuovo" reel (`DAHVpz0P6HM`, still
untouched — the template was built from a *copy*, `copy-design` then
`update_autofill_field` then `publish-brand-template`), at her explicit
request, so the visual DNA (hero-photo hook, pull-quote card, CTA card, all
carrying the "HAPPY DAILY PODCAST" badge) matches a real post exactly — not
a from-scratch design.

**Scope: podcast-episode reels only.** This format promotes one specific
episode — a hook slide announcing it, a verbatim quote from it, and a CTA to
get the link. It is not a general-purpose reel shape (no masterclass CTA
variant exists) — see SKILL.md.

Fill via the same mechanism as the carousel template:
`create-design-from-brand-template` → `read-design` (open transaction) to
get locator_ids → `edit-design` with `replace_text` per text field and
`update_fill` for the three image fields → commit.

## Fields

| Page | Field | Type | Notes |
|---|---|---|---|
| 1 (hook) | `hook_testo` | text | **The episode's real title, verbatim** — never an invented hook line. This is the one place this template differs sharply from the carousel: the carousel's `hook_testo` is a crafted thesis sentence, this one is just the episode's actual name. |
| 1 | `sfondo_hook` | image | Full-bleed hero photo of Giusi. Appears on **two separate elements** on this page (the main background and a second crop behind the bottom info bar) — both carry this same field label, so setting the fill applies to both independently; always pass the same asset to both so they stay visually consistent. |
| 2 (quote) | `quote_testo` | text | One verbatim quote pulled from the transcript. Never paraphrased, never invented — see SKILL.md's transcript rule. |
| 2 | `sfondo_quote` | image | Photo inset (bottom-right, smaller frame) — can be the same photo as `sfondo_hook`/`sfondo_cta` or a different shot from the same session; see "Photo sourcing" below. |
| 3 (CTA) | `cta_azione` | text | Fixed pattern: `Rispondi "PODCAST" per ricevere il link in DM`. The keyword is **always PODCAST** for this format — unlike the carousel's masterclass CTA, this never needs confirming with Giusi each run. |
| 3 | `sfondo_cta` | image | Full-bleed hero photo — same asset as `sfondo_hook` by default (bookend consistency, matches the real example). |

**Static brand chrome — never a field, never varies:** the "HAPPY DAILY
PODCAST" badge + mic icon (pages 1 and 3), the "Ascoltalo ora" pill and
"NUOVO EPISODIO / Su Spotify, Apple Podcast e Youtube" line (page 1), the
quotation-mark icon and "dal podcast" label and "Giusi Valentini" attribution
(page 2). If a future post ever needs one of these to vary (a guest episode
with a different attribution name, a platform not carrying the show), that's
a one-off manual edit in Canva after filling the template — not something
this pipeline should turn into a field on a hunch.

## Photo sourcing — always Giusi's real photo (confirmed 2026-09-22)

Unlike the carousel's 50/50 landscape-vs-photo split, **every reel uses
Giusi's real photo on every image field** — there is no landscape variant
for this format. Source from `generate-workbook/references/media_library.md`
the same way the carousel does, picking whichever subfolder's mood matches
the episode. Default pattern, matching the real example:

- `sfondo_hook` and `sfondo_cta` — the same photo (bookend consistency).
- `sfondo_quote` — can be the same photo or a different shot from the same
  session/subfolder for a little variety; judgment call, no fixed rule.

Never fall back to a generated/stock landscape for this format.

## Export / video (out of scope for `generate-social-reel`)

This template's pages are **static** (`type: "fixed"`, no video elements).
The Canva API has no operation to set per-page duration, transitions, or
audio — those must be set **once, by hand, in Canva**, directly on this
brand template (`EAHV8Iu7jbk`), so every reel instantiated from it inherits
the same fixed pacing automatically. `generate-social-reel` never calls
`export-design` — per Giusi (2026-09-22), the MP4 export is a job for
whatever mechanism eventually handles the Make hand-off for reels (not yet
built, same status as the carousel's Make scenario), not for the drafting
skill. `generate-social-reel` stops at a filled Canva design and its edit
URL, exactly like `generate-social-post` stops before touching Make.

## Editing gotchas

Same mechanics as the carousel template (see
`hdh-social-copy/references/social_carousel_template.md`'s "Editing
gotchas") — verify every `edit-design` call's after-thumbnail against intent,
re-read `page_metadata` if a page count ever looks off after a commit, and
never mark a `posting_log.md` entry as done before the commit has actually
succeeded.

## Verified 2026-09-22

Confirmed via `get-brand-template-dataset`: all 6 fields above are live and
correctly typed on `EAHV8Iu7jbk`. Confirmed via `create-design-from-brand-
template` that instantiating the template produces a clean 3-page design
with placeholder text/images on exactly the tagged fields.
