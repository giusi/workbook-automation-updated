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

### 2026-09-06 10:00 | Non devi fare tutto da sola.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: awareness
- Titolo design Canva: "6.9 at 10am - HDH Settembre — Post 1 — Non devi fare tutto da sola"
- Canva design ID: DAHUIs5jJQs
- Canva design URL: https://www.canva.com/d/sxDdLSOiRohyNyq
- Cartella Canva: Social Media Automation (FAHUIdsKNnM)
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta all'aperto, momento di quiete (MAHIIPqv0_g); pagine centrali: Background B (chioma di foresta nella nebbia)
- Testo rivisto da Giusi rispetto alla bozza: "i miei spazi online e offline" al posto di "Happy Daily Home" (slide 3); chiusura riscritta in prima persona ("io sono lì per dirti: vieni, riprendiamo da qui"); aggiunta un'ottava riga "PER SOSTENERTI HO CREATO LA LIVE — SETTEMBRE: RIPRENDI CON COSTANZA" sull'ultima slide.
- CTA podcast: parola-chiave **PODCAST** — "Commenta 'PODCAST' e ricevi il link in DM" (non più link diretto nei commenti)
- CTA masterclass: parola-chiave **SETTEMBRE** — "Scrivi 'SETTEMBRE' nei commenti e ricevi il link" — 24 settembre **ore 21**
- Make webhook: not yet sent (no scenario built)
- Stato: approvato — programmato per il 6 settembre alle 10:00. Caption multi-canale aggiornate per riflettere il testo e le due CTA reali (PODCAST/DM + SETTEMBRE/ore 21); manca ancora il link reale dell'episodio per la variante YouTube.
---

### 2026-09-10 21:00 | Anche da ferma, nella tua testa stai ancora correndo.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: pain_point
- Titolo design Canva: "10.9 at 9 pm HDH Settembre — Post 2 — Anche da ferma, stai ancora correndo"
- Canva design ID: DAHUIvLuHNM
- Canva design URL: https://www.canva.com/d/68NWgb6i26fblNA
- Cartella Canva: Social Media Automation (FAHUIdsKNnM)
- Sfondo: Background A (campi verdi, foto stock Canva)
- Design accorciato in revisione da 6 a 5 pagine: la CTA podcast è stata rimossa, resta solo la CTA masterclass. Testo valore/chiusura leggermente rivisto ("da seduta" invece di "da ferma"; "mente" invece di "testa").
- CTA masterclass: parola-chiave **SETTEMBRE** — "Scrivi 'SETTEMBRE' nei commenti e ricevi il link" — 24 settembre 2026 (nessun orario indicato in questo design, a differenza del Post 1 che riporta "ore 21" — verificare con Giusi se è lo stesso evento)
- Approved record: approved/social/2026-09-10-anche-da-ferma-stai-ancora-correndo.md (.json) — backfilled 2026-09-04 so the approved copy survives even though out/ is ephemeral; not a send record, nothing has gone to Make.
- Make webhook: not yet sent (scenario built — id 9724996, "HDH Social — Canva → FB / IG / Telegram" — but Facebook/Instagram/Telegram connections not yet made; MAKE_WEBHOOK_URL not set)
- Stato: approvato — programmato per il 10 settembre alle 21:00. Caption multi-canale aggiornate: rimosso ogni riferimento alla CTA podcast (non più presente nel design).
---

### DATA DA ASSEGNARE (Settembre 2026) | Non serve la giornata ideale per prenderti cura di te. Serve iniziare in quella che hai davvero.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: awareness
- Titolo design Canva: "HDH Settembre — Post 3 — La giornata ideale non esiste"
- Canva design ID: DAHUIpHwuP4
- Canva design URL: https://www.canva.com/d/v60qR7drvz6OPC8
- Cartella Canva: Social Media Automation (FAHUIdsKNnM)
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta in città, ritratto lifestyle (MAGoD4-QrOk); pagine centrali: Background A (campi verdi, cielo velato)
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — testo e design completi (tutte le pagine, CTA con parola-chiave reale e data della diretta), in attesa solo della data di pubblicazione
---

### DATA DA ASSEGNARE (Settembre 2026) | Anche quando un ciclo si chiude, il tuo spazio vitale non è un capriccio da sacrificare.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: personal_experience
- Formato: carosello statico a 7 pagine (ripristinato dal formato Reel su richiesta di Giusi) — costruito con il brand template master "Master carousel" (EAHT9Ay4G_4)
- Titolo design Canva: "HDH Settembre — Post 4 — Il ciclo che si chiude"
- Canva design ID: DAHUI6esOjk
- Canva design URL: https://www.canva.com/d/Hi8DUybUwdxKdpP
- Cartella Canva: Social Media Automation (FAHUIdsKNnM)
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta all'aperto, momento di quiete (MAHIIPqv0_g); pagine centrali: Background B (chioma di foresta nella nebbia). Testo valore1-3 ricostruito ex novo (non recuperabile dal Reel, che li aveva assorbiti in un'unica slide) — da rivedere con attenzione in più rispetto agli altri post già approvati.
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — carosello ricostruito da zero, testo valore1-3 NUOVO e non ancora approvato da Giusi, in attesa di revisione prima della data di pubblicazione
---

### 2026-09-12 10:00 | Essere costante non è dare il 100%.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: educational
- Titolo design Canva: "12.9 at 10 am HDH Settembre — Post 5 — Il 30% è costanza vera"
- Canva design ID: DAHUItopUiI
- Canva design URL: https://www.canva.com/d/67dYzu3TQCkheAL
- Cartella Canva: Social Media Automation (FAHUIdsKNnM)
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi seduta in città, ritratto lifestyle (MAGoD4-QrOk); pagine centrali: Background B (chioma di foresta nella nebbia)
- Design accorciato in revisione da 7 a 6 pagine: la CTA podcast è stata rimossa, resta solo la CTA masterclass. Hook leggermente riformulato ("non è dare il 100%" invece di "non significa dare il 100%").
- CTA masterclass: parola-chiave **SETTEMBRE** — "Commenta 'SETTEMBRE' e ricevi il link in DM" — 24 settembre **ore 21**
- Approved record: approved/social/2026-09-12-il-30-percento-costanza-vera.md (.json) — backfilled 2026-09-04 so the approved copy survives even though out/ is ephemeral; not a send record, nothing has gone to Make.
- Make webhook: not yet sent (scenario built — id 9724996, "HDH Social — Canva → FB / IG / Telegram" — but Facebook/Instagram/Telegram connections not yet made; MAKE_WEBHOOK_URL not set)
- Stato: approvato — programmato per il 12 settembre alle 10:00. Caption multi-canale aggiornate: rimosso ogni riferimento alla CTA podcast, CTA masterclass ora dice esplicitamente "in DM".
---

### 2026-09-08 13:00 | Smetti di ricominciare sempre da capo.
- Fonte: annuncio diretto masterclass (non fa parte dei 6 post-carosello dal podcast di settembre — post promozionale standalone, trovato già presente e approvato nella cartella Canva)
- Stile: n/d — non rientra nelle 5 categorie standard (pain_point/awareness/unpopular_opinion/educational/personal_experience); è un invito diretto all'evento, non un post costruito su una tesi editoriale. Da confermare con Giusi come classificarlo per la rotazione stile.
- Titolo design Canva: "8.9 at 1 pm HDH Settembre "
- Canva design ID: DAHUJs4-4us
- Canva design URL: https://www.canva.com/d/EBvNA_RszI9Qx8m
- Cartella Canva: Social Media Automation (FAHUIdsKNnM)
- Testo: "Smetti di ricominciare sempre da capo." / "SETTEMBRE È QUI. L'estate ti ha fatto cambiare ritmo... è tempo di ripartire, di ritrovare la direzione della tua vita." / "Iscriviti ora alla MASTERCLASS LIVE & GRATIS 24 settembre ore 21 — SETTEMBRE: RIPARTI CON COSTANZA" / "Partecipa GRATIS commenta 'settembre' e ricevi il link in DM"
- CTA: parola-chiave **SETTEMBRE** — "commenta 'settembre' e ricevi il link in DM" — 24 settembre ore 21
- Review package: out/social/settembre-post7-smetti-di-ricominciare.json
- Make webhook: not yet sent (no scenario built)
- Stato: approvato — programmato per l'8 settembre alle 13:00. Caption multi-canale redatte (adattate al formato invito diretto, senza l'arco narrativo hook/valore/chiusura degli altri post).
---

### DATA DA ASSEGNARE (Settembre 2026) | Non ti manca la disciplina. Ti manca il permesso di non essere sempre al 100%.
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: unpopular_opinion
- Titolo design Canva: "HDH Settembre — Post 6 — Il permesso di non essere al 100%"
- Canva design ID: DAHUIqRslSc
- Canva design URL: https://www.canva.com/d/_j6BY6WpI-409cl
- Cartella Canva: Social Media Automation (FAHUIdsKNnM)
- Sfondo: Background A (campi verdi, foto stock Canva)
- Parola-chiave CTA: SETTEMBRE
- Data diretta masterclass: 24 settembre (aggiunta sull'ultima slide del carosello)
- Make webhook: not yet sent (no scenario built)
- Stato: draft — testo e design completi (tutte le pagine, CTA con parola-chiave reale e data della diretta), in attesa solo della data di pubblicazione
---
