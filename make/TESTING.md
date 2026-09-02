# Reviewing and testing the two scenarios — by hand, without publishing anything

Written so nothing reaches Instagram, Facebook or Telegram while you test.
Follow it in order; the publishing modules stay disabled until the last step,
which is yours to decide on, not mine.

## 0. Before you start

Scenario 2 can post publicly. Two habits make the whole thing safe:

- **Leave both scenarios OFF** (the toggle on the scenario page). A webhook
  still queues incoming data while the scenario is off, and "Run once" lets you
  execute deliberately, one execution at a time, watching it happen.
- **Disable the three platform modules** in scenario 2 before its first run:
  right-click each module → *Disable*. A disabled module is skipped and the
  execution still shows you exactly what data would have reached it.

---

## 1. Import scenario 1 (review email)

1. Make → **Create a new scenario** → the **⋯** menu (top right) → **Import Blueprint**.
2. Upload `01-review-draft.json`. It opens as *HDH social — 1. Review draft*.
3. Click the **webhook** module → **Add** → name it `hdh-social-draft` → **Save**.
   Copy the URL it shows. That URL is a credential — anyone with it can put a
   post in your review queue, so don't paste it into a shared doc or a repo.
4. Click each of the **two email modules** → pick your email connection
   (or **Add** one). Check the recipient is right; it's pre-filled with
   `admin@giusivalentini.com`.
5. **Save** the scenario (bottom left). Leave it **off**.

## 2. Feed it a test payload

With the scenario still off, click **Run once**. Make waits for one webhook
call. Now send it this — from a terminal, replacing the URL with yours:

```bash
curl -X POST '<YOUR_hdh-social-draft_URL>' \
  -H 'Content-Type: application/json' \
  -d '{
    "schema_version": 1,
    "post_id": "TEST-2026-08-15",
    "data_post": "2026-08-15",
    "fonte": "workbook",
    "stile": "unpopular_opinion",
    "tesi": "TEST — Non sei dipendente dal telefono. Sei dipendente dal non sentire.",
    "avatar": "Giulia",
    "canva_design_url": "https://www.canva.com/design/DAHUDZQXSi0/edit",
    "canva_design_id": "DAHUDZQXSi0",
    "mese_anno_tag": "Agosto 2026",
    "cta_keyword": "PODCAST",
    "captions": {
      "instagram":        { "testo": "TEST caption Instagram", "hashtag": ["#test"] },
      "facebook_profilo": { "testo": "TEST caption Facebook", "hashtag": ["#test"] },
      "facebook_gruppo":  { "testo": "TEST caption Gruppo", "hashtag": [] },
      "youtube":          { "testo": "TEST caption YouTube", "hashtag": [], "link_episodio": null },
      "telegram":         { "testo": "TEST caption Telegram", "hashtag": [] }
    },
    "aperti": ["Questo è un test — non pubblicare"],
    "review_package_path": "out/social/TEST.json"
  }'
```

No terminal? Paste the URL into a browser tab with the payload appended as query
parameters, or use Make's own **Postman-style** test in the webhook module.

**What you should see:** one execution, the router taking the *first* route, and
an email arriving with the thesis, the Canva link, all five captions and two
links at the bottom. The approve link is still `<<APPROVE_WEBHOOK_URL>>` — it
won't work yet. That's expected; you wire it in step 4.

## 3. Test the guard — the part worth testing most

Run once again, and send the same payload with **one change**:

```
"cta_keyword": "<PAROLA-CHIAVE>"
```

**What you should see:** the router takes the *second* route instead. You get an
email saying the draft is not publishable, **with no approve link in it**. That
is the safety net working: a draft with an unresolved placeholder cannot reach a
publish step even if you wanted it to.

If you get the normal review email instead, stop and tell me — the filter is
wrong and I'll fix it before anything else.

## 4. Import scenario 2 (publish) — with its hands tied

1. Import `02-publish-approved.json` the same way.
2. **Right-click each of the three platform modules → Disable.** Do this first,
   before adding any connection. A disabled module cannot post.
3. Click the webhook module → **Add** → name it `hdh-social-approve` → copy its URL.
4. Go back to scenario 1, open **both** email modules, and replace both
   occurrences of `<<APPROVE_WEBHOOK_URL>>` with that URL. Save.
5. Now re-run the step-2 test, open the review email, and click **APPROVA**.
   Scenario 2 (set to **Run once**) receives it. With the modules disabled you
   see the data arrive and stop — nothing is posted.
6. Check the `decision` field arrived as `approve`. Click **RIFIUTA** on another
   test and confirm the filters block all three branches.

## 5. Only when you're ready to go live

One channel at a time, not all three:

1. Add the connection to **one** module — Telegram is the gentlest to test,
   since you can point it at a private test channel first.
2. Enable that one module. Leave the other two disabled.
3. Run the whole flow end to end with a real draft. Look at what actually posted.
4. If it's right, repeat for the next channel.

Turning the scenario toggles **on** is the last step of all, and only once a
real post has gone out correctly under **Run once**.

---

## What still needs deciding

- **Which Facebook?** The blueprint uses `facebook-pages`. If you post to your
  personal profile rather than a Page, that module can't work — Meta has no API
  for personal profiles. See `README.md`.
- **The images.** Neither blueprint attaches the carousel images yet: the
  Instagram and Telegram modules need image URLs, and the Canva export step
  isn't built. For now the review email carries the Canva link and you attach
  images by hand. Tell me if you want the export automated and I'll add it.
- **The CTA keyword.** Still a placeholder in every draft — which is precisely
  what the step-3 guard is there to catch.
