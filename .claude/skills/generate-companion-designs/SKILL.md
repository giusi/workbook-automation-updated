---
name: generate-companion-designs
description: Generate the 3 companion Canva designs (Tiles, Intenzione e Mantra, Mobile Mantra e Intenzione) for the monthly HDH workbook, reusing its theme, mantra, intention, and background photos. Use when Giusi says the workbook is approved and asks for the companion designs / tiles / mantra designs, or when the user runs /generate-companion-designs. This is a third, separate pipeline step from /generate-workbook and /finalize-workbook, triggered by the same human approval, not by content generation finishing.
---

# Generate the monthly HDH companion designs

Every month's Canva folder holds 4 designs: the workbook, plus 3 companions
that reuse the same month's theme, mantra, and intention, with Giusi's own
photos on the Tiles design's first 3 pages. This skill produces those 3
companions once Giusi has approved the month's workbook — a sibling step to
`/finalize-workbook`, not a replacement for it (that skill still handles the
fillable-PDF export; this one never touches the workbook or produces a PDF).

**Never run this unprompted.** Same gating as `/finalize-workbook`: wait for
Giusi's explicit approval of the month's workbook before touching Canva.

## Inputs

You need the approved workbook's Canva design (URL or design_id). If Giusi
gives a bare month with no URL and `out/workbook-<YYYY-MM>.json` from this
session's `/generate-workbook` run isn't available either, ask her for the
Canva URL rather than guessing — same rule as `finalize-workbook`.

## One-time setup already done (Phase 0)

The 3 companion designs are tagged Canva Brand Templates, not autofill-blank
scaffolds you build from scratch — this was a one-time migration, already
complete. Their ids and tagged field names are in
`references/companion_designs.md`. You never need to `copy-design` last
month's designs or guess which element is which by position — every fill
starts from `create-design-from-brand-template` and maps fields by their
`dataFieldLabel`, the same mechanism `generate-workbook` uses for the
workbook's own brand template.

## Steps

1. **Resolve month, theme text, and photos from the approved workbook.**
   - Get the Italian month label from the workbook design's title (e.g. "WB
     HDH SETTEMBRE 2026" → "Settembre 2026").
   - Prefer `out/workbook-<YYYY-MM>.json` from this session's
     `generate-workbook` run if present (it now always exists per that
     skill's step 4) — it has the theme (`cover_title`/`cover_subtitle`),
     `mantra_testo`, `intenzione_testo`, and the `sfondo_cover`/
     `sfondo_impressum` photo asset ids and alt_text already recorded.
   - Otherwise, read them straight off the approved workbook design:
     `read-design` page 1 → `cover_subtitle` (the theme phrase — this is
     what fills `tema_del_mese` below); page 2 → `mantra_testo`,
     `intenzione_testo`. For the photos, get the asset id off the
     `sfondo_cover`/`sfondo_impressum` image elements' `fill.media.mediaId`.
   - Read `content_plan.toml`'s entry for the month (`tema`/`obiettivi`) —
     needed for drafting the fresh tagline in step 2.

2. **Draft the fresh secondary tagline** — the Tiles design's
   `tagline_secondaria` field (e.g. "Fiorisci nella presenza: il potere del
   qui e ora"), which is *not* a verbatim copy of any workbook field. Short,
   on-theme, in Giusi's voice — reuse this session's brand-voice snapshots
   from `generate-workbook` (`brand_voice/google_docs/*.md`) rather than
   re-fetching. Match the existing phrasing's register: a short title-style
   line plus a subordinate clause, roughly the same length as
   `tema_del_mese` (see examples in `companion_designs.md`).

3. **Locate or create this month's Canva folder.** Parent gallery folder is
   `FAF67DAHCKg`. `list-folder-items`/`search-folders` under it for a child
   folder named `"<MESE MAIUSCOLO> <anno>"` (e.g. `OTTOBRE 2026`). Create it
   with `mcp__Canva__create-folder` if missing. If the approved workbook
   design isn't already inside it, `move-item-to-folder` it in.

4. **For each of the 3 companion brand templates** (ids and field names in
   `references/companion_designs.md`):
   - `create-design-from-brand-template(brand_template_id)` → a fresh
     instance (pre-filled with the previous edition's content — same known
     quirk as the workbook template, not blank).
   - `get-brand-template-dataset` to re-confirm the tagged field names
     before trusting `companion_designs.md` blindly — re-verify every run,
     same habit as the workbook fill.
   - Open one editing transaction, `read-design` to map each `dataFieldLabel`
     to its `locator_id` for this instance (locator_ids are per-instance,
     never reused from a previous run or from `companion_designs.md`).
   - `replace_text` on the text fields with this month's values:
     `tema_del_mese` ← theme phrase, `tagline_secondaria` ← the fresh
     tagline from step 2, `mantra_testo` ← mantra, `intenzione_testo` ←
     intention. (Only the Tiles template has all 4; the other two only have
     `mantra_testo`/`intenzione_testo`.)
   - On the Tiles template only: `update_fill` the 3 photo fields
     (`sfondo_tema`, `sfondo_diretta`, `sfondo_domande`) with the asset
     id(s) from step 1 — reuse the workbook's own `sfondo_cover`/
     `sfondo_impressum` photo(s) rather than picking new ones. All 3 can be
     the same photo, or split between the two if two were chosen for the
     workbook — judgment call, consistency with the workbook matters more
     than variety here.
   - `update_title` to this month's label, mirroring the exact naming
     convention already used for that design type (see
     `companion_designs.md` for the pattern per design) — including
     existing spacing/format quirks, don't "fix" them unless Giusi asks.
   - Pull thumbnails for every touched page and compare before/after — the
     same verify-and-fix discipline as `canva_mcp_fill.md` (autoshrink,
     bold/italic formatting leaking from the previous run's first-run
     formatting, and font-family drift are all possible here too, tagged
     fields or not).
   - Commit the transaction, then `move-item-to-folder` the new instance
     into this month's folder.

5. **Report.** List all 4 designs now in the month's folder with stable
   `https://www.canva.com/design/<id>/edit` URLs, plus the month folder's
   own URL (`https://www.canva.com/folder/<folder_id>`). Flag anything that
   looked wrong on a thumbnail check. This produces no PDF/export (that
   remains `finalize-workbook`'s job, workbook-only) and nothing is
   auto-shared — the designs are simply ready in Canva for Giusi to check.

## Notes

- This is a pure Claude Code + MCP workflow, same as `generate-workbook` and
  `finalize-workbook` — no local server, database, or API keys.
- The 3 companion brand templates were bootstrapped by tagging a plain
  design's elements with `edit-design`'s `update_autofill_field` operation
  *before* calling `publish-brand-template` on it — the more obvious
  `create-brand-template-draft` → tag → `publish-brand-template` flow is
  blocked on this Canva connector's current scopes (it can create a new
  brand template from a design, but can't open an existing one as an
  editable draft). If you ever need to re-tag or rebuild one of these
  templates (e.g. Giusi adds a 4th companion design, or a field needs
  renaming), repeat that same order — tag the plain design first, publish
  second — rather than trying `create-brand-template-draft` again; ask
  Giusi to reconnect the Canva connector first if you want to try the more
  direct flow instead.
- `publish-brand-template` appears to absorb its source design into the
  template (the source design_id stops resolving afterward) — expect this,
  it's not a bug. Never call it on a design you or Giusi still need as an
  independent, editable design; work on a disposable `copy-design` copy
  instead, same as Phase 0 did.
- Only Tiles pages 1–3 (theme cover, "Diretta del mese con Giusi", "Domande
  e Risposte con Giusi") carry Giusi's own photos and are in scope. Pages
  4–7 (other instructors — Annalisa, Yamuna) are untagged and permanently
  out of scope; never edit them.
