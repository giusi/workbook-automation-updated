# HDH Workbook — Cloud Routine Prompt

Paste the text below into the **Instructions** box when creating the routine at
claude.ai/code/routines.

- **Repo:** `thaiscs/content-automation`
- **Connectors:** **Canva** and **Google Drive** — both required. Google Drive
  is not optional: `SKILL.md` step 1 fetches the two live brand-voice/theme
  Google Docs on every run; without it the routine silently falls back to
  whatever snapshot is already committed, which defeats the point of the
  live-Doc sync.
- **Schedule:** pick any preset, then `/schedule update` to cron
  `0 12 20 * *` (noon on the 20th, local time).

---

Generate and render this month's "Happy Daily Home" (HDH) monthly workbook for
Giusi Valentini, entirely within this cloned repository, using the
`generate-workbook` skill and the Canva MCP connector. Do not send any email.

STEPS:

1. Follow `.claude/skills/generate-workbook/SKILL.md` from the top — it
   already covers everything: fetching and snapshotting brand voice from the
   two Google Docs, resolving the month's theme from `content_plan.toml`
   cross-checked against the onboarding Doc's "Temi mensili" list (stop and
   report if there's no entry or the two sources genuinely conflict — never
   invent a theme), drafting the 34-field content to the schema in `SKILL.md`,
   assembling the Canva field values per
   `.claude/skills/generate-workbook/references/field_assembly.md` (character
   budgets, exercise/completamenti scaffolding), and filling the Canva brand
   template (id `EAHNaGY-7DM`) per
   `.claude/skills/generate-workbook/references/canva_mcp_fill.md` — including
   its known gotchas (the `toc_1`–`toc_4` dual-use elements on the TOC page,
   the `replace_text` autoshrink bug, stray inherited formatting, and the fact
   that `cover_title` currently has no target field in the template at all —
   `cover_subtitle` is the one that gets filled, not the reverse).

2. Report the design's stable edit URL
   (`https://www.canva.com/design/<design_id>/edit` — not the `edit_url`/
   `view_url` short link Canva MCP calls return, which regenerates on every
   call) in your final summary, so Giusi can finalize it in Canva.

3. Do not send any email or other notification — that's Giusi's manual step
   once she's reviewed the design in Canva.

4. If `SKILL.md` step 1 refreshed the brand-voice Google Doc snapshots, it
   already commits that on its own (`chore: refresh brand voice snapshot for
   <month>`) and pushes it to this branch. No other commits are expected from
   a routine run — generated workbook JSON is scratch output, not meant to be
   committed (`out/` is gitignored); the durable record is the Canva design
   itself plus this repo's `content_plan.toml`/`brand_voice/` history.
