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
