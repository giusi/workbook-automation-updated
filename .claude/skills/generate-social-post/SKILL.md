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

**This produces a draft to iterate on, and nothing else.** It ends with a
Canva edit URL and a review package — same spirit as `generate-workbook`
reporting back a URL for Giusi to review and finalise by hand. Giusi then
refines the design in Canva until it's right. Only when she says it's approved
does anyone invoke `schedule-social-post`, which is what talks to Make.

## Inputs

- Optional `--date YYYY-MM-DD` (the target post date). If absent, use the
  nearest upcoming entry in `social_content_plan.toml`.
- Optional `--fonte` / `--stile` — explicit overrides for an **ad-hoc run**
  (Giusi asking for a one-off post, or a test run). These are the only way
  to draft without a plan entry; see step 1.

## Steps

0. **Read `posting_log.md` first.** It's what prevents duplicates: check the
   last few entries so you don't reuse a thesis, hook, or source episode
   that's already been drafted, and so you honour `hdh-social-copy`'s rule
   that two consecutive posts never share the same `stile`/structure. If the
   plan's `stile` collides with the previous entry's, draft it anyway but say
   so in your report — the plan is Giusi's call, not yours to silently
   override.

1. **Resolve the week's plan — and write it if it's missing.** Read
   `social_content_plan.toml` for the target date to get `fonte` (`podcast`
   or `workbook`) and `stile` (one of `pain_point`, `awareness`,
   `unpopular_opinion`, `educational`, `personal_experience`). An existing
   entry always wins — never overwrite one Giusi has written.

   If there's no entry for the target date, **you fill it in** — this is
   unlike `content_plan.toml`, which the workbook pipeline may never write.
   The reason is that the theme isn't the thing being invented: it already
   comes from the month's workbook theme (`content_plan.toml`) and from the
   podcast episodes that exist. What you're choosing is only the routing:

   - `--fonte` / `--stile` passed → use them.
   - otherwise → pick `fonte` by what actually has material for the target
     week (a real, on-theme episode published since the last podcast-sourced
     post → `podcast`; otherwise `workbook`), and pick `stile` by rotating
     away from the last entries in `posting_log.md`, matching the style to
     the material (a lived episode story → `personal_experience`, a named
     blocco → `pain_point`, a counter-current thesis → `unpopular_opinion`,
     a workbook exercise → `educational`, an HDH introduction → `awareness`).

   Then **write the entry into `social_content_plan.toml`** before drafting,
   and say in your report which values you chose and why, so Giusi can
   correct the file in one edit.

   What you still must never invent: the **month's theme** — if
   `content_plan.toml` has no entry for the target month, stop and ask,
   exactly as `generate-workbook` does.

2. **Gather source material.**
   - `fonte = podcast`: use the Castmagic MCP connector, `Happy Daily
     Podcast` space. **Don't just take the newest recording** — the space
     also holds test clips, work files and third-party English podcasts, and
     `published_at` is `null` on most of them. Follow `hdh-social-copy`'s
     "Scegliere l'episodio podcast" rules to pick a real episode that fits
     the month's theme, and name the exact title in your report. Then **read
     the full transcript** (`get_transcript`) — not Castmagic's summaries,
     quote hooks or generated posts, which strip out exactly the concrete
     detail that makes the copy sound like Giusi (see that skill's "Leggi il
     transcript completo"). Never carry over promos, coupons or prices found
     in the source.
   - `fonte = workbook`: read `out/workbook-<target month>.json` (written by
     `generate-workbook`). **`out/` is gitignored**, so in a fresh clone or a
     cloud routine that file won't exist — in that case fall back to the
     month's entry in `content_plan.toml` (`tema` + `obiettivi`), which is
     the same theme the workbook was generated from, and say which of the two
     you used. Never invent a workbook section, exercise, mantra or intention
     you haven't actually read.

3. **Load voice and format rules.** Invoke the `hdh-social-copy` skill
   before drafting anything — it loads `brand_voice/tone_guide.md` and the
   brand-voice Google Doc snapshots, and defines the format playbook and the
   5 content styles referenced above.

4. **Draft the text fields**, per `hdh-social-copy`'s rules, matching
   `stile`:
   - `hook_testo`, `valore1_testo`, `valore2_testo`, `valore3_testo`,
     `chiusura_testo` — the narrative arc.
   - `cta_podcast_titolo` / `cta_podcast_azione` — always present, always
     references the actual current episode.
   - `cta_masterclass_header` / `cta_masterclass_azione` — the evergreen
     funnel slide. **The masterclass registration link doesn't exist yet**
     (per the repo plan) — draft the keyword CTA text but do not fabricate a
     URL; flag this explicitly in your report until Giusi provides the real
     link.
   - **Always ask Giusi which comment keyword to use, every run, for both CTA
     slides** — before finalizing the draft, not after. Don't default to
     `PODCAST` because it's the obvious one, and never invent a new keyword
     (an early draft of this pipeline invented `MASTERCLASS`, which doesn't
     exist). Her real keywords change with what she's promoting that week;
     she is the only source for them.
   - `mese_anno_tag` — derive from the target date (e.g. "Settembre 2026").
     Never hardcode a month.
   - **Three hook options**, the target avatar (Giulia or Rossella), and the
     thesis in one line — delivered alongside the draft for Giusi to choose
     from and react to. See `hdh-social-copy`, "Tre cose da consegnare sempre
     a Giusi con la bozza".
   - Per-platform caption variants (Instagram, Facebook profilo, Facebook
     Gruppo Podcast, YouTube community post, Telegram) — see
     `hdh-social-copy`'s "Adattamento per piattaforma" section. Same core
     asset, tailored copy per platform. Instagram and Facebook profilo get a
     3-5 hashtag block (specific to this post's theme, not generic/repeated
     every week); the other three platforms don't. The YouTube variant leads
     with the episode link — the repo holds **no canonical episode URL**, so
     leave an explicit placeholder (`<LINK EPISODIO>`) and ask Giusi for it;
     never fabricate a URL, a handle, or a domain.

5. **Self-review before Giusi ever sees it.** Follow `hdh-social-copy`'s
   "Self-review prima di consegnare a Giusi" procedure: run a `brand-review`-
   style pass against `brand_voice/tone_guide.md` and the forbidden-phrase
   list (with its noted exceptions), fix anything High/Medium severity
   yourself, and iterate until clean. Don't guess when something depends on
   an unconfirmed fact (an unshared value proposition, an unconfirmed style
   preference) — surface that as a real question instead. When you report
   back in step 9, include only a compact summary of what was caught and
   auto-fixed, not the full review table — Giusi should see a draft that's
   already been through this pass, plus any genuinely open questions.

6. **Generate background image candidates**, for `sfondo_narrativo` and
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

7. **Fill the Canva template.** `create-design-from-brand-template` with
   `EAHT9Ay4G_4` → `read-design` (open transaction) to get locator_ids →
   `edit-design` with `replace_text` for each text field and `update_fill`
   for the two image fields (using the asset ids Giusi picked in step 6) →
   commit.

8. **Write the review package** to `out/social/<date>-<slug>.json`: the
   Canva edit URL, every caption variant, `fonte`/`stile` used, and the CTA
   keyword(s). (`out/` is gitignored, same as the workbook pipeline's
   handoff files.)

9. **Log it.** Append an entry to `posting_log.md` (date, hook/title,
   fonte, stile, Canva URL, review package path, status `draft`).

10. **Stop here. Do not send anything to Make.** Give Giusi the Canva edit URL
   and the review package path, and say plainly that this is a draft for her to
   iterate on. Scheduling is a **separate skill** (`schedule-social-post`) that
   a human invokes once the design and captions are actually approved — the
   same shape as `generate-workbook` → `finalize-workbook`.

   Never POST to a webhook, never touch Make, and never publish to a platform
   from this skill. Producing good copy and deciding to publish it are two
   different decisions, and only the second one is Giusi's to make here.
