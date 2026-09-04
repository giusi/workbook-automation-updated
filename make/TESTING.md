# Reviewing and testing the scenario — without anything going live

The scenario is `HDH Social — Canva → FB / IG / Telegram` (id `9724996`).
Facebook ends in a **draft/unpublished** post, so the worst case there is an
unpublished post you delete. **Instagram and Telegram have no draft state —
their branches publish live the instant they run.** Work through this in
order: the point is you see each step do its job before the next, riskier
one is allowed to.

## 0. Two habits that keep it safe

- **Leave the scenario OFF** (the toggle on the scenario page) and use
  **Run once** for every test. That runs exactly one execution while you watch,
  instead of letting it fire whenever data arrives.
- **Disable every platform module** (Facebook, Instagram, Telegram) for the
  first two tests: right-click each → *Disable*. You'll still see exactly
  what data would have reached it — this is the actual safety mechanism, not
  a Facebook-only trick. It works the same regardless of whether the
  downstream platform has a draft state, which is why it's the right first
  check for Instagram and Telegram too.

## 1. Finish wiring it up

Per `make/README.md`'s setup list: connect Facebook Pages, Instagram
Business, and Telegram Bot; map the Canva-exported images into each
module's photo field; verify the Instagram/Telegram caption field mapping
(flagged in `make_handoff.md` as Claude's best guess, unconfirmed). Leave
all three platform modules **disabled** until step 2 is done.

## 2. First test — does the guard hold?

Test the safety net before testing the happy path. Click **Run once**, then
send this, with `cta_keyword` deliberately left as a placeholder:

```bash
curl -X POST '<YOUR_WEBHOOK_URL>' \
  -H 'Content-Type: application/json' \
  -d '{
    "schema_version": 1,
    "post_id": "TEST-guard",
    "canva_design_id": "DAHUDZQXSi0",
    "cta_keyword": "<PAROLA-CHIAVE>",
    "canali_live_confermati": [],
    "captions": { "facebook_profilo": { "testo": "TEST — non deve arrivare a Facebook" } }
  }'
```

**Expected:** the webhook receives it, and the Canva module is **skipped** —
the execution stops there. Make shows the filter as the reason.

If Canva runs anyway, stop and tell me. The filter is wrong and I'll fix it
before you go any further.

## 3. Second test — the happy path, all platform modules still disabled

**Run once** again, this time with a real keyword:

```bash
curl -X POST '<YOUR_WEBHOOK_URL>' \
  -H 'Content-Type: application/json' \
  -d '{
    "schema_version": 1,
    "post_id": "TEST-2026-08-15",
    "data_post": "2026-08-15",
    "tesi": "TEST — Non sei dipendente dal telefono.",
    "canva_design_id": "DAHUDZQXSi0",
    "cta_keyword": "PODCAST",
    "canali_live_confermati": ["instagram", "telegram"],
    "captions": {
      "facebook_profilo": { "testo": "TEST caption Facebook — non pubblicare" },
      "instagram":        { "testo": "TEST caption Instagram — non pubblicare" },
      "telegram":         { "testo": "TEST caption Telegram — non pubblicare" }
    }
  }'
```

**Expected:** the filter passes, the Canva module runs and returns export
URLs for the carousel pages. Click the Canva module's output bubble and
check the images are the right design.

Then — **with every platform module still disabled** — click each one's
mapped input bubble in turn and read what *would* have been sent: right
caption in the right field? Real keyword, no `<...>` leaking through? Image
reference present? This step alone catches most mapping mistakes without a
single live send, on any of the three platforms.

`DAHUDZQXSi0` is the real 15 August carousel, so you should recognise it.

## 4. Third test — Facebook, for real but unpublished

1. Enable the Facebook module only. Add the connection and **pick the Page**.
2. Set the post to **unpublished** (or scheduled a few hours out).
3. **Run once** and resend the step-3 payload.

**Expected:** a draft appears in the Page's publishing tools, with the caption
and the carousel images. Look at it as a reader would. Then delete it — it was
a test.

## 5. Fourth test — Instagram, for real, with no undo

There is no draft to fall back on here, so pick one before enabling the
module:

- **Test account (recommended if you have one):** connect a secondary
  Instagram professional account instead of the real one for this test.
  Confirm the mapping looks right there, then switch the connection to
  `@giusivalentinicoach` only for the actual go-live send.
- **Real account, watched:** enable the module against the real connection
  at a moment you're present and ready to delete the post within seconds if
  something's wrong. This is a real live post, briefly, not a rehearsal —
  choose this only if a test account isn't available.

Either way: enable only the Instagram module, **Run once** with the step-3
payload, and check the result on Instagram itself — caption, image, no
placeholder text.

## 6. Fifth test — Telegram, for real, with no undo

Cheaper to de-risk than Instagram:

1. Create a private test channel (just you, or you + whoever else needs to
   see it) — takes about 30 seconds in the Telegram app.
2. Point the Telegram module's `chat_id` at that test channel.
3. Enable only the Telegram module, **Run once** with the step-3 payload.
4. Check formatting, caption, and image in the test channel.
5. Once it looks right, switch `chat_id` to the real Happy Daily Body
   channel for the actual go-live send.

## 7. Going live

Only after all three platform tests have come out looking right:

- Turn the scenario toggle **on**, so real drafts arrive without you clicking
  Run once.
- Set `MAKE_WEBHOOK_URL` in the environment where `generate-social-post`/
  `schedule-social-post` run, so Claude posts to it automatically.
- Remember `canali_live_confermati` is populated **per send**, by Giusi's
  explicit per-channel yes in `schedule-social-post` — not automatically
  just because the scenario is on. An empty array is the safe default:
  Facebook still gets its draft, Instagram/Telegram simply don't fire.

Even then, Facebook's last step is always a human, in Facebook, deciding the
draft is good. Instagram and Telegram have no such step — the
`canali_live_confermati` confirmation is the only gate they get, which is
why it's asked fresh every time, never inferred.

## Still open

- **Does Make's Facebook module expose "unpublished"?** If it only posts
  live, scheduling is the workaround. Tell me what you find and I'll adjust
  the blueprint.
- **Instagram/Telegram caption field names** — Claude's best guess
  (`caption` on both), unconfirmed against Make's actual module schema this
  session (no `apps:read` scope). Verify once connected; tell me if either
  needs correcting and I'll fix the blueprint and the live scenario.
- **The other channels** — Facebook profile, the Podcast Group, and YouTube
  community posts have no API at all (YouTube confirmed against Make's own
  module list). They stay copy-paste from the review package permanently.
