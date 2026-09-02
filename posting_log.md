# Posting log — HDH social content

Append-only record of what `generate-social-post` has drafted. Prevents
duplicate posts and gives a durable, diffable audit trail of what went out
(or is still pending) — same spirit as `content_plan.toml`'s role for the
workbook pipeline.

## Format

One entry per post:

```
### YYYY-MM-DD | [Hook/titolo breve]
- Fonte: podcast / workbook
- Stile: pain_point / awareness / unpopular_opinion / educational / personal_experience
- Canva design URL:
- Review package: out/social/<date>-<slug>.json
- Make webhook: not yet sent (no scenario built) / sent <timestamp>
- Stato: draft / in revisione / approvato / pubblicato
---
```

`generate-social-post` appends an entry (status `draft`) at the end of each
run. Update `Stato` by hand as a post moves through review/publishing until
the Make hand-off exists to do this automatically.

## Entries

### 2026-08-15 | Non sei dipendente dal telefono. Sei dipendente dal non sentire.
- Fonte: workbook (fallback `content_plan.toml` [2026-08] — Digital Detox; `out/workbook-2026-08.json` assente)
- Stile: unpopular_opinion
- Canva design URL: — (non generato: run di test sulla sola copy)
- Review package: out/social/2026-08-15-non-sei-dipendente-dal-telefono.json
- Make webhook: not yet sent (no scenario built)
- Stato: draft — generato in sessione di test delle skill, da rivedere prima di qualsiasi uso
---

### 2026-08-22 | I primi dieci minuti di noia sono i più scomodi della tua giornata.
- Fonte: podcast ("Noia in vacanza - Cosa Stai Evitando", Castmagic 7584b6fa)
- Stile: pain_point
- Canva design URL: — (non generato: run di test sulla sola copy)
- Review package: out/social/2026-08-22-i-primi-dieci-minuti.json
- Make webhook: not yet sent (no scenario built)
- Stato: draft — generato in sessione di test delle skill, da rivedere prima di qualsiasi uso
---
