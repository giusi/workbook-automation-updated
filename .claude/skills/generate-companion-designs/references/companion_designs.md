# The 3 companion brand templates

Bootstrapped from the August 2026 edition of each design (Phase 0, done
once — see `SKILL.md`'s Notes for the tag-then-publish order this required).
Re-verify field names with `get-brand-template-dataset` each run rather than
trusting this file blindly — the template can change, same caveat
`canva_mcp_fill.md` gives for the workbook template.

## HDH Tiles

- Brand template id: **`EAHTfUMzvZo`**
- 9 pages, landscape (1920×1080)
- Naming convention: `HDH <MESE MAIUSCOLO>  Tiles` (note the double space
  before "Tiles" in every existing edition — mirror it, don't "fix" it)
- Tagged fields:

  | Page | Field | Type | Content |
  |---|---|---|---|
  | 1 (cover) | `tema_del_mese` | text | Theme phrase, e.g. "Digital detox: il coraggio del riposo sacro" — same value as the workbook's `cover_subtitle` |
  | 1 (cover) | `sfondo_tema` | image | Giusi's photo — reuse the workbook's `sfondo_cover` asset |
  | 2 ("Diretta del mese con Giusi") | `tema_del_mese` | text | Same theme phrase (reused label, second occurrence) |
  | 2 | `sfondo_diretta` | image | Giusi's photo — reuse the workbook's `sfondo_cover` (or `sfondo_impressum`) asset |
  | 3 ("Domande e Risposte con Giusi") | `tagline_secondaria` | text | Fresh-drafted tagline, e.g. "Fiorisci nella presenza: il potere del qui e ora" — NOT a verbatim workbook field, draft new each month (see SKILL.md step 2) |
  | 3 | `sfondo_domande` | image | Giusi's photo — reuse a workbook asset |
  | 4 (Happy Daily Body / Nuovi allenamenti) | — | — | **Out of scope, untagged.** Generic stock photo, not Giusi. Never touch. |
  | 5 (Movimento con Annalisa) | `tagline_secondaria` | text | Same tagline (reused label, second occurrence) |
  | 5 | — | — | Annalisa's photo — **out of scope, untagged, never touch** |
  | 6 (Yin Yoga / Con Yamuna) | — | — | **Out of scope, untagged.** Yamuna's photo. Never touch. |
  | 7 (Danza Libera / Con Yamuna) | — | — | **Out of scope, untagged.** Yamuna's photo. Never touch. |
  | 8 (Intenzione) | `intenzione_testo` | text | Same value as the workbook's `intenzione_testo` |
  | 9 (Mantra) | `mantra_testo` | text | Same value as the workbook's `mantra_testo` |

  Pages 8–9 also have a decorative background photo (not Giusi, not tagged)
  — leave those alone; only the 3 fields on pages 1–3 are Giusi's photos and
  in scope.

## Intenzione e Mantra

- Brand template id: **`EAHTfSDPe9o`**
- 2 pages, landscape (1920×1080), flat gradient backgrounds (no photos at all)
- Naming convention: `Intenzione e Mantra <Mese>  <anno>` (double space
  before the year)
- Tagged fields:

  | Page | Field | Type | Content |
  |---|---|---|---|
  | 1 ("MANTRA del mese") | `mantra_testo` | text | Same value as the workbook's `mantra_testo` |
  | 2 ("Intenzione del mese") | `intenzione_testo` | text | Same value as the workbook's `intenzione_testo` |

## Mobile Mantra e Intenzione

- Brand template id: **`EAHTfcldO_8`**
- 2 pages, portrait (1080×1920), flat gradient backgrounds (no photos at all)
- Naming convention: `Mobile Mantra e Intenzione HDH <Mese>  <anno>`
  (double space before the year)
- Tagged fields:

  | Page | Field | Type | Content |
  |---|---|---|---|
  | 1 ("Intenzione del mese") | `intenzione_testo` | text | Same value as the workbook's `intenzione_testo` |
  | 2 ("MANTRA DEL MESE") | `mantra_testo` | text | Same value as the workbook's `mantra_testo` |

  Note the page order is reversed relative to the desktop Intenzione e
  Mantra design (intention first, then mantra) — don't assume the two
  designs mirror each other page-for-page.

## Parent gallery folder

All monthly folders (e.g. `SETTEMBRE 2026`, `AGOSTO 2026`) live directly
under one parent folder: id **`FAF67DAHCKg`**
(`https://www.canva.com/folder/FAF67DAHCKg`). Each month's folder is named
`"<MESE MAIUSCOLO> <anno>"` and holds exactly 4 designs: the workbook plus
these 3 companions.

## Known gotchas (confirmed on the October 2026 test run — expect these every time)

- **`replace_text` drifts `text_align` from `center` to `start` on several
  fields, not just occasionally.** Hit on Tiles pages 8 (`intenzione_testo`)
  and 9 (`mantra_testo`) in the October test — both came back left-aligned
  after `replace_text` even though the template has them centered. Always
  follow every `replace_text` on a `mantra_testo`/`intenzione_testo`/
  `tagline_secondaria` field with a `format_text` call setting
  `text_align: "center"` (plus `font_weight`/`font_style: "normal"`, same
  normalize habit as the workbook fill) — don't treat this as optional or
  wait to see if it happens; bundle it into the same edit as the
  `replace_text`, not a reactive follow-up pass.
- **Font family drifts on `intenzione_testo` specifically, every time so
  far.** Hit on all 3 designs in the October test (Tiles page 8, Intenzione
  e Mantra page 2, Mobile page 1) — the field's `fontRef` changed to a
  different (sans-serif-looking) font after `replace_text`, while
  `mantra_testo` and `tagline_secondaria` kept the correct serif in the same
  run. Same root cause as the workbook's font-family gotcha
  (`canva_mcp_fill.md`) — not fixable via `format_text` (no font-family
  parameter exists on this API). Flag it in the report every run rather than
  re-attempting a fix; the durable fix is Giusi resetting that field's font
  in Canva's editor directly, once, on the brand template itself.
- **Autoshrink can hit `intenzione_testo` on the Mobile design specifically,
  and it's severe.** In the October test, Mobile page 1's `intenzione_testo`
  collapsed to ~12px (from ~85px) and its box height collapsed to ~14px
  after a plain `replace_text` — same bug class as the workbook's
  `sez2_titolo`/`sez3_titolo` autoshrink, but worse (text was reduced to an
  unreadable sliver, not just small). Fix: `format_text` with an explicit
  `font_size` restored to the field's original value (~85 for Mobile
  `intenzione_testo`, ~88 for Mobile `mantra_testo` — re-check the actual
  pre-edit value each run rather than hardcoding these) bundled into the
  same `text_align`/weight/style normalize call. Always pull the thumbnail
  after every text fill on this design and check for a collapsed/tiny box
  before moving to the next page — don't assume it only happens
  occasionally.
- **Net practical rule:** for every `mantra_testo`/`intenzione_testo`/
  `tagline_secondaria` field on any of these 3 designs, follow
  `replace_text` with one `format_text` call in the same `edit-design`
  request setting `text_align: "center"`, `font_weight: "normal"`,
  `font_style: "normal"`, and (Mobile design only, both fields) an explicit
  `font_size` matching the pre-edit value. Verify via thumbnail before
  moving to the next page regardless.

## Phase 0 leftovers (informational, not needed for routine runs)

Two earlier brand-template creation attempts failed after the template
object itself was created (a Canva connector permission gap on the
create-brand-template-draft/edit-existing-template path — see SKILL.md's
Notes) and were abandoned untagged: `EAHTfHMWnHg` and `EAHTfX_oF5w`. There's
no delete-brand-template tool available to clean these up; they're inert
(empty dataset, never referenced by this skill) and safe to ignore. A
folder, **`HDH Companion Templates - Tagged (ready to publish)`**
(id `FAHTfezVMbU`), also holds one saved, independently-editable tagged
copy of each of the 3 designs above (for Giusi to inspect or manually
publish herself if she ever wants to replace the API-created templates) —
also not needed for routine runs of this skill.
