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
  to draft without a plan entry; see step 2.

## Steps

0. **Sync `approved/social/` from Canva before anything else.** This is what
   keeps both this skill's voice calibration (below) and the `social-critic`
   subagent (see the generator–critic loop later in this file) working from
   current sources, instead of a hand-curated snapshot that goes stale the
   moment a new post gets approved.

   **Scope the scan to the current and previous calendar month's subfolders
   only** — `<MESE-CORRENTE>-<ANNO>` and `<MESE-PRECEDENTE>-<ANNO>` inside
   `Social Media Automation` (`FAHUIdsKNnM`), by today's date, not the
   target post date. Giusi reviews and dates a design close to when it's
   actually going to post, so this window catches everything that matters
   without an unbounded `list-folder-items` walk over every month the
   folder has ever held — that's what actually drives this step's latency,
   since it grows every month forever otherwise. Read every design's title
   in those two subfolders. A **date in the title** — Giusi's
   scheduling-date prefix, e.g. `6.9 at 10am - ...`, `10.9 at 9 pm ...`,
   `12.9 at 10 am ...` — is the tell that she opened the design herself and
   dated it for posting; per the convention already in use across
   `posting_log.md`, that act *is* her review, the same signal
   `schedule-social-post` treats as approval when she confirms it in
   conversation. Treat every dated design as reviewed and approved-to-post.
   A title with no date is still a draft — never sync one of those in.

   This two-month window can miss an older post Giusi dated late or
   revisited well after the fact. That's an accepted gap, not a silent
   one: if a specific post from further back needs (re)syncing, do it as a
   one-off — read that month's subfolder directly — rather than widening
   this step's default scan for everyone, every run.

   For each dated design with no matching pair in `approved/social/`
   (`<date>-<slug>.md` + `.json`), or whose title date is newer than its
   existing record, `read-design` it and write/overwrite the pair from its
   *current* content: every platform caption verbatim, the CTA keyword(s) as
   they actually appear, and the fonte/stile/avatar from its `posting_log.md`
   entry if one exists — same fields and format as `schedule-social-post`
   step 4. Skip a dated design already recorded and unchanged.

   This sync is **read-only against Canva and read/write only inside this
   repo** — it never POSTs to Make, never needs a spoken "yes" in this
   session, and never substitutes for `schedule-social-post`'s own approval
   gate before a post actually goes out. It only keeps the record of what's
   already visibly finalized in Canva from lagging behind reality.

1. **Read `posting_log.md`.** It's what prevents duplicates: check the
   last few entries so you don't reuse a thesis, hook, or source episode
   that's already been drafted, and so you honour `hdh-social-copy`'s rule
   that two consecutive posts never share the same `stile`/structure. If the
   plan's `stile` collides with the previous entry's, draft it anyway but say
   so in your report — the plan is Giusi's call, not yours to silently
   override.

   This step is also where you pick up Giusi's live voice calibration, per
   `hdh-social-copy`'s "Before writing anything": check `approved/social/`
   — just synced in step 0, so it reflects every dated Canva design, not only
   whichever ones someone remembered to backfill — for her actual approved
   copy. Her edits there are the current source of truth for phrasing and CTA
   mechanics, not the brand-voice docs or your own prior draft.

2. **Resolve the week's plan — and write it if it's missing.** Read
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

3. **Gather source material.**
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

4. **Load voice and format rules.** Invoke the `hdh-social-copy` skill
   before drafting anything — it loads `brand_voice/tone_guide.md` and the
   brand-voice Google Doc snapshots, and defines the format playbook and the
   5 content styles referenced above.

5. **Draft the text fields**, per `hdh-social-copy`'s rules, matching
   `stile`:
   - `hook_testo`, `valore1_testo`, `valore2_testo`, `valore3_testo`,
     `chiusura_testo` — the narrative arc.
   - **Confirm with Giusi which CTA slide(s) this post needs — every run,
     don't assume.** Two CTA slides (podcast, then masterclass) is the
     common case, but a post can legitimately need only one, or in principle
     neither — see `social_carousel_template.md`. Draft text only for the
     slide(s) she confirms:
     - `cta_podcast_titolo` / `cta_podcast_azione` — if included, always
       references the actual current episode.
     - `cta_masterclass_header` / `cta_masterclass_azione` — if included,
       the evergreen funnel slide. **The masterclass registration link
       doesn't exist yet** (per the repo plan) — draft the keyword CTA text
       but do not fabricate a URL; flag this explicitly in your report until
       Giusi provides the real link.
   - **Always ask Giusi which comment keyword to use, every run, for each CTA
     slide that's actually included** — before finalizing the draft, not
     after. Don't default to `PODCAST` because it's the obvious one, and
     never invent a new keyword (an early draft of this pipeline invented
     `MASTERCLASS`, which doesn't exist). Her real keywords change with what
     she's promoting that week; she is the only source for them.
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

6. **Self-review before Giusi ever sees it.** Follow `hdh-social-copy`'s
   "Self-review prima di consegnare a Giusi" procedure: run a `brand-review`-
   style pass against `brand_voice/tone_guide.md` and the forbidden-phrase
   list (with its noted exceptions), fix anything High/Medium severity
   yourself, and iterate until clean. Don't guess when something depends on
   an unconfirmed fact (an unshared value proposition, an unconfirmed style
   preference) — surface that as a real question instead. When you report
   back in step 10, include only a compact summary of what was caught and
   auto-fixed, not the full review table — Giusi should see a draft that's
   already been through this pass, plus any genuinely open questions.

7. **Decide the photo pattern, then generate background candidates.** First
   decide whether *this* post gets Giusi's photo or stays pure landscape —
   see `social_carousel_template.md`'s "Giusi's photo pattern": across a
   batch generated together, split it **exactly half and half**; for a
   single post generated on its own, check the last several `Sfondo` lines
   in `posting_log.md` and pick whichever keeps the running ratio closest to
   half. Say which you picked, and why, in your report.
   - **Pure-landscape post**: generate candidates for `sfondo_narrativo` and
     `sfondo_cta` as before — Canva `generate-design` (`instagram_post`),
     grounded in this week's actual mood/palette (the workbook's cover/mantra
     for a `workbook` post, the episode's mood/imagery for a `podcast` post).
     **Never ground the prompt in the literal metaphor/keywords** — that
     produces stock-photo-cliché results (see `social_carousel_template.md`
     for why). Generate a batch, silently discard any candidate with
     baked-in text, decorative frames, or an illustrated (non-photographic)
     style, and **present the remaining clean candidates to Giusi in this
     session for her to pick** — never auto-select on her behalf.
   - **Photo post**: pick one of Giusi's real photos per
     `social_carousel_template.md` (media library subfolders listed there),
     and pair it with whichever of the two established landscapes
     (Background A/warm or Background B/cool) matches its tone, per the
     fixed pairing table — only generate a new landscape candidate if
     neither established one fits. The photo goes on the hook page and the
     post's actual last slide only (masterclass CTA if this post has one,
     otherwise the podcast CTA, otherwise `chiusura` — per the CTA
     confirmation in step 5); every page in between uses the landscape.

8. **Fill the Canva template.** `create-design-from-brand-template` with
   `EAHT9Ay4G_4` → `read-design` (open transaction) to get locator_ids →
   `edit-design` with `replace_text` for each text field and `update_fill`
   for the image fields per the pattern decided in step 7 → commit. Leave
   any CTA page Giusi didn't confirm (step 5) untouched so it prunes on
   commit — don't fill it with a CTA that doesn't apply to this post.

   Before committing, re-read the design content and confirm **every page
   that's actually meant to survive** carries real text and a real image
   fill — no leftover `{{PLACEHOLDER}}` text or default template image on
   any page you intend to keep. A page left untouched gets silently pruned
   on commit and shifts every later page's locator_ids (see
   `social_carousel_template.md`'s "Editing gotchas") — that's the intended
   way to drop an unneeded CTA slide, but catch it happening by *accident*
   on a page you meant to fill before committing, since it's much cheaper to
   catch there than after.

   Then **rename the design's title** (`update_title`) from whatever it
   inherited from the brand template to `HDH <Mese> — Post <N>`. A design
   still carrying the template's old title means the fill isn't actually
   finished — never hand Giusi an edit URL with the old title still
   showing.

   **File it into the correct monthly folder.** Canva's `Social Media
   Automation` folder (id `FAHUIdsKNnM`) is organized into one subfolder per
   month, named `<MESE>-<ANNO>` in uppercase Italian (e.g. `SETTEMBRE-2026`,
   `OTTOBRE-2026`) — derived from the target post date, not from today. Use
   `search-folders` (or `list-folder-items` on `FAHUIdsKNnM`) to find the
   subfolder for the target month; if it doesn't exist yet, create it with
   `create-folder` (`parent_folder_id: FAHUIdsKNnM`). Then
   `move-item-to-folder` the newly created design into that subfolder. Never
   leave a new design sitting at the root of `Social Media Automation` —
   that's exactly what this convention exists to prevent, and it's cheap to
   do right after the rename, before the design gets buried under later
   generations.

9. **Write the review package** to `out/social/<date>-<slug>.json`: the
   Canva edit URL, every caption variant, `fonte`/`stile` used, the CTA
   keyword(s), and every drafted field's exact text (hook, valore1-3,
   chiusura — not just the hook). `out/` is gitignored, so this file won't
   survive a fresh clone or a new container — that's fine for the working
   session, but it means `posting_log.md` (step 10) is the only copy that
   persists. If the design's structure is ever changed later in a way that
   could lose text (e.g. converting to a different format), that loss is
   real and irreversible unless the text was captured somewhere durable
   first.

10. **Log it.** Append an entry to `posting_log.md` (date, hook/title,
   fonte, stile, Canva URL, review package path, background/photo pattern
   used, status `draft`). **Only write a "complete"/finished status once the
   Canva commit has actually succeeded and you've checked the after-
   thumbnail** — never log a post as done based on what you're about to do.
   If a batch run gets interrupted partway, the log must reflect the real
   state of each design, not the intended end state.

11. **Print the full draft inline, then the ready marker.** Before the closing
   report, paste the actual drafted text into the chat message itself — not
   just a pointer to `out/social/`: the hook/valore1-3/chiusura fields, the
   CTA slide text(s) actually included, and at minimum the Instagram caption
   (all five platform variants if it's not too long to be useful). This is
   what lets `social-critic` (see the generator–critic loop wired via the
   repo's Stop hook, if enabled) actually evaluate the post — a critic
   reading only a file path or a Canva URL has no text to score.

   Then end your message with this exact line, alone, as the very last line:

   ```
   ---DRAFT READY---
   ```

   Never print this marker on a turn that isn't a finished, self-reviewed
   draft (a question to Giusi, a mid-draft check-in, a request for the CTA
   keyword) — it's a signal, not decoration, and a false positive here
   triggers an unnecessary critic pass on non-post text.

12. **Stop here. Do not send anything to Make.** Give Giusi the Canva edit URL
   and the review package path, and say plainly that this is a draft for her to
   iterate on. Scheduling is a **separate skill** (`schedule-social-post`) that
   a human invokes once the design and captions are actually approved — the
   same shape as `generate-workbook` → `finalize-workbook`.

   Never POST to a webhook, never touch Make, and never publish to a platform
   from this skill. Producing good copy and deciding to publish it are two
   different decisions, and only the second one is Giusi's to make here.

## Generator–critic loop (optional, requires the Stop hook to be enabled)

If `.claude/hooks/run-critic.sh` is registered as a `Stop` hook in
`.claude/settings.json` (see `.claude/agents/social-critic.md` for the rubric
and `posting_log.md`/repo README for setup status), every draft ending in the
`---DRAFT READY---` marker from step 11 is automatically scored by the
`social-critic` subagent. A failing score (any criterion below 4/5) blocks
the turn and hands back specific fixes, up to 3 automatic revision attempts
— after that it stands down and asks for human review instead of looping
forever. This runs whether you invoke this skill directly or drive it
hands-free with `/goal generate a [platform] post for [brief], and don't
return control to me until the social-critic subagent's last verdict shows
overall_pass: true, or 3 attempts have been logged`. Either way, revise per
the critic's `specific_fixes` — don't just re-print the same draft hoping for
a different score.
