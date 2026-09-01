---
name: generate-social-post
description: Generate one week's HDH social carousel (Canva design + per-platform captions) from the podcast (via Castmagic) or the current HDH workbook, in Giusi Valentini's voice. Use when the user runs /generate-social-post, or asks to draft this week's social post/carousel. Produces a review package for the Make hand-off — never auto-publishes.
---

# Generate this week's HDH social post

You generate one week's social carousel — Canva design plus per-platform
captions — sourced from the podcast (via Castmagic) or the current month's
HDH workbook, in Giusi's voice. Like `generate-workbook`, this is a **Claude
Code + MCP workflow**: no server, no API key. It fills the master carousel
brand template (`EAHT9Ay4G_4`, see
[`references in hdh-social-copy`](../hdh-social-copy/references/social_carousel_template.md))
directly via the Canva MCP connector.

**This produces a draft for review, not a published post.** The Make
hand-off (webhook → email review → per-platform publish) doesn't exist yet —
see the repo's social-automation plan. Until it does, this skill's output is
a Canva edit URL and a review package, same spirit as `generate-workbook`
reporting back a Canva URL "for Giusi to review and finalize by hand."

## Inputs

- Optional `--date YYYY-MM-DD` (the target post date). If absent, use the
  nearest upcoming entry in `social_content_plan.toml`.

## Steps

1. **Resolve the week's plan.** Read `social_content_plan.toml` for the
   target date to get `fonte` (`podcast` or `workbook`) and `stile` (one of
   `pain_point`, `awareness`, `unpopular_opinion`, `educational`,
   `personal_experience`). **Never invent these** — if there's no entry for
   the target date, stop and tell Giusi to add one, same rule
   `generate-workbook` follows for `content_plan.toml`.

2. **Gather source material.**
   - `fonte = podcast`: use the Castmagic MCP connector, `Happy Daily
     Podcast` space, to pull the latest episode's summary, headlines, and
     post ideas (Castmagic already generates these — don't re-derive from a
     raw transcript unless the generated ideas are missing/thin).
   - `fonte = workbook`: read `out/workbook-<current-month>.json` (written by
     `generate-workbook`). If it doesn't exist yet, stop and tell Giusi
     rather than inventing workbook content — don't guess at a section or
     exercise that hasn't been drafted.

3. **Load voice and format rules.** Invoke the `hdh-social-copy` skill
   before drafting anything — it loads `brand_voice/tone_guide.md` and the
   brand-voice Google Doc snapshots, and defines the format playbook and the
   5 content styles referenced above.

4. **Draft the text fields**, per `hdh-social-copy`'s rules, matching
   `stile`:
   - `hook_testo`, `valore1_testo`, `valore2_testo`, `valore3_testo`,
     `chiusura_testo` — the narrative arc.
   - `cta_podcast_titolo` / `cta_podcast_azione` — always present, always
     references the actual current episode and one of Giusi's real comment
     keywords (e.g. `PODCAST`).
   - `cta_masterclass_header` / `cta_masterclass_azione` — the evergreen
     funnel slide. **The masterclass registration link doesn't exist yet**
     (per the repo plan) — draft the keyword CTA text (e.g. `Scrivi
     "MASTERCLASS" nei commenti`) but do not fabricate a URL; flag this
     explicitly in your report until Giusi provides the real link.
   - `mese_anno_tag` — derive from the target date (e.g. "Settembre 2026").
     Never hardcode a month.
   - Per-platform caption variants (Instagram, Facebook profilo, Facebook
     Gruppo Podcast, YouTube community post, Telegram) — see
     `hdh-social-copy`'s "Adattamento per piattaforma" section. Same core
     asset, tailored copy per platform.

5. **Generate background image candidates**, for `sfondo_narrativo` and
   `sfondo_cta`. Use the Canva `generate-design` tool (`instagram_post`),
   grounded in this week's actual mood/palette — the workbook's cover/mantra
   for a `workbook` post, the episode's mood/imagery for a `podcast` post.
   **Never ground the prompt in the literal metaphor/keywords** — that
   produces stock-photo-cliché results (see
   `social_carousel_template.md` for why). Generate a batch, silently
   discard any candidate with baked-in text, decorative frames, or an
   illustrated (non-photographic) style, and **present the remaining clean
   candidates to Giusi in this session for her to pick** — never auto-select
   on her behalf.

6. **Fill the Canva template.** `create-design-from-brand-template` with
   `EAHT9Ay4G_4` → `read-design` (open transaction) to get locator_ids →
   `edit-design` with `replace_text` for each text field and `update_fill`
   for the two image fields (using the asset ids Giusi picked in step 5) →
   commit.

7. **Write the review package** to `out/social/<date>-<slug>.json`: the
   Canva edit URL, every caption variant, `fonte`/`stile` used, and the CTA
   keyword(s). (`out/` is gitignored, same as the workbook pipeline's
   handoff files.)

8. **Log it.** Append an entry to `posting_log.md` (date, hook/title,
   fonte, stile, Canva URL, review package path, status `draft`).

9. **Report back.** Give Giusi the Canva edit URL and the review package
   path. Note explicitly that no Make webhook was called — that hand-off is
   a separate, not-yet-built step (see the repo's social-automation plan) —
   so this draft needs manual review/publishing until it exists.
