# Posting log — HDH social content

Append-only record of what `generate-social-post` (carousels) and
`generate-social-reel` (podcast-episode reels) have drafted. Prevents
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

`generate-social-reel` entries add `Formato: reel` plus the episode title
and chosen quote in place of the carousel's beat structure — see
`.claude/skills/generate-social-reel/references/reel_template.md`. Before
picking an episode, that skill greps this file for existing `Formato: reel`
entries to avoid reel-ifying the same episode twice.

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
- Approved record: approved/social/2026-09-12-il-30-percento-costanza-vera.md (.json) — this was the pipeline's approved DRAFT caption, backfilled 2026-09-04 (out/ is ephemeral); superseded, see below.
- Make webhook: not yet sent (scenario built — id 9724996, "HDH Social — Canva → FB / IG / Telegram" — but Facebook/Instagram/Telegram connections not yet made; MAKE_WEBHOOK_URL not set)
- Stato: **pubblicato** — questo design è effettivamente uscito su Instagram il 16 settembre 2026 (https://www.instagram.com/p/DdV6jVVjR3P/), non il 12 come programmato, e con la caption riscritta in prima persona rispetto alla bozza approvata l'8.4. Il testo realmente pubblicato è archiviato in approved/social/2026-09-16-essere-costante-non-e-impeccabile.md (.json) — confermato da Giusi il 2026-09-22 come versione finale. Il record del 12.9 resta come storico della bozza pipeline, ma non riflette più la caption reale: usare il record del 16.9 come riferimento di voce/stile per questo design.
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

### 2026-09-15 | Non ti manca la disciplina. Ti manca un posto dove tornare.
- Fonte: podcast ("19.9 pre-masterclass" episode script)
- Stile: unpopular_opinion
- Titolo design Canva: "HDH Settembre — Post 7 — Un posto dove tornare"
- Canva design ID: DAHUtRPmpG4
- Canva design URL: https://www.canva.com/d/_tZRBPPOq_qv1e0
- Cartella Canva: Social Media Automation / SETTEMBRE-2026 (FAHUsRMvNqA)
- Formato: carosello statico a 5 pagine (hook + 2 valore + chiusura + CTA masterclass; niente CTA podcast) — testo consegnato già scritto da Giusi, non generato da questa skill
- Sfondo: Background B (chioma di foresta nella nebbia, MAHUIYnuU7Y) su tutte le pagine, nessuna foto di Giusi (pattern landscape puro)
- CTA masterclass: header "MASTERCLASS LIVE / 24 SETTEMBRE" + parola-chiave **SETTEMBRE** ("Scrivi «SETTEMBRE» nei commenti e ricevi il link gratis") — la frase estesa della slide 5 originale ("Non un'altra lista. Non un altro metodo da provare e poi abbandonare...") non entra nel campo header/azione del template ed è stata condensata: Giusi può rivedere il wording direttamente in Canva
- Caption Instagram: aggiunta come commento nativo sul design Canva (thread KAHUtgraZ5s)
- Make webhook: not yet sent (no scenario built for this design)
- Stato: draft — testo e design completi, in attesa di revisione di Giusi
---

### 2026-09-17 | Non ti manca l'informazione. Ti manca una guida.
- Fonte: podcast ("26.9 post-masterclass" episode script)
- Stile: educational
- Titolo design Canva: "HDH Settembre — Post 8 — Non ti manca l'informazione"
- Canva design ID: DAHUtR4bWkM
- Canva design URL: https://www.canva.com/d/_ltk2MHid6JkTtc
- Cartella Canva: Social Media Automation / SETTEMBRE-2026 (FAHUsRMvNqA)
- Formato: carosello statico a 5 pagine (hook + 2 valore + chiusura + CTA masterclass; niente CTA podcast) — testo consegnato già scritto da Giusi, non generato da questa skill
- Sfondo: pattern foto-solo-su-hook-e-CTA — hook e CTA masterclass: Giusi che sorride mentre scrive sul suo journal (MAEUagStiCE, cartella "Casual Dez20 e Journal"); pagine centrali: Background A (campi verdi, cielo velato, MAEH0gshJfI)
- CTA masterclass: header "MASTERCLASS LIVE / 24 SETTEMBRE" + parola-chiave **SETTEMBRE** ("Scrivi «SETTEMBRE» nei commenti e ricevi il link gratis") — stessa nota di condensazione della slide 5 del Post 7
- Caption Instagram: aggiunta come commento nativo sul design Canva (thread KAHUtiwwBxQ)
- Facebook profilo / Facebook Gruppo Podcast / YouTube / Telegram: varianti già scritte da Giusi nel brief, non ancora caricate da nessuna parte (nessun campo dedicato sul design carosello) — restano da consegnare separatamente quando si programma il post
- Make webhook: not yet sent (no scenario built for this design)
- Stato: draft — testo e design completi, in attesa di revisione di Giusi
---

### 2026-09-19 | Quando decidiamo di prenderci più cura di noi... (Reel)
- Fonte: podcast ("Settembre - riparti con costanza") — plan tied this date's slot to the "19.9 pre-masterclass" episode subtitle "Come non perderti di nuovo" (see social_content_plan.toml), though the design that actually shipped this date carries a different subtitle/CTA (masterclass SETTEMBRE, not PODCAST as originally proposed there)
- Stile: n/d — non registrato in questa pipeline prima d'ora; identificato e collegato il 2026-09-22 a partire dalla caption reale fornita da Giusi
- Titolo design Canva: "La costanza - settembre 2026"
- Canva design ID: DAHVLbIEegY
- Canva design URL: https://www.canva.com/d/0NEdTcxstZ4Wz_a
- Cartella Canva: Social Media Automation (non verificata in questa sessione — design trovato via URL diretto, non tramite scansione cartella)
- Formato: carosello statico a 7 pagine
- CTA masterclass: parola-chiave **SETTEMBRE** — "Scrivi «SETTEMBRE» nei commenti e ricevi il link" — 24 settembre ore 21
- Approved record: approved/social/2026-09-19-la-giornata-ideale-non-esiste.md (.json) — caption reale allegata anche come commento Canva sul design (thread KAHV7eXh-Gw + KAHV7aHu29o)
- Make webhook: n/d — questo post è uscito su Instagram senza passare (per quanto risulta a questo repo) dal flusso schedule-social-post di qui
- Stato: **pubblicato** — confermato da Giusi il 2026-09-22 come design e caption finali realmente usciti il 19 settembre (Reel, https://www.instagram.com/reel/Ddbp69NEjff/)
---

### 2026-09-20 | Per molto tempo ho pensato che... non mi sarei più persa
- Fonte: podcast ("Settembre - riparti con costanza")
- Stile: n/d — non registrato in questa pipeline prima d'ora; identificato e collegato il 2026-09-22 a partire dalla caption reale fornita da Giusi
- Titolo design Canva: "Come non perderti di nuovo - carosello"
- Canva design ID: DAHVpwIbePY
- Canva design URL: https://www.canva.com/d/xuQuInoBYkZVA3I
- Cartella Canva: Social Media Automation (non verificata in questa sessione — design trovato via URL diretto, non tramite scansione cartella)
- Formato: carosello statico a 7 pagine
- CTA masterclass: parola-chiave **SETTEMBRE** — "Scrivi «SETTEMBRE» nei commenti e ricevi il link" — 24 settembre ore 21
- Approved record: approved/social/2026-09-20-non-mi-sarei-piu-persa.md (.json) — caption reale allegata anche come commento Canva sul design (thread KAHV7YIzBWI + KAHV7YvJofY)
- Make webhook: n/d — questo post è uscito su Instagram senza passare (per quanto risulta a questo repo) dal flusso schedule-social-post di qui
- Stato: **pubblicato** — confermato da Giusi il 2026-09-22 come design e caption finali realmente usciti il 20 settembre (post statico, https://www.instagram.com/p/DdebHNrgNl4/)
---

### 2026-09-22 | Perché non ti serve più forza di volontà
- Fonte: podcast, episodio "26.9 Perché non ti serve più forza di volontà" (in uscita 2026-09-26) — script completo letto da Google Drive (episodio non ancora ingerito da Castmagic al momento del run)
- Stile: personal_experience
- Titolo design Canva: "HDH Reel — Perché non ti serve più forza di volontà"
- Canva design ID: DAHV8RflVeA
- Canva design URL: https://www.canva.com/d/Td7vhIj0Y_2eV7F
- Cartella Canva: Social Media Automation / SETTEMBRE-2026 (FAHUsRMvNqA)
- Formato: reel
- hook_testo: "Perché non ti serve più forza di volontà" (senza il prefisso data "26.9" — tolto su richiesta esplicita di Giusi il 2026-09-22)
- quote_testo: "Per anni, quando qualcosa non funzionava, la risposta era sempre la stessa: devo fare di più. Più disciplina. Più organizzazione. Più forza di volontà. A un certo punto mi sono chiesta: 'E se invece rendessi più facile prendermi cura di me?'" — versione accorciata (font 48px) di un testo più lungo dettato da Giusi, per farlo entrare nel frame della quote card senza sovrapporsi alla foto
- cta_azione: Rispondi "PODCAST" per ricevere il link in DM (fissa per questo formato)
- Foto: Giusi_Journalsorriso_41.jpg (sfondo_hook + sfondo_cta), MediGiusi_54.jpg (sfondo_quote) — entrambe da "Giusi - Casual Dez20 e Journal"
- Caption reale allegata come commento Canva sul design (thread KAHV8QfYOsI + KAHV8UcV094)
- Nota: il gate automatico `social-critic` è stato rimosso da questa skill il 2026-09-22 (su richiesta di Giusi) perché applicava la rubrica del carosello a campi fissi per design (titolo verbatim, CTA fissa, niente hashtag) — vedi `.claude/skills/generate-social-reel/SKILL.md`. Revisione fatta da Giusi direttamente in chat.
- Make webhook: non ancora inviato (nessuno scenario reel costruito)
- Stato: draft — in attesa di revisione di Giusi su Canva e di impostare a mano timing/transizioni prima dell'export
---
