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
| 1–5 | `sfondo_narrativo` | image | Same field *label* on all 5 narrative pages, but **each page's fill is set independently** (each has its own locator_id even though the label repeats) — normally one photo fills all 5 for consistency, but this is also how the hook page can carry a different image (Giusi's photo) than pages 2–5 (landscape). See "Giusi's photo pattern" below. |
| 2 | `valore1_testo` | text | Value slide 1 |
| 3 | `valore2_testo` | text | Value slide 2 |
| 4 | `valore3_testo` | text | Value slide 3 |
| 5 | `chiusura_testo` | text | Closing thought, before the CTA slides |
| 6 | `cta_podcast_titolo` | text | Episode title |
| 6 | `cta_podcast_azione` | text | The comment-keyword line, e.g. `Scrivi "podcast" nei commenti e ascolta l'ultimo episodio` — reuse Giusi's existing keyword system (see business context notes: MEDITARE, MATTINA, PODCAST, CASA, RITIRO) |
| 6–7 | `sfondo_cta` | image | Same field *label* on both CTA pages, but — like `sfondo_narrativo` above — **each page's fill is independently settable**. Page 6 (podcast CTA) normally stays pure landscape; page 7 (masterclass CTA) is the second photo slot on a "photo post". Don't assume setting one fills both. |
| 7 | `cta_masterclass_header` | text | New — e.g. "MASTERCLASS GRATUITA". If Giusi gives a live/event date, add it here as a second line (`MASTERCLASS GRATUITA\n24 SETTEMBRE`) rather than editing the azione line — see "Editing gotchas" below for the safe wrap pattern. |
| 7 | `cta_masterclass_azione` | text | New — e.g. `Scrivi "MASTERCLASS" nei commenti` (new keyword, once the masterclass funnel exists) |
| 7 | `mese_anno_tag` | text | **Dynamic month tag** — generate from the run date (e.g. "Settembre 2026"), never hardcode |

Only 4 value slides total (hook + 3 + closing) in this v1 — Giusi's real
carousels run longer (8-9 narrative beats), so extending this is just
duplicating the pattern (add a page, tag `valoreN_testo` + `sfondo_narrativo`
on it) — not a redesign.

**Every carousel always ends with exactly these 2 CTA slides** (podcast, then
masterclass) — never 1, never 0, regardless of style or how short the
narrative arc is. Both pages always carry real, non-placeholder content
(title/action text, a real fill on `sfondo_cta`), which also keeps them safe
from the page-auto-pruning behaviour described below.

**Always rename the design's title** away from whatever it inherited from
the brand template (a leftover title from whichever real post the template
was last derived from) to this post's actual title —
`HDH <Mese> — Post <N> — <hook breve>` — via `update_title`, right after the
text fields are filled. Do this before handing the edit URL to Giusi; a
design still carrying the template's old title is a sign the fill wasn't
finished.

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

## Giusi's photo pattern (confirmed 2026-09-03)

When a batch of posts is generated together (e.g. a month's worth in one
run), split it **exactly half and half**:

- **Half the posts** use one of Giusi's real photos (from
  `generate-workbook/references/media_library.md` — the "Casual Dez20 e
  Journal" and "Retreat Maggio 2024" subfolders have read well for this so
  far) **only on page 1 (`sfondo_narrativo`, hook) and page 7 (`sfondo_cta`,
  masterclass CTA)**. Pages 2–6 stay pure landscape even on these posts —
  never put her photo on a middle narrative page or the podcast CTA page.
- **The other half** stay pure landscape throughout, exactly as described
  above.

When generating one post at a time (not as part of a batch), keep the
running ratio in `posting_log.md` close to half — check the last several
entries' `Sfondo` lines before deciding this post's pattern.

**Landscape/photo tone pairing** — use this fixed pairing as the default so
the palette stays consistent across the feed, generating a new landscape
candidate only if a future photo's tone doesn't fit either:

| Background | Asset id | Tone | Pairs with |
|---|---|---|---|
| Background A | `MAEH0gshJfI` | Warm — green fields, golden/veiled sky | Warm-toned photos (daylight, golden hour, warm clothing) |
| Background B | `MAHUIYnuU7Y` | Cool — misty forest canopy | Cool/shadowed photos (overcast light, greens/blues, indoor shade) |

## Editing gotchas (confirmed 2026-09-03)

- **Canva `M/...` links are asset links, not design shortlinks.** A URL like
  `canva.com/M/<id>` that Giusi pastes (e.g. to point at a reference photo)
  will make `resolve-shortlink` fail with a 307 error. Skip it — call
  `get-assets` directly with the trailing id as the asset id; it resolves
  fine and returns the thumbnail.
- **Untouched pages get silently pruned on commit.** If a page is left
  carrying only its default/placeholder content (e.g. a `valore3` page never
  touched because a post only needed 2 value slides), Canva drops it when
  the transaction commits — and every later page's `page_index` and
  locator_ids shift down to fill the gap. Never assume the brand template's
  original page numbering still holds after a commit; re-read the design
  (`page_metadata` or a fresh `design_content`) before editing it again. If a
  narrative page must stay genuinely empty on purpose, put a single space
  `" "` in its text field rather than leaving the placeholder — that's
  enough to prevent pruning while keeping it visually blank.
- **Long header text wraps by line, not by width estimate.** For
  `cta_masterclass_header`, adding a short date line is safe as an explicit
  `\n`-separated second line (`MASTERCLASS GRATUITA\n24 SETTEMBRE`) — the
  text box already accommodates 2 lines at that field's font size. Don't try
  to estimate character-width wrapping; use an explicit line break for any
  short added line.

## Verification and logging discipline (confirmed 2026-09-03)

- After every `edit-design` call, actually compare the returned
  after-thumbnail against what you intended — don't just check that the
  tool call didn't error.
- Only write a `Stato` of "complete"/"testo e design completi" into
  `posting_log.md` **after** the `edit-design` transaction has been
  committed (`finalize: "commit"` returned `status: "committed"`) and you've
  visually verified it. Never log a post as done based on the plan for what
  you're about to do — a run got interrupted mid-batch once this way, and
  the log ended up describing several pages as filled when they still held
  placeholder text.

## Verified 2026-09-01

Confirmed via `get-brand-template-dataset`: all 12 fields above are live and
correctly typed on `EAHT9Ay4G_4`.
