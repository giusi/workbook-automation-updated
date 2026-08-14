---
name: generate-workbook
description: Generate the monthly HDH workbook in Giusi Valentini's voice and render it in Canva. Use when the user runs /generate-workbook, or asks to create/generate this month's (or a given month's) workbook. Draws on brand-voice sources, produces the 34-field content, and fills the Canva brand template.
---

# Generate the monthly HDH workbook

You generate the content for Giusi Valentini's monthly "Happy Daily Home" (HDH)
workbook — in Italian, in her voice — then hand it to a deterministic script that
fills the Canva brand template and emails the edit link.

You are the **content generator** (this replaces the old Anthropic-API call, so it
runs on the Claude subscription). The Canva/email plumbing stays in Python.

## Inputs

- Optional month argument like `--month 2026-07`. If absent, use the current month.
- The theme comes from `content_plan.toml` (keys are `YYYY-MM`). **Never invent a
  theme** — if there's no entry for the target month, stop and tell the user to add
  one (and, if email is set up, note that `run_monthly.py` would send a heads-up).

## Steps

1. **Resolve the edition.** Determine the target `YYYY-MM` and read its entry from
   `content_plan.toml` (fields: `tema`, `obiettivi`). Compute the Italian edition
   label (e.g. `2026-07` → "Luglio 2026"). If no entry exists, STOP and report.

2. **Absorb the brand voice — this is what makes the output sound like Giusi.**
   The primary source is the pair of live Google Docs listed in
   `brand_voice/sources.md`; local files in `brand_voice/` are the always-available
   supplement and fallback.
   - **Fetch the Docs (primary):** for each URL in `brand_voice/sources.md`, use
     the Google Drive connector to get its title (`get_file_metadata`) and body
     (`read_file_content` / `download_file_content`). Write each as a markdown
     snapshot to `brand_voice/google_docs/<slugified-title>.md`, overwriting any
     previous snapshot, with a header noting the source URL and fetch time (UTC).
     These snapshots are generated files — don't hand-edit them.
   - **Fallback:** if the Drive connector isn't available, or a fetch fails, skip
     that doc, note it in your final report, and use whatever snapshot already
     exists in `brand_voice/google_docs/` from the last successful run instead.
     Never fail the whole run over a fetch failure.
   - **Local supplement:** also read every other file in `brand_voice/` (tone
     guide, past workbooks, transcripts, sample captions) for extra texture.
   - **Other connectors (if available):** pull recent, relevant material via MCP —
     podcast transcripts (Libsyn), social captions. Skip if unavailable.
   - **Snapshot commit:** after writing snapshots, if `git status --porcelain
     brand_voice/google_docs/` shows changes, commit them on their own (`git add
     brand_voice/google_docs/ && git commit -m "chore: refresh brand voice
     snapshot for <month>"`) — keep this separate from the workbook-content
     commit/PR so the voice-source history stays easy to audit.
   Extract: her recurring phrases, sentence rhythm, warmth, directness, the topics
   she returns to, and what she avoids. Mirror that voice — do not write generic
   "AI wellness" prose.

3. **Draft the content** to the exact schema below. Match lengths (the layout is
   fixed; text must fill the boxes without overflowing).

4. **Write** the JSON to `out/workbook-<YYYY-MM>.json` (create `out/` if needed).

5. **Fill Canva + notify** by running:
   ```
   python scripts/fill_canva.py --content out/workbook-<YYYY-MM>.json --mese "<Label>" --tema "<tema>"
   ```
   (Use the project's venv Python if present: `.venv/bin/python`.)

6. **Report** the Canva edit URL the script prints, so Giusi can finalize it.

## Content schema (34 fields — must match exactly)

Return/write JSON with this shape:

```json
{
  "cover_title": "TITOLO DEL TEMA, MAIUSCOLO",
  "cover_subtitle": "sottotitolo breve del percorso",
  "mantra_testo": "frase breve, prima persona, presente",
  "intenzione_testo": "frase breve complementare al mantra",
  "lettera_corpo": ["paragrafo 1 (~85-110 parole)", "paragrafo 2, termina con 'Namaste,'"],
  "sezioni": [
    {
      "numero": 1,
      "titolo": "sottotitolo della sezione",
      "citazione": "citazione ispirazionale breve",
      "corpo": ["colonna 1 (~90-120 parole)", "colonna 2 (~90-120 parole)"],
      "esercizi_intro": "Esercizi – [nome breve]",
      "esercizi": [
        {"titolo": "titolo esercizio", "prompt": "domanda/istruzione riflessiva, seconda persona"}
      ]
    }
  ],
  "integrazione_corpo": ["colonna 1 (~45-65 parole)", "colonna 2 (~45-65 parole)"],
  "esercizio_finale_titolo": "Esercizio finale – [nome breve]",
  "esercizio_finale_completamenti": ["Oggi scelgo di abitare di piu...", "Sono pronta a lasciare andare..."],
  "completamenti": ["La mia [tema] per me ora e...", "La mia [tema correlato] puo diventare...", "Da oggi mi permetto di..."],
  "completamenti_chiusura": "frase finale di incoraggiamento"
}
```

Rules (the Python side validates these — getting them wrong makes the fill fail):
- EXACTLY 4 sezioni; each with EXACTLY 2 `corpo` columns and EXACTLY 4 `esercizi`.
- EXACTLY 2 paragraphs in `lettera_corpo` and in `integrazione_corpo`.
- EXACTLY 2 `esercizio_finale_completamenti`; EXACTLY 3 `completamenti`.
- Each esercizio has one `titolo` and one reflective `prompt` (second person). Do
  NOT add answer lines — the template adds them.
- Tone: warm, direct, feminine, encouraging — never generic. Each section a
  distinct theme that builds on the previous.

## Notes

- The Canva credentials and OAuth must already be set up (`scripts/canva_auth.py`
  run once). This skill only generates content and invokes the fill script.
- If `fill_canva.py` reports a schema validation error, fix the JSON to match the
  rules above and re-run it — don't regenerate from scratch.
