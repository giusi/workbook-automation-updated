# HDH Podcast Reel — Canva brand template

Brand template id **`EAHV8s0ovFs`** — https://www.canva.com/brand/brand-templates/EAHV8s0ovFs

(Superseded `EAHV8Iu7jbk` on 2026-09-22 — see "History" at the bottom.
Don't use the old id; it's retired, not a fallback.)

3 pages, 1080x1920 (portrait, 9:16 — Reels/Stories ratio). Built from
Giusi's real "Come non perderti di nuovo" reel (`DAHVpz0P6HM`, still
untouched — the template was built from a *copy*, `copy-design` then
`update_autofill_field` then `publish-brand-template`, done by Giusi
herself in the Canva UI since this connector lacks brand-template-publish
permission), so the visual DNA (hero-photo hook, pull-quote card, CTA card,
all carrying the "HAPPY DAILY PODCAST" badge) matches a real post exactly —
not a from-scratch design.

**Scope: podcast-episode reels only.** This format promotes one specific
episode — a hook slide announcing it, a verbatim quote from it, and a CTA to
get the link. It is not a general-purpose reel shape (no masterclass CTA
variant exists) — see SKILL.md.

Fill via the same mechanism as the carousel template:
`create-design-from-brand-template` → `read-design` (open transaction) to
get locator_ids → `edit-design` with `replace_text` per text field and
`update_fill` for the image fields → commit.

## Fields

| Page | Field | Type | Notes |
|---|---|---|---|
| 1 (hook) | `hook_testo` | text | **The episode's real title, verbatim** — never an invented hook line. This is the one place this template differs sharply from the carousel: the carousel's `hook_testo` is a crafted thesis sentence, this one is just the episode's actual name. |
| 1 | `sfondo_hook` | image | Full-bleed hero photo of Giusi. Appears on **two separate elements** on this page (the main background and a second crop behind the bottom info bar) — both carry this same field label, so setting the fill applies to both independently. Same asset on both, but the second element needs a heavily zoomed/blurred crop — see "Photo sourcing" below, "Faking a blur". |
| 2 (quote) | `quote_testo` | text | One verbatim quote pulled from the transcript. Never paraphrased, never invented — see SKILL.md's transcript rule. |
| 3 (CTA) | `cta_azione` | text | Fixed pattern: `Rispondi "PODCAST" per ricevere il link in DM`. The keyword is **always PODCAST** for this format — unlike the carousel's masterclass CTA, this never needs confirming with Giusi each run. |
| 3 | `sfondo_cta` | image | Full-bleed hero photo — same asset as `sfondo_hook` by default (bookend consistency, matches the real example). |

**Page 2's photo is not a field — it's permanently fixed in the template
(confirmed 2026-09-22).** Earlier versions of this pipeline treated it as a
per-run `sfondo_quote` field, which produced crop mismatches every run (see
"History" below). Giusi asked for it to just never change: the autofill tag
was removed when the current template was published, so
`create-design-from-brand-template` always produces this field pre-filled
with the same photo and crop, and there is nothing to set here. **Do not
try to `update_fill` or `crop_media` this element** — it has no
`dataFieldLabel`, so there's no locator to target via the field name, and
touching it defeats the point. If a future request wants page 2's photo to
vary again, that's a template change to discuss with Giusi first, not a
per-run decision.

**Static brand chrome — never a field, never varies:** the "HAPPY DAILY
PODCAST" badge + mic icon (pages 1 and 3), the "Ascoltalo ora" pill and
"NUOVO EPISODIO / Su Spotify, Apple Podcast e Youtube" line (page 1), the
quotation-mark icon, "dal podcast" label, and "Giusi Valentini" attribution
(page 2). If a future post ever needs one of these to vary (a guest episode
with a different attribution name, a platform not carrying the show), that's
a one-off manual edit in Canva after filling the template — not something
this pipeline should turn into a field on a hunch.

## Photo sourcing — always Giusi's real photo (confirmed 2026-09-22)

Unlike the carousel's 50/50 landscape-vs-photo split, **every reel uses
Giusi's real photo on every image field** — there is no landscape variant
for this format. Source from `generate-workbook/references/media_library.md`
the same way the carousel does, picking whichever subfolder's mood matches
the episode. Default pattern, matching the real example:

- `sfondo_hook` (main, full-bleed), `sfondo_cta`, and `sfondo_hook`
  (second element, the crop behind the bottom info bar on page 1) — the
  same photo on all three. The second element needs a blurred treatment;
  see "Faking a blur" below.
- Page 2's photo — nothing to source; see the "Fields" note above.

Never fall back to a generated/stock landscape for this format.

### Faking a blur on page 1's bottom strip (confirmed 2026-09-22)

The real founding example (`DAHVpz0P6HM`) has its bottom-bar element
(second `sfondo_hook` instance) showing a soft, out-of-focus look. There is
**no blur/filter operation available** in the Canva MCP `edit-design`
toolset (checked the full operations list: no such op exists) — `crop_media`
is the only lever. Fake the blur by cropping to an extreme zoom on a small
patch of the same hero photo, ideally a background area away from her face:

1. Read the main element's `imageBox` (`{top, left, width, height}`) —
   this is the "1x" mapping of the full photo.
2. Pick a small patch in that same image-space, aspect-matched to the
   target rect (`width:height` ratio of the second element, e.g.
   ~1.78:1 for this template) — a corner/edge area, not the center where
   her face usually sits.
3. Compute a zoom factor `k = target_rect_width / patch_width` (typically
   5-10x is enough to blur out detail via upscale interpolation).
4. `crop_media` with `width = imageBox.width * k`, `height =
   imageBox.height * k`, `left = -(patch_x * k)`, `top = -(patch_y * k)`.

This isn't a true Gaussian blur — it's forced upscale interpolation — but
at 5x+ zoom it reads as a soft, indistinct color field, which is what the
real example's bottom strip actually looks like. Re-verify against the
after-thumbnail; if it still shows visible texture, increase `k`.

## Export / video (out of scope for `generate-social-reel`)

This template's pages are **static** (`type: "fixed"`, no video elements).
The Canva API has no operation to set per-page duration, transitions, or
audio — those must be set **once, by hand, in Canva**, directly on this
brand template (`EAHV8s0ovFs`), so every reel instantiated from it inherits
the same fixed pacing automatically. `generate-social-reel` never calls
`export-design` — per Giusi (2026-09-22), the MP4 export is a job for
whatever mechanism eventually handles the Make hand-off for reels (not yet
built, same status as the carousel's Make scenario), not for the drafting
skill. `generate-social-reel` stops at a filled Canva design and its edit
URL, exactly like `generate-social-post` stops before touching Make.

## Editing gotchas

Same mechanics as the carousel template (see
`hdh-social-copy/references/social_carousel_template.md`'s "Editing
gotchas") — verify every `edit-design` call's after-thumbnail against intent,
re-read `page_metadata` if a page count ever looks off after a commit, and
never mark a `posting_log.md` entry as done before the commit has actually
succeeded.

This connector's Canva account has **no brand-template-publish permission**
(`create-brand-template-draft` and `publish-brand-template` both fail with
an access/permission error, even from a design this session fully owns).
If this template ever needs another structural change (a new/removed
field, a different fixed photo), the pipeline can prepare an edited *copy*
of the current template's source design and hand Giusi its edit URL to
publish herself in the Canva UI — it cannot publish the change directly.

## Verified 2026-09-22

Confirmed via `get-brand-template-dataset` on `EAHV8s0ovFs`: exactly 5
fields (`hook_testo`, `sfondo_hook`, `quote_testo`, `cta_azione`,
`sfondo_cta`) — `sfondo_quote` correctly absent, confirming page 2's photo
is fixed. Confirmed via `create-design-from-brand-template` that
instantiating the template produces a clean 3-page design with placeholder
text/images on exactly the tagged fields.

## History

- **2026-09-22, built:** `EAHV8Iu7jbk` created from `DAHVpz0P6HM` with 6
  fields, `sfondo_quote` included as a per-run image field.
- **Same day, in use:** filling `sfondo_quote` via `update_fill` produced a
  Canva auto-fit crop that didn't match the real example (different
  zoom/centering), and iterating it by hand (`crop_media`) each run was
  fragile — see `posting_log.md`'s 2026-09-22 reel entry for the
  back-and-forth. Giusi asked to just fix the photo permanently instead of
  re-deciding it every run.
- **Same day, superseded:** a fresh copy of `DAHVpz0P6HM` was tagged with
  the same 5 fields minus `sfondo_quote` (left untagged so its photo/crop
  stays whatever was in the copy at publish time), and published as
  `EAHV8s0ovFs` by Giusi directly in Canva (this connector can't publish
  brand templates itself). `EAHV8Iu7jbk` was deleted by Giusi and is no
  longer usable.
