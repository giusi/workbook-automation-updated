# Brand voice sources

The `generate-workbook` skill reads everything in this folder before drafting, so
the workbook sounds like Giusi — not like generic AI. Add real material here.

## What to put here

| File / folder | Why |
|---|---|
| `sources.md` | The two canonical Google Docs (brand + editorial voice) — edit these Docs, not the snapshots below |
| `google_docs/` | **Generated.** Markdown snapshots of `sources.md`, refreshed and committed on every run. Don't hand-edit — edit the Google Doc instead |
| `tone_guide.md` | Hand-curated supplement — signature phrases, do's/don'ts, what to avoid (see the template) |
| `past-workbooks/` | Exported past workbooks (PDF/text) — structure, rhythm, exercise style |
| `podcast-transcripts/` | Transcripts of recent episodes — her spoken voice and phrasing |
| `social-captions.md` | A handful of strong, on-brand captions |
| Anything else on-voice | Newsletters, landing-page copy, etc. |

## Google Docs + snapshot (hybrid model)

The two Docs in `sources.md` are the **primary, live-editable** source — whoever
maintains Giusi's voice guidance edits them directly, no repo access needed. On
every run, the skill fetches both via the Google Drive connector and writes a
markdown snapshot into `google_docs/`, committed to git on its own. That gives
you live-editing convenience *and* a durable, diffable record of exactly what
voice guidance produced each month's workbook — plus a safe fallback (the last
committed snapshot) if the Drive fetch ever fails on a scheduled run.

Everything else in this folder (`tone_guide.md`, `past-workbooks/`, etc.) is the
**always-available local supplement**: hand-maintained, always present even in a
headless run, and used alongside the fetched Docs for extra texture.

## Privacy

Transcripts and past material may be private. This folder is committed by default;
if you'd rather not commit the raw material, add `brand_voice/` (or specific
subfolders) to `.gitignore` and keep them local.
