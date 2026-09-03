# Make — HDH social hand-off (v1)

One scenario, three modules, no approval step:

```
Claude  →  webhook  →  Canva: esporta il design  →  Facebook Page: crea la bozza
```

`hdh-canva-to-facebook-draft.json` — import it with **Create a new scenario →
⋯ → Import Blueprint**. A blueprint carries structure, never credentials, so
connections and the webhook get attached by hand after import.

The email-approval step is **gone** on purpose. The review that used to happen
by email now happens where the draft lands: on the Facebook Page, where you
look at it and decide to publish. One fewer moving part to maintain.

## What survives from the approval version

A **filter on the Canva module**: the scenario only proceeds if the payload
declares `schema_version: 1` and its `cta_keyword` no longer contains `<`. So a
draft still carrying `<PAROLA-CHIAVE>` stops at the first module and never
reaches Facebook. That guard cost nothing to keep, and it is the one that
prevents an embarrassing post.

## Setup after import

1. **Webhook module** → **Add** → name it `hdh-social-draft` → **Save** → copy
   the URL. Put it in the environment as `MAKE_WEBHOOK_URL` where
   `generate-social-post` runs. **Never commit it** — anyone holding that URL
   can push a post into your pipeline.
2. **Canva module** → add your Canva connection. It receives `canva_design_id`
   from the payload (e.g. `DAHUDZQXSi0`) and exports the carousel pages.
3. **Facebook Pages module** → add your connection, then **choose the Page**.
   Map the exported images from the Canva module into the photos field, and
   check the module's publishing option — see the caveat below.

## The caveat that decides whether this is really a "draft"

"Draft" means something different on each platform, and only one supports it:

- **Facebook Page — yes.** Meta's API supports unpublished and scheduled posts,
  which is what makes this v1 work at all. Confirm in the module whether Make
  exposes the unpublished/scheduled option; if it only publishes live, the
  fallback is to schedule it a few hours out, which gives you the same window
  to review and cancel.
- **Instagram — no.** The API publishes; there is no draft state. Drafts exist
  only inside the app.
- **Telegram — no.** Sending is delivering.

That is why v1 is Facebook Page only. Adding Instagram or Telegram later means
accepting that those two go **live** the moment the scenario runs — a different
decision from this one, and yours to make deliberately.

Your Facebook **personal profile**, the **Podcast Group** and **YouTube** can't
be automated at all (no API for any of them), so those captions stay copy-paste
from the review package.

## Not yet validated

The blueprint passes Make's structural schema check. Module-level validation —
that each field is right for your account — needs your numeric **teamId**, which
this session has no tool to look up. It is in any Make URL:
`https://eu2.make.com/<teamId>/scenarios`. Send me that number and I'll verify
the modules before you import.
