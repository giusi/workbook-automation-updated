---
name: generate-social-reel
description: Generate one podcast-episode HDH Reel (Canva design + Instagram caption) from a real episode transcript via Castmagic, in Giusi Valentini's voice. Use when the user runs /generate-social-reel, or asks to draft a reel/episode-promo reel for the podcast. Produces a Canva edit URL to review — never exports video, never auto-publishes.
---

# Generate an HDH podcast-episode Reel

You generate one Reel — a 3-slide Canva design (hook announcing the
episode, a verbatim quote from it, a CTA to get the link) plus its
Instagram caption — promoting one specific HDH podcast episode, in Giusi's
voice. Sibling skill to `generate-social-post`, same spirit (a **Claude
Code + MCP workflow**, no server, no API key), but a distinct, narrower
format: no story-arc of beats, no CTA-type choice, no photo-pattern
decision. Fills the reel brand template (`EAHV8s0ovFs`, see
[`references/reel_template.md`](references/reel_template.md)) directly via
the Canva MCP connector.

**This produces a draft to iterate on, and nothing else.** It ends with a
Canva edit URL for Giusi to review and finalise by hand — same division of
labor as `generate-social-post`. It never calls `export-design`: the MP4
export is a separate, not-yet-built mechanism tied to however reels
eventually get published (per Giusi, 2026-09-22) — this skill's job stops
at a filled, committed Canva design.

**Scope: podcast-episode reels only.** This format doesn't support a
masterclass CTA or any other post type — see `reel_template.md`'s "Scope"
note. If Giusi ever wants a reel promoting something other than a specific
episode, that's a different template/skill to build, not a variant of this
one.

## Inputs

- Optional `--episode <title or partial title>` — pick a specific episode
  instead of the pipeline choosing one. Still subject to the same
  real-episode verification below (never trust a title alone).

## What's fixed for this format (no per-run confirmation needed)

Two things `generate-social-post` always asks about, this skill never does
— confirmed explicitly by Giusi (2026-09-22), don't re-ask:

- **CTA keyword is always `PODCAST`.** `cta_azione` is always
  `Rispondi "PODCAST" per ricevere il link in DM`. Never propose a
  different keyword, never ask.
- **Photo is always Giusi's real photo**, on all three image fields —
  never a landscape/stock background. See `reel_template.md`'s "Photo
  sourcing".

## Steps

1. **Check `posting_log.md` for episodes already reel-ified.** Grep for
   `Formato: reel` entries and note which episode each one used — this
   pipeline should never promote the same episode with a second reel
   without Giusi asking for it explicitly. This is a lighter version of
   `generate-social-post` step 1's duplicate-check, scoped to reels only
   (a carousel and a reel drawing on the same episode is fine and common;
   two reels on the same episode is the thing to avoid).

2. **Pick the episode.** Use the Castmagic MCP connector, `Happy Daily
   Podcast` space, following `hdh-social-copy`'s "Scegliere l'episodio
   podcast (non fidarti di 'l'ultimo')" rules exactly: discard clips under
   ~8 minutes, non-episode titles, non-Italian/third-party recordings, and
   duplicate versions of the same episode. `published_at` is null on most
   recordings, so "most recent" isn't reliable — pick on title/content
   fit, and name the exact title you chose in your report. If `--episode`
   was passed, use it as the search anchor but still run it through these
   same discard rules before trusting it.

3. **Read the full transcript.** `get_transcript` — not Castmagic's
   summaries or generated quote/post material, which strip the concrete
   detail that makes a quote sound like Giusi. See `hdh-social-copy`'s
   "Leggi il transcript completo. Sempre." for why this matters and what
   gets lost otherwise.

4. **Extract the three text fields:**
   - `hook_testo` — the episode's **actual title**, verbatim. Never write
     a new hook line for this slide; if the episode's working title feels
     unclear standing alone on a slide, flag that to Giusi rather than
     inventing a punchier version yourself.
   - `quote_testo` — **one** verbatim line or short passage from the
     transcript that stands alone as a complete thought (the real example
     is 2-3 sentences). Pull it exactly as spoken — light punctuation
     cleanup for readability is fine, paraphrasing or combining two
     separate moments into one "quote" is not.
   - `cta_azione` — the fixed line above. Don't touch it unless Giusi asks.

5. **Draft the Instagram caption.** Follow `hdh-social-copy`'s caption
   rules (short beats building like the carousel's, not one dense
   paragraph), sourced from the same episode/quote — this is the caption
   that ships with the Reel post itself, separate from the on-screen quote
   card. Single platform (Instagram) — reels aren't cross-posted through
   the same 5-channel adaptation as carousel posts.

   **Skip the hashtag block for this format.** `hdh-social-copy`'s general
   Instagram rule is a 3-5 hashtag block, but every real podcast-promo post
   in `social-critic`'s own reference set (Esempio 3 and 4 — same "Scrivi
   'PODCAST' nei commenti" CTA as this format) carries none. Match that
   precedent rather than the general rule.

6. **Self-review before Giusi sees it.** Run a `brand-review`-style pass
   against `brand_voice/tone_guide.md`, the forbidden-phrase list, and
   `brand_voice/meta_compliance.md` (personal attributes, guaranteed
   outcomes, fake urgency — see that file's GREEN/YELLOW/RED table) on the
   caption text, fix anything High/Medium yourself, same discipline as
   `generate-social-post` step 6.

7. **Print the draft inline, before any Canva work starts.** Paste the
   actual text into the chat message itself, not a file path: the episode
   title, the chosen quote, and the caption in full. Same reasoning as
   `generate-social-post` step 7: a problem caught here costs a rewrite;
   caught after the Canva fill it costs a filled design thrown away.

   **Do not print the `---DRAFT READY---` marker for this skill** — see
   "No automated critic gate for this format" below. This draft is
   reviewed by Giusi directly, in chat.

   **Don't start step 8 until Giusi has reviewed the text herself and given
   a go-ahead.** Revise per her notes and re-present the draft rather than
   moving on with an unconfirmed one.

8. **Pick the photo.** Per `reel_template.md`'s "Photo sourcing": browse
   `generate-workbook/references/media_library.md`'s subfolders for the one
   whose mood fits this episode, and pick one photo for `sfondo_hook` +
   `sfondo_cta` (same asset, bookend consistency — the second `sfondo_hook`
   element additionally needs the blur-crop treatment, see `reel_template.md`'s
   "Faking a blur"). Never generate or use a landscape/stock background for
   this format. **Page 2's photo is fixed in the template — there is
   nothing to pick or fill for it**, see `reel_template.md`'s "Fields" note.

9. **Fill the Canva template.** `create-design-from-brand-template` with
   `EAHV8s0ovFs` → `read-design` (open transaction) to get locator_ids →
   `edit-design` with `replace_text` for the text fields and `update_fill`
   for the image fields (`hook_testo`, `sfondo_hook` ×2, `quote_testo`,
   `cta_azione`, `sfondo_cta` — five fields total, page 2's photo is not
   one of them) → commit. Verify each page's after-thumbnail against
   intent before moving to the next, same discipline as the carousel
   skill.

   Then `update_title` to `HDH Reel — <episode title>` and file the design
   into the correct monthly subfolder of Canva's `Social Media Automation`
   folder (`FAHUIdsKNnM`), same convention as the carousel skill
   (`<MESE>-<ANNO>` uppercase Italian, e.g. `SETTEMBRE-2026`) — derived
   from today's date, since a reel promotes a just-released episode rather
   than targeting a future scheduled post date. `search-folders` (or
   `list-folder-items` on `FAHUIdsKNnM`) to find it; create it with
   `create-folder` if it doesn't exist yet. Never leave the design sitting
   at the folder root.

10. **Add the Instagram caption as a Canva comment on the design**
    (`comment-on-design`) — same practice established for the carousel
    posts, so the caption travels with the design for Giusi's review and
    for future voice/style reference. Split across multiple comments if it
    exceeds 1000 characters (Canva's per-comment limit).

11. **Log it.** Append an entry to `posting_log.md`: episode title/date,
    the chosen quote, `Formato: reel`, Canva design ID/URL/folder, photo(s)
    used, `Stato: draft`. Only write a "complete"/approved status once
    Giusi has actually reviewed it — never based on what you're about to
    do (same discipline as the carousel skill's logging rule).

12. **Stop here.** Give Giusi the Canva edit URL and the caption text, and
    say plainly this is a draft for her to iterate on and, when she's happy
    with it, to set the page timing/transitions in Canva by hand (see
    `reel_template.md`'s export note) before it's ready to actually export
    and post. Never call `export-design`, never touch Make, never publish
    from this skill.

## No automated critic gate for this format (decided 2026-09-22, reversing
the 2026-09-22 extension noted below)

This skill was briefly wired into the same `social-critic` Stop-hook loop
`generate-social-post` uses (triggered by the `---DRAFT READY---` marker in
`.claude/hooks/run-critic.sh`). In practice, run against a real draft, the
critic repeatedly scored `hook_testo`, `quote_testo`, and `cta_azione` as if
they were carousel fields — demanding a crafted/invented hook instead of
the episode's real title, and a hashtag block this format explicitly omits
(see step 5) — even though only the caption was meant to be in its scope.
Giusi confirmed (2026-09-22) this format doesn't play by the same rules as
a normal post and asked for the automated gate removed here.

Concretely: **this skill's step 7 never prints `---DRAFT READY---`**, so
`run-critic.sh`'s exact-last-line check never matches and the hook is a
silent no-op for every reel draft — `generate-social-post`'s carousel
workflow is unaffected and still goes through the critic normally. Review
for this format is Giusi reading the draft in chat and giving a go-ahead,
per step 7 above — don't reintroduce the marker here without discussing a
reel-appropriate rubric with her first.
