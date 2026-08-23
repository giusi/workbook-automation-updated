# Field length budgets and text assembly

Ported from the old `app/pipelines/workbook/generate.py` (deleted along with the
rest of the Python pipeline — see the repo's git history if you ever need the
original code, e.g. `git log --all --full-history -- app/pipelines/workbook/generate.py`).
This is the load-bearing content logic that survives the deletion: it decides
how long each field must be to fill its Canva box, and how the raw JSON content
(step 3 of `SKILL.md`) turns into the exact text that goes into each of the 34
Canva fields.

## Character budgets (min, max) — inclusive

Calibrated from the template's box geometry at font size 12. These are
deliberately approximate ranges, not hard limits — stay inside them so pages
neither overflow nor look sparse.

| Field | Budget (chars) | ~Words |
|---|---|---|
| `sez1_testo_1`, `sez1_testo_2` | 480–720 | ~90–120 |
| `sez2_testo_1`, `sez2_testo_2` | 480–720 | ~90–120 |
| `sez3_testo_1`, `sez3_testo_2` | 480–720 | ~90–120 |
| `sez4_testo_1`, `sez4_testo_2` | 480–720 | ~90–120 |
| `lettera_testo_1` | 470–700 | ~85–110 |
| `lettera_testo_2` | 440–670 | ~85–110 |
| `integrazione_testo_1` | 250–440 | ~45–65 |
| `integrazione_testo_2` | 260–450 | ~45–65 |

Check these by counting characters/words yourself while drafting (no code
needed — a rough word count is enough; these are fill targets, not hard
limits). If a field lands outside its range, revise it — don't ship it
oversized or undersized. Budget counts include the paragraph-break and bold
markers described below — see "Paragraph rhythm & bold emphasis".

`cover_title`, `cover_subtitle`, `mantra_testo`, `intenzione_testo`, section
`titolo`/`citazione`, exercise titles/prompts, and the completion-sentence
starters are all naturally short/bounded by their nature — no explicit budget
needed for those, and the paragraph/bold rules below don't apply to them
(they're single short lines, not body text).

## Paragraph rhythm & bold emphasis (body text fields)

Applies to every "wall of text" field: `lettera_testo_1`/`_2`, `sezN_testo_1`/
`_2` (all 4 sections), `integrazione_testo_1`/`_2`. Does NOT apply to the
fixed-scaffolding fields (`sezN_esercizi`, `esercizio_finale`,
`completamenti`) — those already get their own formatting treatment below.

A page reads better — and fills its box more evenly — as two short
paragraphs with a visible break between them and one bolded phrase per
paragraph anchoring its core idea, rather than one dense uninterrupted
block. This is a **drafting-time** decision (step 3 of `SKILL.md`), made the
same way on every run, not something patched in afterward:

1. **Write each `corpo`/`lettera_corpo`/`integrazione_corpo` string as 2
   paragraphs internally**, separated by a blank line (`\n\n`) inside the
   same string. Split roughly evenly across the field's word budget above —
   don't front-load one long paragraph and tack on a two-word fragment.
   - `integrazione_testo` is short (45–65 words total); if splitting it in
     half would leave a paragraph under ~15 words, keep it as one paragraph
     instead — don't force an awkward break just for the pattern's sake.
2. **Bold one short phrase per paragraph** by wrapping it in
   `**double asterisks**` in the drafted string — 3 to 7 words, a clause
   that carries that paragraph's turn or instruction (the reframe, the
   feeling named, the call to action), never a generic connector, never the
   whole sentence, never a single word.
3. That's 2 bolded phrases per field (1 if `integrazione_testo` stayed
   single-paragraph). Never bold two phrases back-to-back or bold the
   field's very first word.
4. The `**` markers themselves are a drafting-time convention only — they
   never reach Canva as literal text (see Assembly below). When checking a
   field against its character budget, you can count them as written (they
   roughly proxy for the visual weight of a bold span) or strip them first;
   either way stay inside the budget range.

**Assembly (step 4):** for each of these fields, before filling Canva:
1. Find each `**phrase**` span in the drafted string; record its plain-text
   start/end character offset (0-indexed, counting the paragraph break as 2
   characters) in the final field text, i.e. *after* stripping the `**`
   markers.
2. Strip the `**` markers to produce the plain text — this plain text (with
   its `\n\n` paragraph break intact) is what gets sent to `replace_text`.
3. Keep the `(field_name, start, end)` bold-span list per field for the
   Canva-filling step.

**Filling (step 5):** for each of these body-text fields, after
`replace_text`:
1. First normalize the whole element to `font_weight: "normal"` /
   `color: "#000000"` (the template's placeholder content can carry stray
   bold/color runs onto the new text, the same way it does on the
   exercizi/completamenti fields below — do this unconditionally, don't
   wait to notice a problem).
2. Then, for each recorded bold span, one `format_text` call setting
   `font_weight: "bold"` over that character range on the same element.
   Check the live `format_text` tool schema for the exact range parameter
   names (e.g. `start`/`end` vs. `offset`/`length`) before calling — it
   isn't pinned here because it hasn't been exercised on body-text fields
   yet; verify once per session rather than assuming.
3. Pull the page thumbnail and confirm: the paragraph break reads as an
   actual visual break (not a run-on line), and each bold span lands on
   clean word boundaries — never mid-word, never spilling across the blank
   line into the next paragraph.

If the connected Canva tooling turns out not to support range-level
`format_text` on a text element (whole-element only), say so in your final
report rather than silently shipping unbolded body text — don't invent a
workaround (e.g. a separate bolded lead-in element) without checking with
Giusi first, since that would mean editing the template itself.

## How the 34 Canva fields are assembled from the drafted JSON

Draft the JSON to the schema in `SKILL.md` first (34-field content: `sezioni`
with `corpo`/`esercizi`, `completamenti`, etc.). Then build the literal text for
each Canva `dataFieldLabel` as follows before filling (step 5):

**Direct 1:1 fields** — no assembly beyond the paragraph/bold-span
processing above, just copy the value: `cover_title`, `cover_subtitle`,
`mantra_testo`, `intenzione_testo`, `lettera_testo_1` = `lettera_corpo[0]`,
`lettera_testo_2` = `lettera_corpo[1]` (the latter two go through "Paragraph
rhythm & bold emphasis" above like any other body-text field).

**Per section N (1–4):**
- `toc_N` = `sezioni[N].titolo` (the subtitle only — the template's own
  "SEZIONE N" heading is a separate, fixed element; don't prepend it)
- `sezN_titolo` = `sezioni[N].titolo` (same value as `toc_N`)
- `sezN_citazione` = `sezioni[N].citazione`
- `sezN_testo_1` = `sezioni[N].corpo[0]`, `sezN_testo_2` = `sezioni[N].corpo[1]`
  (both go through "Paragraph rhythm & bold emphasis" above)
- `sezN_esercizi` = the exercises block, assembled as:
  ```
  {esercizi_intro}

  1. {esercizi[0].titolo}

  {esercizi[0].prompt}
  {ANSWER_LINES}

  2. {esercizi[1].titolo}

  {esercizi[1].prompt}
  {ANSWER_LINES}

  3. {esercizi[2].titolo}

  {esercizi[2].prompt}
  {ANSWER_LINES}

  4. {esercizi[3].titolo}

  {esercizi[3].prompt}
  {ANSWER_LINES}
  ```
  where `ANSWER_LINES` is **one unbroken line of `"." * 458`** (458 period
  characters, no embedded newlines) — the template's text box word-wraps
  this into ~3 visual lines on its own. (Confirmed against the live
  October 2026 fill — do not use 3 separate 150-dot lines joined by
  newlines; that was this doc's original guess and doesn't match what's
  actually in the template. Re-verify the dot count if the box width ever
  changes, since it's tuned to the current ~535px-wide exercise boxes.)
  This is fixed scaffolding, always the same regardless of content. Each
  numbered block and its answer line are separated by a blank line (double
  newline), matching the pattern above.
- **After every `replace_text` on an `esercizi`/`completamenti`/
  `esercizio_finale` field, immediately follow with a `format_text` call
  setting `font_weight: "normal"` (and usually `color: "#000000"`) on that
  same element.** These fields carry multi-run rich text in the template
  (bold numbered headers, differently-colored prompts) that `replace_text`
  collapses into a single run using the *first* run's formatting — in
  practice this means the whole block comes back bold and gold-colored,
  not just an occasional stray run. This isn't the rare edge case the
  older gotcha note below implies; it happens on essentially every one of
  these fields, every time. Normalizing to plain black after each fill is
  the reliable fix, not a "check and fix if you notice it" step.

**`integrazione_testo_1`/`_2`** = `integrazione_corpo[0]`/`[1]` directly
(through "Paragraph rhythm & bold emphasis" above like the other body-text
fields).

**`esercizio_finale`** — assembled as:
```
{esercizio_finale_titolo}

Completa senza pensarci troppo:

{esercizio_finale_completamenti[0]}
{ANSWER_LINES}

{esercizio_finale_completamenti[1]}
{ANSWER_LINES}
```

**`completamenti`** — assembled as:
```
{completamenti[0]}
{ANSWER_LINES}

{completamenti[1]}
{ANSWER_LINES}

{completamenti[2]}
{ANSWER_LINES}

Porta con te questo:

{completamenti_chiusura}
```

Note the literal connective text — `"Completa senza pensarci troppo:"` and
`"Porta con te questo:"` — is fixed template language, not something to
paraphrase; reproduce it verbatim, only the content around it changes.

## Background photos

The template has three image autofill fields (`sfondo_cover`, `sfondo_pagina2`,
`sfondo_impressum`) for a monthly-rotating background photo. The old Python
pipeline had this logic (`backgrounds.py`, deterministic photo choice per
edition) but it was never actually configured (no folder ID was ever set), so
in practice these three fields always kept the template's default image.

That's fixed now for two of the three: a curated Canva folder of Giusi's
photos exists ("For Claude", see `references/media_library.md`), and filling
`sfondo_cover` and `sfondo_impressum` is part of the routine procedure — see
`canva_mcp_fill.md` step 6. `sfondo_pagina2` is deliberately left alone
(keeps the template's default image) — only cover and impressum get a photo.
These are images, not text, so they're picked and placed directly via Canva
MCP (`update_fill`) — they're not part of the 34-field JSON content schema
above and need no drafting.
