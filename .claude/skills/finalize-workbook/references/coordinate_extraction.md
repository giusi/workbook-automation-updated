# Finding answer-line coordinates

`add_form_fields.py` needs a `fields.json` of `{page, field_name, rect}` in
**PDF points, y=0 at the bottom of the page** (standard PDF coordinate
space — not Canva's, not image pixels). This is how to build that file.

## Which pages have answer lines

Per `generate-workbook`'s template map (`references/canva_mcp_fill.md` in
that skill), the pages with hand-fill answer lines are the exercise pages —
6, 8, 10, 12 (`sez1_esercizi`..`sez4_esercizi`, 4 exercises each) — plus the
completions on 13 (`esercizio_finale`) and 14 (`completamenti`). Re-verify
against the live design rather than trusting this blindly; the template can
change.

## Tier 1 — read exact geometry from Canva (preferred)

While the design is still open (before or instead of exporting), call
`read-design` with `open_transaction: true` and `filter.fields:
["design_content"]` on one of the exercise pages. Each element in the
response carries geometry. Check whether the dotted answer lines are their
own addressable elements (distinct from the prompt text elements) — if so,
their `rect`/position/size in the response *is* your source of truth, no
guessing needed.

Canva's page coordinate origin is **top-left, y increasing downward**, and
its units may not be PDF points 1:1. Convert using the page's actual export
size:
```
pdf_x0 = canva_x / canva_page_width  * pdf_width
pdf_x1 = (canva_x + canva_w) / canva_page_width * pdf_width
pdf_y0 = pdf_height - ((canva_y + canva_h) / canva_page_height * pdf_height)   # PDF y=0 is bottom
pdf_y1 = pdf_height - (canva_y / canva_page_height * pdf_height)
```
Get `pdf_width`/`pdf_height` from the exported PDF itself (see Tier 2's
`get_page_sizes.py` — run it regardless of which tier you end up using, you
need real page sizes either way). Get `canva_page_width`/`canva_page_height`
from `read-design`'s `page_metadata`.

If the lines are **not** distinct elements (e.g. baked into a background
frame graphic), fall back to Tier 2.

## Tier 2 — detect lines in the exported flat PDF (fallback)

Once you have the flat PDF (`export-design` → download), reuse the `pdf`
skill's structure extractor rather than writing a new one:

```
python3 /mnt/skills/public/pdf/scripts/extract_form_structure.py <workbook.pdf> structure.json
```

This finds horizontal line segments and their exact PDF-coordinate
bounding boxes (`lines` in its output) along with any text `labels` nearby.
Cross-reference against the exercise prompt text (from the field values you
already assembled in `generate-workbook`) to match each detected line to
the exercise/blank it belongs to, in page order.

Build each field's `rect` as a box sitting *on* the line: same x-span as
the line, `y0` a few points above the line (room for one line of typed
text), `y1` a few points below it (so the line stays visible as underline
once printed/typed-over). Example: a detected line at `y=402` running
`x=72`–`520` → `rect: [72, 396, 520, 408]`.

## Tier 3 — visual estimation (last resort)

Only if Tier 2 finds nothing usable (rare — these are simple, machine-
generated vector PDFs, not scans). Render pages to PNG
(`python3 /mnt/skills/public/pdf/scripts/convert_pdf_to_images.py`) and
estimate pixel coordinates by eye, then convert to PDF points using the
image/page dimension ratio. See the `pdf` skill's `FORMS.md` "Approach B"
for the full zoom-and-refine procedure — it's written for the same kind of
coordinate problem.

## Field naming

Use a stable, descriptive scheme so a human glancing at `fields.json` (or
reduced field names in an Acrobat "Add text field" panel) can tell what
each one is: `sez<N>_ex<M>_line<L>` for exercise answer lines (e.g.
`sez2_ex3_line1`), `esercizio_finale_line<L>`, `completamenti_line<L>`.
Every `field_name` must be unique across the whole document —
`add_form_fields.py` rejects duplicates.

## Multi-line vs single-line fields

Exercise prompts get one field per printed dotted line (several short
fields stacked, matching how many lines the template prints under each
prompt) — a single tall multiline field would let someone's answer to line
2 visually run into line 3's space with no cue where to break, so match the
template's own line count instead of collapsing them. `completamenti` and
`esercizio_finale` are the exception: those templates print one continuous
ruled area per completion sentence, so one field per sentence-blank is
correct there, sized to the full print area for that blank.

## Validate before authoring

Run `python3 scripts/check_fields.py fields.json` (from this skill's own
directory) before `add_form_fields.py` — it flags duplicate field names,
degenerate rects, and any two rects on the same page that overlap, which is
the most common way a coordinate-extraction pass goes wrong. Fix everything
it reports before proceeding; don't author fields from a fields.json that
still fails this check.
