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
- Canva design URL: https://www.canva.com/design/DAHUDZQXSi0/edit
- Review package: out/social/2026-08-15-non-sei-dipendente-dal-telefono.json
- Make webhook: not yet sent (no scenario built)
- Stato: draft — generato in sessione di test delle skill, da rivedere prima di qualsiasi uso
---

### 2026-08-22 | I primi dieci minuti di noia sono i più scomodi della tua giornata.
- Fonte: podcast ("Noia in vacanza - Cosa Stai Evitando", Castmagic 7584b6fa)
- Stile: pain_point
- Canva design URL: https://www.canva.com/design/DAHUDSz52sQ/edit
- Review package: out/social/2026-08-22-i-primi-dieci-minuti.json
- Make webhook: not yet sent (no scenario built)
- Stato: draft — generato in sessione di test delle skill, da rivedere prima di qualsiasi uso
---

### 2026-08-29 | La pratica non è quando ti siedi a meditare. È il minuto in cui fermi la mano.
- Fonte: podcast ("Noia in vacanza - Cosa Stai Evitando", sezione 4 pilastri) + tema workbook agosto
- Stile: educational
- Canva design URL: https://www.canva.com/design/DAHUDQcArnE/edit
- Review package: out/social/2026-08-29-la-pratica-non-e-quando-ti-siedi.json
- Make webhook: not yet sent (no scenario built)
- Stato: draft — generato in sessione di test delle skill, da rivedere prima di qualsiasi uso
---

### DATA DA ASSEGNARE (Settembre 2026) | Non ti manca la disciplina. Ti manca il permesso di non essere sempre al 100%.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: unpopular_opinion
- Titolo design Canva: "HDH Settembre — Post 3 — Il permesso di non essere al 100%"
- Canva design URL: https://www.canva.com/d/G5dofjsM84Hywcl
- Sfondo: Background A (campi verdi, foto stock Canva)
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — testo e design completi (tutte le pagine, CTA con parola-chiave reale e data della diretta), in attesa solo della data di pubblicazione
---

### DATA DA ASSEGNARE (Settembre 2026) | Non devi fare tutto da sola. Prenderti cura di te può essere una cosa fatta insieme.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: awareness
- Titolo design Canva: "HDH Settembre — Post 4 — Non devi fare tutto da sola"
- Canva design URL: https://www.canva.com/d/OmoLcqoAjrShkVM
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta all'aperto, momento di quiete (MAHIIPqv0_g); pagine centrali: Background B (chioma di foresta nella nebbia)
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — testo e design completi (tutte le pagine, CTA con parola-chiave reale e data della diretta), in attesa solo della data di pubblicazione
---

### DATA DA ASSEGNARE (Settembre 2026) | Essere costante non significa dare il 100%. Significa non abbandonarti quando puoi dare solo il 30%.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: educational
- Titolo design Canva: "HDH Settembre — Post 5 — Il 30% è costanza vera"
- Canva design URL: https://www.canva.com/d/QIK29XxH0g9nGq4
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta in città, ritratto lifestyle (MAGoD4-QrOk); pagine centrali: Background B (chioma di foresta nella nebbia)
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — testo e design completi (tutte le pagine, CTA con parola-chiave reale e data della diretta), in attesa solo della data di pubblicazione
---

### DATA DA ASSEGNARE (Settembre 2026) | Anche da ferma, nella tua testa stai ancora correndo.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: pain_point
- Titolo design Canva: "HDH Settembre — Post 6 — Anche da ferma, stai ancora correndo"
- Canva design URL: https://www.canva.com/d/GiuYzPlJ2A5g1pI
- Sfondo: Background A (campi verdi, foto stock Canva)
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — testo e design completi (tutte le pagine, CTA con parola-chiave reale e data della diretta), in attesa solo della data di pubblicazione
---

### DATA DA ASSEGNARE (Settembre 2026) | Anche quando un ciclo si chiude, il tuo spazio vitale non è un capriccio da sacrificare.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: personal_experience
- Formato: carosello statico a 7 pagine (ripristinato dal formato Reel su richiesta di Giusi) — costruito con il brand template master "Master carousel" (EAHT9Ay4G_4)
- Titolo design Canva: "HDH Settembre — Post 7 — Il ciclo che si chiude"
- Canva design URL: https://www.canva.com/d/wGnPldzTAQ-qHoe
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta all'aperto, momento di quiete (MAHIIPqv0_g); pagine centrali: Background B (chioma di foresta nella nebbia). Testo valore1-3 ricostruito ex novo (non recuperabile dal Reel, che li aveva assorbiti in un'unica slide) — da rivedere con attenzione in più rispetto agli altri post già approvati.
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — carosello ricostruito da zero, testo valore1-3 NUOVO e non ancora approvato da Giusi, in attesa di revisione prima della data di pubblicazione
---

### DATA DA ASSEGNARE (Settembre 2026) | Non serve la giornata ideale per prenderti cura di te. Serve iniziare in quella che hai davvero.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: awareness
- Titolo design Canva: "HDH Settembre — Post 9 — La giornata ideale non esiste"
- Canva design URL: https://www.canva.com/d/IX-7oVs13llNyD6
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta in città, ritratto lifestyle (MAGoD4-QrOk); pagine centrali: Background A (campi verdi, cielo velato)
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — testo e design completi (tutte le pagine, CTA con parola-chiave reale e data della diretta), in attesa solo della data di pubblicazione
---
