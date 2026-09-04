# Ready-to-fire test payloads — Post 2 (10/9) and Post 5 (12/9)

Real approved copy, not placeholder test data — matches
`approved/social/2026-09-10-anche-da-ferma-stai-ancora-correndo.json` and
`approved/social/2026-09-12-il-30-percento-costanza-vera.json`. Use these
once you're back in Make and ready to run `make/TESTING.md`'s steps 2-3
(guard filter, then happy path with every platform module still disabled —
neither step needs Facebook/Instagram/Telegram connected).

Replace `<YOUR_WEBHOOK_URL>` with the scenario's webhook address (visible on
the first module once you open it in Make, or ask Claude — it's not written
into this repo on purpose).

## Post 2 — "Anche da ferma, nella tua testa stai ancora correndo."

### Guard-filter test (expect: Canva module skipped)

```bash
curl -X POST '<YOUR_WEBHOOK_URL>' \
  -H 'Content-Type: application/json' \
  -d '{
    "schema_version": 1,
    "post_id": "TEST-guard-post2",
    "canva_design_id": "DAHUIvLuHNM",
    "cta_keyword": "<PAROLA-CHIAVE>",
    "canali_live_confermati": [],
    "captions": { "facebook_profilo": { "testo": "TEST — non deve arrivare a Facebook" } }
  }'
```

### Happy-path test — all platform modules still DISABLED, inspect input only

```bash
curl -X POST '<YOUR_WEBHOOK_URL>' \
  -H 'Content-Type: application/json' \
  -d '{
    "schema_version": 1,
    "post_id": "2026-09-10-anche-da-ferma-stai-ancora-correndo",
    "data_post": "2026-09-10",
    "tesi": "Anche da ferma, nella tua testa stai ancora correndo.",
    "canva_design_id": "DAHUIvLuHNM",
    "cta_keyword": "SETTEMBRE",
    "canali_live_confermati": ["instagram", "telegram"],
    "captions": {
      "facebook_profilo": { "testo": "Anche da ferma, nella tua testa stai ancora correndo.\n\nDevo ricordare, devo rispondere, devo sistemare — un carosello di pensieri che non si ferma mai, anche quando il corpo è fermo.\n\nNon è pigrizia se sei stanca anche da seduta. È che nella tua mente non ti sei mai fermata.\n\nIl 24 settembre, masterclass gratuita: scrivi SETTEMBRE nei commenti e ricevi il link." },
      "instagram": { "testo": "Anche da ferma, nella tua testa stai ancora correndo.\n\nDevo ricordare. Devo rispondere. Devo sistemare. Un carosello di pensieri che non si ferma mai.\n\nMagari sei fisicamente ferma, a casa. Potresti riposarti. Ma la tua mente continua a correre.\n\nNon è pigrizia se sei stanca anche da seduta. È che nella tua mente non ti sei mai fermata.\n\nIl 24 settembre c'\''è la masterclass gratuita: scrivi SETTEMBRE nei commenti e ricevi il link." },
      "telegram": { "testo": "Anche da ferma, nella tua testa stai ancora correndo.\nNon è pigrizia se sei stanca pur non facendo nulla — è che dentro non ti sei mai davvero fermata.\nIl 24/9 c'\''è la masterclass gratuita: scrivi SETTEMBRE e ti mando il link." }
    }
  }'
```

**Note this design has no podcast CTA** (removed when Giusi edited it) —
`canva_design_id` here exports the real 5-page carousel, so the Canva
module's output should show that, not the original 6-page draft.

## Post 5 — "Essere costante non è dare il 100%."

### Guard-filter test (expect: Canva module skipped)

```bash
curl -X POST '<YOUR_WEBHOOK_URL>' \
  -H 'Content-Type: application/json' \
  -d '{
    "schema_version": 1,
    "post_id": "TEST-guard-post5",
    "canva_design_id": "DAHUItopUiI",
    "cta_keyword": "<PAROLA-CHIAVE>",
    "canali_live_confermati": [],
    "captions": { "facebook_profilo": { "testo": "TEST — non deve arrivare a Facebook" } }
  }'
```

### Happy-path test — all platform modules still DISABLED, inspect input only

```bash
curl -X POST '<YOUR_WEBHOOK_URL>' \
  -H 'Content-Type: application/json' \
  -d '{
    "schema_version": 1,
    "post_id": "2026-09-12-il-30-percento-costanza-vera",
    "data_post": "2026-09-12",
    "tesi": "Essere costante non è dare il 100%.",
    "canva_design_id": "DAHUItopUiI",
    "cta_keyword": "SETTEMBRE",
    "canali_live_confermati": ["instagram", "telegram"],
    "captions": {
      "facebook_profilo": { "testo": "Essere costante non è dare il 100%. Significa non abbandonarti quando puoi dare solo il 30%.\n\nMolte vivono nel meccanismo del tutto o niente. Prova questo: invece di \"ce la faccio al 100%\", chiediti \"cosa posso fare per me, oggi\". Anche 10 minuti.\n\nIl 30% che dai oggi non è meno costanza. È costanza vera.\n\nCommenta SETTEMBRE e ti mando in DM il link della masterclass gratuita del 24 settembre, ore 21." },
      "instagram": { "testo": "Essere costante non è dare il 100%. Significa non abbandonarti quando puoi dare solo il 30%.\n\nMolte vivono nel meccanismo del tutto o niente: se non posso fare un'\''ora, non faccio niente. Se ho saltato due volte, ho perso il ritmo.\n\nProva questo: invece di chiederti \"ce la faccio al 100%\", chiediti \"cosa posso fare per me, oggi\". Anche solo 10 minuti, o meno.\n\nSe salti, non serve aspettare lunedì, il mese prossimo o gennaio. Riprendi il momento dopo, senza pensare al momento perfetto.\n\nIl 30% che dai oggi non è meno costanza. È costanza vera.\n\nCommenta SETTEMBRE e ti mando in DM il link della masterclass gratuita del 24 settembre, ore 21." },
      "telegram": { "testo": "Essere costante non è dare il 100%.\nSignifica non abbandonarti quando puoi dare solo il 30%. Un esercizio semplice da provare oggi: invece di \"ce la faccio al 100%\", chiediti \"cosa posso fare per me, ora\".\nCommenta SETTEMBRE: ti mando in DM il link della masterclass gratuita del 24 settembre, ore 21." }
    }
  }'
```

## After both happy-path tests

With all three platform modules still disabled, click each one's mapped
input bubble and check: right caption in the right field, real keyword
(no `<...>`), image reference present. This is the actual validation —
see `make/TESTING.md` for why disabled-and-inspect works the same whether
or not the platform has a draft state.

Only move to a real send (steps 4-6 in `make/TESTING.md`) once Facebook,
Instagram and Telegram are connected.
