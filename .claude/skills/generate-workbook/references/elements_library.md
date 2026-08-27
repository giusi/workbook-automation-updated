# Monthly decorative element (`completamenti_elemento`)

Source for the workbook's one rotating decorative-graphic field,
`completamenti_elemento`, on page 14 (the `completamenti` page — the last
line under "Porta con te questo:"). Same pattern as the background-photo
library in `media_library.md`, but for a Canva **Element** (a single-color
line-art graphic) instead of a photo. All access is via the connected
**Canva MCP integration**.

## Status: field not yet tagged in the brand template

As of this writing, `completamenti_elemento` does **not** exist in the
brand template's (`EAHNaGY-7DM`) autofill dataset
(`mcp__Canva__get-brand-template-dataset`) — confirmed by reading it, only
the 34 text fields plus `sfondo_cover`/`sfondo_impressum` show up. The
connected Canva account also lacks edit permission on the brand template
(`mcp__Canva__create-brand-template-draft` returns a permission error), so
this can't be tagged programmatically right now.

**Giusi tags it manually in Canva:**
1. Open the brand template → **More → Edit Brand Template**.
2. Go to page 14 (the `completamenti` page) and select the decorative
   line-art graphic below "Porta con te questo:" — the same element shown
   selected in her screenshot (a thin gold line-art illustration, currently
   the Canva stock element with media id `MAFXbFoS2QA`, recolored from
   black to the brand gold `#c99e46`).
3. Use Canva's "Connect data" / autofill-field option on that element and
   name the field **`completamenti_elemento`**, type **image**.
4. **Republish** the brand template.

Once that's done, tell a future run of this skill — it'll show up in
`get-brand-template-dataset` and the fill step (`canva_mcp_fill.md`) can
treat it exactly like `sfondo_cover`/`sfondo_impressum`: `update_fill` by
`locator_id`, no drafting needed.

## Element geometry (must match when swapping)

Read from the September 2026 design instance (`DAHTd_okOYY`, page 14,
locator `LBBnCNvLwQ6S0tCp` inside page `PBLRmfhnjtDQNrPs`) — use this to
judge whether a replacement element will look right:
- It's a `rect` element with an image **fill** (not a plain inserted
  image) — `fill.media.type: "image"`, `fill.media.mediaId: "MAFXbFoS2QA"`.
- **Single-color recoloring is applied**: `fill.media.recoloring:
  {"#000000": "#c99e46"}` — the source graphic is pure black line-art, and
  Canva recolors it to the brand gold at render time. Only pick
  replacement elements that are single-color (black) line-art / one-line
  illustrations for this to keep working — a multi-color or shaded
  graphic won't recolor cleanly with a one-hex-swap.
- Box: width 132.75px, height 298.32px, **rotated 90°** (so it reads as a
  roughly wide-and-short illustration once rotated upright).
- Sits directly below the `completamenti` text box on the page, above the
  page-number footer.

## Curated folder

Root: **`Giusi - Elementi pagina completamenti`** — id `FAHTeLzym44`
(`https://www.canva.com/folder/FAHTeLzym44`), created as a sibling of the
photo-library folder under `FAHSRkksV60` ("For Claude"). Empty as of
creation — this mirrors `media_library.md`'s photo folders: a one-time
manual curation pass, not something Claude can populate itself (there's no
MCP tool to browse Canva's stock Elements library).

**Giusi (or a human) populates it once, then maintains it occasionally:**
browse Canva's Elements panel for single-color line-art graphics (faces,
florals, nature line drawings — whatever fits the "one continuous gold
line" aesthetic of the current element), save 8-15 of them into this
folder. More variety = less repetition month to month.

**Filling step, once both the tagging (above) and the folder have
content:**
1. `mcp__Canva__list-folder-items(folder_id: "FAHTeLzym44", item_types:
   ["image"])` to see the curated options.
2. Pick one that fits the month's `tema` if any obviously do, otherwise
   pick for variety (avoid repeating last month's choice — check the
   previous design's page 14 if unsure).
3. `update_fill` on the `completamenti_elemento` locator with the chosen
   asset id, same mechanics as `canva_mcp_fill.md` step 6 for the
   background photos — except this element is expected to already carry
   `recoloring: {"#000000": "#c99e46"}`; if a newly placed element doesn't
   pick up the recolor automatically, a `recolor_element` operation
   (target color `#c99e46`) after the `update_fill` should do it, but only
   if the graphic is genuinely single-color — check the thumbnail.
4. Verify via thumbnail like any other field.

## Maintaining this library

Same maintenance model as `media_library.md`'s photo folders: a manual
curation task, not a routine part of every monthly fill. Don't go
trawling Canva's general Elements search inline during a fill — if the
folder runs low on unused options, flag it in the run's report rather
than expanding it yourself.
