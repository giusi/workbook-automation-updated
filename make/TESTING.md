# Reviewing and testing the scenario — without anything going live

The scenario ends by creating a **draft/unpublished** post on the Facebook
Page, so the worst case is an unpublished post you delete. Still, work through
this in order: the point is that you see each step do its job before the next
one is allowed to.

## 0. Two habits that keep it safe

- **Leave the scenario OFF** (the toggle on the scenario page) and use
  **Run once** for every test. That runs exactly one execution while you watch,
  instead of letting it fire whenever data arrives.
- **Disable the Facebook module** for the first two tests: right-click it →
  *Disable*. You'll still see exactly what data would have reached it.

## 1. Import and wire it up

1. Make → **Create a new scenario** → **⋯** → **Import Blueprint** → upload
   `hdh-canva-to-facebook-draft.json`.
2. **Right-click the Facebook module → Disable.** Do this before adding any
   connection.
3. Webhook module → **Add** → name `hdh-social-draft` → **Save** → copy the URL.
4. Canva module → add your Canva connection.
5. **Save**. Leave the scenario off.

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
    "captions": { "facebook_profilo": { "testo": "TEST — non deve arrivare a Facebook" } }
  }'
```

**Expected:** the webhook receives it, and the Canva module is **skipped** —
the execution stops there. Make shows the filter as the reason.

If Canva runs anyway, stop and tell me. The filter is wrong and I'll fix it
before you go any further.

## 3. Second test — the happy path, Facebook still disabled

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
    "captions": { "facebook_profilo": { "testo": "TEST caption Facebook — non pubblicare" } }
  }'
```

**Expected:** the filter passes, the Canva module runs and returns export URLs
for the seven carousel pages. Click the Canva module's output bubble and check
the images are the right design — that's the whole "from Canva" half of this
pipeline proving itself.

`DAHUDZQXSi0` is the real 15 August carousel, so you should recognise it.

## 4. Third test — Facebook, for real but unpublished

1. Enable the Facebook module. Add the connection and **pick the Page**.
2. Map the Canva images into the photos field.
3. Set the post to **unpublished** (or scheduled a few hours out — see
   `README.md` on why this matters).
4. **Run once** and resend the step-3 payload.

**Expected:** a draft appears in the Page's publishing tools, with the caption
and the carousel images. Look at it as a reader would. Then delete it — it was
a test.

## 5. Going live

Only after a test draft has come out looking right:

- Turn the scenario toggle **on**, so real drafts arrive without you clicking
  Run once.
- Set `MAKE_WEBHOOK_URL` in the environment where `generate-social-post` runs,
  so Claude posts to it automatically.

Even then nothing publishes itself — the last step is always you, in Facebook,
deciding the draft is good.

## Still open

- **Does Make's module expose "unpublished"?** If it only posts live,
  scheduling is the workaround. Tell me what you find in the module and I'll
  adjust the blueprint.
- **The other channels.** Instagram and Telegram have no draft state; adding
  them means going live on send. Facebook profile, the Group and YouTube have
  no API at all — those stay copy-paste.
