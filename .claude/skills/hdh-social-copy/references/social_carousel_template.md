# Master social carousel — Canva brand template

Brand template id **`EAHT9Ay4G_4`** — https://www.canva.com/brand/brand-templates/EAHT9Ay4G_4

7 pages, 1080x1350 (portrait, 4:5 — standard IG/FB feed carousel ratio). Built
from Giusi's real "Sei al mare" carousel (`DAHOyBIZkx4`) via `copy-design`, so
the visual DNA (full-bleed photo, white bold text, `@giusivalentinicoach`
watermark, comment-keyword CTA slides) matches her actual posting style —
this is not a from-scratch design.

Fill via the same mechanism as `generate-workbook`/`generate-companion-designs`:
`create-design-from-brand-template` → `read-design` (open transaction) to get
locator_ids → `edit-design` with `replace_text` per field → `update_fill` for
the two image fields → commit.

## Fields

| Page | Field | Type | Notes |
|---|---|---|---|
| 1 | `hook_testo` | text | Hook slide — must stand alone, no stakkato (see hdh-social-copy SKILL.md) |
| 1–5 | `sfondo_narrativo` | image | **Same field label on all 5 narrative pages** — one photo fills all of them, matching how Giusi's real carousels repeat one background throughout. See "Background photos" below for sourcing. |
| 2 | `valore1_testo` | text | Value slide 1 |
| 3 | `valore2_testo` | text | Value slide 2 |
| 4 | `valore3_testo` | text | Value slide 3 |
| 5 | `chiusura_testo` | text | Closing thought, before the CTA slides |
| 6 | `cta_podcast_titolo` | text | Episode title |
| 6 | `cta_podcast_azione` | text | The comment-keyword line, e.g. `Scrivi "podcast" nei commenti e ascolta l'ultimo episodio` — reuse Giusi's existing keyword system (see business context notes: MEDITARE, MATTINA, PODCAST, CASA, RITIRO) |
| 6–7 | `sfondo_cta` | image | Shared across both CTA slides |
| 7 | `cta_masterclass_header` | text | New — e.g. "MASTERCLASS GRATUITA" |
| 7 | `cta_masterclass_azione` | text | New — e.g. `Scrivi "MASTERCLASS" nei commenti` (new keyword, once the masterclass funnel exists) |
| 7 | `mese_anno_tag` | text | **Dynamic month tag** — generate from the run date (e.g. "Settembre 2026"), never hardcode |

Only 4 value slides total (hook + 3 + closing) in this v1 — Giusi's real
carousels run longer (8-9 narrative beats), so extending this is just
duplicating the pattern (add a page, tag `valoreN_testo` + `sfondo_narrativo`
on it) — not a redesign.

## Background photos — sourcing (open question, resolved per-run, not pre-curated)

There is **no static shared photo library** for these two fields — confirmed
by testing (see below), the photo must be grounded in that specific post's
actual theme (mantra/intenzione/cover for a workbook-topic post, episode
content for a podcast-topic post), not pulled from one generic pool.

- **Portraits / personal shots** — draw from the workbook's photo library
  (`FAHSRkksV60`, see `generate-workbook/references/media_library.md`) —
  confirmed fine to reuse across both pipelines, no meaningful overlap with
  the separate "Fotos" folder (which is thin — 2 images, not a real source).
- **Landscape / mood shots with no people** — no dedicated folder exists;
  Giusi's real posts pull these from Canva's stock library directly (verified
  by inspecting the asset metadata on her real "Sei al mare" background —
  full stock tag set, no personal ownership marks). There is no stock-search
  MCP tool available, so `generate-social-post` should use `generate-design`
  (design_type `instagram_post`) grounded in that post's real theme (mantra/
  cover palette, not literal keyword-illustration — see below), generate a
  batch of candidates, and **let Giusi pick** rather than auto-selecting.
  About half of generated candidates come back unusable (baked-in text,
  decorative frames, or illustrated rather than photographic style) — those
  get discarded, not shown.
- **Grounding without being literal**: matching the month's actual mantra/
  cover palette and light quality works well; instructing the generator
  toward the *literal* metaphor (e.g. "sowing seeds" → actual soil/crop
  imagery) produces stock-photo-cliché results that don't match Giusi's more
  atmospheric real photography. Ground the prompt in mood/palette/light, not
  literal subject matter.

## Verified 2026-09-01

Confirmed via `get-brand-template-dataset`: all 12 fields above are live and
correctly typed on `EAHT9Ay4G_4`.
