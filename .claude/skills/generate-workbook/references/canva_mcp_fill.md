# Filling the HDH workbook Canva template via MCP

Procedure for step 5 of `SKILL.md`. There is no Python pipeline in this repo
anymore (removed — see `SKILL.md`'s Notes section) — this uses the connected
Canva MCP integration (`mcp__Canva__*` tools) only, no OAuth/`.env`/local
service of any kind.

## 1. Get the 34 field values

Assemble them per `references/field_assembly.md` — direct copies for most
fields, fixed scaffolding (numbering, dotted answer lines, connective phrases)
added on top of your drafted text for `sezN_esercizi`, `esercizio_finale`, and
`completamenti`. This is plain text work, no code required. Keep the 34 values
in memory (or jot them to `out/workbook-<YYYY-MM>.json` if that helps you track
state across a long session) — you'll use them directly in the `replace_text`
operations in step 5 below. Check each body field against its budget in
`field_assembly.md` before filling; revise and re-check rather than shipping an
out-of-range field.

## 2. Locate the template

Brand template id: **`EAHNaGY-7DM`** (title shows as "WB HDH \<last-used-month\>").
Confirm with `mcp__Canva__get-brand-template-dataset` if you want to re-verify
field names — the live dataset has **47 fields**, not 34: extra numbered variants
per section (`sez2_testo_3`, `sez2_testo_4`, `sez1_esercizi_1`, `sez1_esercizi_2`,
etc.) and 2 background image fields (`sfondo_cover`, `sfondo_impressum`) — both
get a photo, see step 6 below and `references/media_library.md` for where the
photos live. Page 2 has no background image element (only text elements and a
decorative vector shape), so there is no third `sfondo_*` field — an earlier
version of this template briefly had a stray, unusable `sfondo_pagina2` field
declared with nothing to connect it to; it's been removed.

## 3. Create a design instance

```
mcp__Canva__create-design-from-brand-template  brand_template_id: "EAHNaGY-7DM"
```

This returns a `design_id` (starts with `D`) and a 15-page design pre-filled with
the previous edition's sample content (not blank placeholders).

## 4. Map fields to elements

Open one editing transaction and keep reusing its `transaction_id` for every
edit:

```
mcp__Canva__read-design  design_id: <id>  open_transaction: true
  filter.fields: ["design_content"]  filter.page_indices: [1]
```

Read pages one at a time (or in small batches) via `read-design` with the same
`transaction_id`. Text elements that are autofill targets carry a
`dataFieldLabel: "<field_name>"` annotation directly in the markdown — match it
against the field dict from step 1. Page layout (as of the last fill):

| Page | Fields |
|---|---|
| 1 | `cover_subtitle`, `sfondo_cover` (image) (no `cover_title` field exists anywhere — see gotcha below) |
| 2 | `mantra_testo`, `intenzione_testo` (no background image field on this page — see step 2's note) |
| 3 | `lettera_testo_1`, `lettera_testo_2` |
| 4 (TOC) | `toc_1`–`toc_4` — **see disambiguation gotcha below** |
| 5 | `sez1_titolo`, `sez1_citazione`, `sez1_testo_1`, `sez1_testo_2` |
| 6 | `sez1_esercizi` |
| 7 | `sez2_titolo`, `sez2_citazione`, `sez2_testo_1`, `sez2_testo_2` |
| 8 | `sez2_esercizi` |
| 9 | `sez3_titolo`, `sez3_citazione`, `sez3_testo_1`, `sez3_testo_2` |
| 10 | `sez3_esercizi` |
| 11 | `sez4_titolo`, `sez4_citazione`, `sez4_testo_1`, `sez4_testo_2` |
| 12 | `sez4_esercizi` |
| 13 | `integrazione_testo_1`, `integrazione_testo_2`, `esercizio_finale` |
| 14 | `completamenti` |
| 15 | impressum/colophon — `sfondo_impressum` (image) |

Re-verify this layout rather than trusting it blindly — the template can change.
Both image fields (`sfondo_cover` on page 1, `sfondo_impressum` on page 15) show
up as **image** elements carrying the same `dataFieldLabel` annotation as text
fields — spot them in the `read-design` output by `type: "image"` rather than
`type: "text"`. Note their `locator_id`s alongside the text fields' while you're
reading each page; you'll need them in step 6.

## 5. Apply edits

For each page, one `mcp__Canva__edit-design` call with `page_index` set and
`operations: [{type: "replace_text", element_id: <locator_id>, text: <value>}, ...]`
for every field on that page, `finalize: "keep_open"`. `element_id` is the
locator id shown in brackets in the `read-design` output, e.g.
`PBhq7xcTvPR0HS9f-LBFYH72pn9PnlXsf` for `[PBhq7xcTvPR0HS9f-LBFYH72pn9PnlXsf]`.

## 6. Select and place the background photos

Do this after step 5's text edits (same open transaction is fine). Both
image fields get filled: `sfondo_cover` (page 1) and `sfondo_impressum`
(page 15). Page 2 has no background image field at all — its only background
element is a decorative vector shape (a flat color fill, not an image), so
there's nothing to place there; don't go looking for a third `sfondo_*` field.

As of the November 2026 fix, page 1's background rect is correctly labeled
`sfondo_cover` in the live template's `dataFieldLabel` — the earlier drift
where it carried the (now-removed) `sfondo_pagina2` label has been corrected
directly in the brand template. Still worth spot-checking with
`get-brand-template-dataset` / a `read-design` on page 1 before a fill, in
case it drifts again — `update_fill` targets by `locator_id`, not by label,
so a mismatch doesn't block filling, but it's a signal something changed
upstream in Canva's editor.

1. **Pick photos.** Follow `references/media_library.md` to choose a subfolder
   matching the month's `tema`, then `mcp__Canva__list-folder-items` that
   subfolder and pick one photo for `sfondo_cover` and one for `sfondo_impressum`
   (the same photo for both is fine, or two different ones from the same
   subfolder — see that doc). Note each photo's asset id (`MA...`).
2. **Place each photo** with one `edit-design` operation per field:
   ```
   operations: [{
     type: "update_fill",
     element_id: <locator_id of the sfondo_* image element>,
     asset_type: "image",
     asset_id: <chosen photo's asset id>,
     alt_text: "<short description, e.g. 'Giusi Valentini, ritratto professionale'>"
   }]
   ```
   Target the same `page_index` the element lives on (per the table above) —
   `sfondo_cover` on page 1's call, `sfondo_impressum` on page 15's (its own
   call, since page 15 otherwise has no text edits).
3. **Verify via thumbnail** like any other page edit — pull the page thumbnail
   and check the photo landed, isn't stretched/cropped oddly, and reads well
   under the existing text overlay (title/impressum text sits on top of these
   backgrounds, so a very busy or high-contrast photo can hurt legibility;
   prefer photos with a calmer background area behind where the text sits).
4. If a chosen photo doesn't read well once placed, just pick a different one
   from the same subfolder and redo the `update_fill` — it's a cheap operation
   inside the still-open transaction, nothing is committed yet.

## 7. Known gotchas (hit these on the first fill — check for them every time)

- **`toc_1`..`toc_4` are reused on non-target elements.** On the TOC page, some
  elements tagged `toc_1` etc. hold the actual section subtitle (replace these),
  but *other* elements share the same label while holding fixed structural text
  like "SEZIONE 1" or "Integrazione finale" (do **not** touch these — they're
  static headings, not content slots). Disambiguate by the element's *current*
  text: if it reads as a themed phrase, it's real content; if it's a generic
  structural label, skip it.
- **`cover_title` has no field anywhere.** Confirmed by reading all 15 pages —
  there is no `dataFieldLabel="cover_title"` element in this template. The large
  cover heading is tagged `cover_subtitle`. Don't spend time hunting for it every
  run; just note it in the final report as before.
- **`replace_text` can trigger Canva's autoshrink** on some title-sized text
  boxes, collapsing the font to ~1px even when the new text is *shorter* than the
  old — this happened on `sez2_titolo` and `sez3_titolo` in the first fill,
  and hit the exact same two fields again in the October 2026 fill. Treat
  this as an expected, deterministic step for `sez2_titolo`/`sez3_titolo`
  specifically, not a rare fluke — always pull a page thumbnail (`read-design`
  with `filter.fields: ["thumbnails"]` and the transaction_id) after editing
  each page and eyeball it; if text has vanished or shrunk, fix with a
  `format_text` operation setting an explicit `font_size` back to a sane
  value (title fields on this template render around 27px).
- **Formatting leaks from the old content on every `esercizi`/
  `completamenti`/`esercizio_finale` field, not just occasionally.** These
  fields hold multi-run rich text (bold numbered headers, differently-colored
  prompts); `replace_text` collapses the whole block into the first run's
  formatting, so the entire field comes back bold and gold-colored, dots
  included. Always follow up with a `format_text` call normalizing to
  `font_weight: "normal"` / `color: "#000000"` on that same element — see
  `field_assembly.md` for the fuller note. Don't skip this expecting it to be
  fine "most of the time"; it wasn't fine on any of the 6 fields of this type
  in the October 2026 fill.
- **`cover_subtitle` has no documented character budget but visibly needs
  one.** A longer subtitle (~78 characters) grew the text box tall enough to
  overlap the "GIUSI VALENTINI" byline beneath it — Canva doesn't autoshrink
  this box the way it does section titles, it just lets the box grow and
  collide. Keep `cover_subtitle` close to June's original length (~59
  characters) as a practical ceiling, and check the page 1 thumbnail for
  overlap with the byline before committing.
- **Font family isn't settable via the API.** `format_text` can set size,
  weight, style, color, alignment, etc., but not the font family — if a text
  element is rendering in the wrong typeface, that has to be fixed by hand in
  Canva's editor, not through MCP. Size/weight/style are fine to fix
  programmatically (as in the autoshrink and stray-bold cases above).
- **Resized/repositioned boxes only help if they still span the intended text
  area.** This doesn't come up in routine fills (`replace_text` doesn't move or
  resize boxes), but if you ever restructure the template — add a section,
  split a box — a box that's the wrong size will visibly under-fill or overflow
  even with correctly length-budgeted text. Worth remembering if the template
  layout ever changes.

## 8. Finish

1. Rename the design: one `edit-design` operation with `type: "update_title"`,
   `title: "WB HDH <Label>"` (e.g. "WB HDH Agosto 2026").
2. Do a final visual pass — pull thumbnails for a few representative pages.
3. Commit: `edit-design` with empty `operations` and `finalize: "commit"`. This
   is irreversible for this design instance, but the instance itself is a
   disposable copy of the brand template (not the template itself) — a mistake
   here doesn't damage the brand template.
4. **Edit URL:** the `edit_url`/`view_url` fields returned by Canva MCP calls are
   short links that regenerate on every call — don't rely on them as a stable
   reference. Use the canonical, stable form instead:
   `https://www.canva.com/design/<design_id>/edit`.
