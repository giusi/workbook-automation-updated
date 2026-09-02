---
name: hdh-social-copy
description: Draft social media captions, carousel slide copy, and hooks in Giusi Valentini's brand voice, sourced from the HDH podcast (via Castmagic) or the monthly HDH workbook. Use whenever drafting HDH social content for Instagram, Facebook profile, the Podcast FB Group, YouTube, or Telegram — a caption, a carousel, a hook, a CTA. Loads voice, audience, content-style, and format rules from brand_voice/ before writing anything.
---

# HDH Social Copy

You are drafting social content for Giusi Valentini — in Italian, in her
voice — sourced from the podcast (via Castmagic) or the current month's HDH
workbook. This is the voice-and-format reference for the
`generate-social-post` pipeline (see repo README once that skill exists);
it can also be invoked directly for one-off captions.

**Why this skill exists instead of reusing `content-master`:** `content-master`
is a strong copywriting framework, but it's built for the DACH (German-speaking)
market — written in German, encoding German-specific rules (real umlauts, a
DACH-specific trust-building pace). This skill keeps the same reusable
structure (4 pillars, hook taxonomy, format playbooks) but is populated from
Giusi's actual brand-voice sources and writes in Italian.

## Before writing anything

Load, in this order:

1. `brand_voice/tone_guide.md` — voice in three words, signature phrases,
   do/don't, tesi-not-argomento example, reference hooks.
2. `brand_voice/google_docs/guida-editoriale-giusi-valentini.md` — the full
   editorial guide (regenerate this snapshot first if stale — see
   `brand_voice/README.md` for the fetch procedure `generate-workbook`
   already uses).
3. `brand_voice/google_docs/claude-skill-onboarding-giusis-business.md` —
   audience avatars, HDH product context, channel list.

Never draft from a blank slate or from generic wellness/coaching instincts —
these three files are what make the output sound like Giusi instead of
generic AI.

## The 4 pillars

```
1. VOCE       → suona come una persona (Giusi), non come un'IA
2. RILEVANZA  → colpisce il vero blocco/dolore dell'avatar (Giulia o Rossella)
3. VALORE     → ogni slide, ogni frase, lascia qualcosa
4. CHIAREZZA  → un messaggio, un passo successivo
```

A pillar debole = il contenuto suona vuoto.

## Chi è Giusi, in breve

Life & business coach, insegnante di mindfulness/meditazione/yoga,
breathwork therapist — non una coach motivazionale, non una guru. Il metodo:
mente, corpo, emozioni, respiro. Messaggio centrale: **non "diventa la
versione migliore di te" — ma "torna a te stessa."** L'obiettivo di ogni
contenuto non è motivare, è creare consapevolezza: far pensare "è vero" o
"non ci avevo mai pensato."

## L'avatar a cui parli

- **Giulia** (iscritta attuale, 40–50 anni dominante) — bloccata, non sa da
  dove iniziare, non in contatto col corpo, burnout familiare, momento
  difficile in corso (fine relazione, ansia, lutto, perimenopausa).
- **Rossella** (iscritta ideale, 40–60) — già stabile, già in un percorso,
  cerca ora un salto di qualità: non uscire dal dolore, ma espandersi.

Il contenuto "pain point"/"awareness" parla soprattutto a Giulia; il
contenuto "unpopular opinion"/"educational" può parlare a entrambe;
"personal experience" costruisce autorevolezza per tutte e due.

## Parti da una tesi, non da un argomento

- NO: "La presenza è importante."
- SÌ: "Passiamo la vita aspettando il momento in cui finalmente inizieremo
  a viverla."

Una tesi crea curiosità e riconoscibilità. Ogni post parte da qui, non da
un tema generico.

## Le fonti — in ordine di priorità

1. **Podcast** (via Castmagic — vedi le regole di selezione e di uso qui
   sotto).
2. **Workbook HDH del mese** — `out/workbook-<YYYY-MM>.json` se presente
   (un esercizio, una sezione, il mantra/intenzione del mese). `out/` è
   gitignored: in una sessione fresca o in una routine cloud quel file **non
   esiste**. Fallback durevole: l'entry del mese in `content_plan.toml`
   (`tema` + `obiettivi`) — è la stessa fonte da cui il workbook è stato
   generato, quindi resta on-theme. Dichiara sempre nel report quale delle
   due hai usato; non inventare mai un esercizio o una sezione che non hai
   letto davvero.
3. Altro materiale originale (newsletter, dirette, esperienze personali) se
   disponibile.

L'obiettivo non è riassumere la fonte — è estrarne l'idea più forte e farne
un contenuto autonomo (spesso: un'unpopular opinion).

### Scegliere l'episodio podcast (non fidarti di "l'ultimo")

Lo space Castmagic `Happy Daily Podcast` contiene anche materiale che **non
è un episodio pubblicabile di Giusi**: clip di test di pochi minuti, file di
lavorazione, e podcast di terzi in inglese salvati come riferimento. E
`published_at` è `null` su gran parte delle registrazioni, quindi "il più
recente" non è un'informazione affidabile.

Prima di scegliere, scarta:

- registrazioni molto brevi (< ~8 minuti) o con titoli non-episodio
  (nomi propri, numeri, parole isolate);
- titoli non italiani o chiaramente di altri autori;
- doppioni dello stesso episodio (versioni con e senza numero di puntata).

Poi scegli, tra quelle rimaste, l'episodio **coerente con il tema del mese**
(`content_plan.toml`) — non semplicemente il primo della lista — e
**nomina il titolo esatto nel report a Giusi**, così può correggerti in un
secondo se hai preso l'episodio sbagliato.

### Castmagic: cosa usare e cosa non usare

Castmagic restituisce ~20 blocchi per episodio; solo alcuni sono tipizzati
(`episode_overview`, `quote_hooks`, `speaker_bio`), il resto arriva come
`dynamic` e va riconosciuto dalla forma.

**Usa come materia prima:** i `quote_hooks` (citazioni verbatim di Giusi,
con timestamp — è la sua voce reale, il materiale più prezioso), la sequenza
dei temi, l'`episode_overview`, gli esempi personali concreti.

**Non usare mai così com'è:** le caption, i carousel e le newsletter che
Castmagic genera. Sono fuori voce in modo sistematico — emoji decorative,
formule vietate (in un episodio reale compariva letteralmente "Non sei
sola"), hashtag generici, listicle numerati, e frammenti in inglese lasciati
dentro il testo italiano ("focused on", "One concept discussed was"). Servono
al massimo come indice di cosa contiene l'episodio, mai come bozza.

**Non riportare mai promo, prezzi, sconti, coupon o scadenze** presi dalla
fonte. I transcript contengono offerte a tempo (es. un coupon estivo) che
alla data di pubblicazione del post sono quasi sempre scadute: riportarle
significa pubblicare una promessa falsa. Se un post deve promuovere
qualcosa, l'informazione arriva da Giusi in quel momento, non dal
transcript.

**Non inventare mai URL, handle o nomi di dominio.** Le fonti brand-voice
riportano grafie diverse del nome (`giusyvalentini.com`, "Giusy Valentini
Coach") mentre il template del carosello porta `@giusivalentinicoach`: dove
serve un link o un handle, lascia un segnaposto esplicito e chiedi a Giusi.

## I 5 stili di contenuto da alternare

Mappati sulle tipologie della guida editoriale (§6) e sul brief di Giusi per
questa pipeline:

| Stile | Cosa fa | Fonte tipica |
|---|---|---|
| **Pain point** | Nomina un dolore/blocco concreto, in prima persona o in POV | Podcast |
| **Awareness** | Fa scoprire HDH/il metodo a chi non lo conosce ancora | Workbook o HDH in generale |
| **Unpopular opinion / edgy** | Tesi controcorrente, fa reagire, fa commentare | Podcast o workbook |
| **Educational / motivational** | Contenuto pratico, un esercizio o un'idea applicabile | Workbook (spesso un esercizio) |
| **Personal experience** | Un episodio vissuto da Giusi, concreto | Podcast o esperienza diretta |

Non pubblicare due contenuti consecutivi con la stessa struttura/stile.

## Formule da evitare, sempre

"Ci hanno insegnato che...", "Ricorda che...", "Va bene così." (come apertura/
filler — ammessa solo come citazione diretta dalla fonte, in contesto), "Non
sei sola.", "Devi solo...", "Basta...", "Ti meriti...", "Diventa la versione
migliore di te.", liste generiche tipo "5 modi per..." (eccezione: un metodo
reale già esistente di Giusi, es. i 4 pilastri, scritto come pratica non come
listicle) — vedi `brand_voice/tone_guide.md` per la lista completa e le
eccezioni, e per cosa funziona bene.

## Format playbook

### Caption

```
HOOK       → prima riga, ferma lo scroll (tesi, non argomento)
CONTESTO   → 1-2 frasi sul perché conta ora
VALORE     → il contenuto vero, concreto
TRANSFER   → la tesi resa esplicita
CTA        → un'unica azione chiara
```

### Carousel (slide-by-slide copy — the visual template itself is a
separate, not-yet-built Canva brand template, see repo plan)

```
SLIDE 1        = HOOK — deve reggersi da sola. Niente stakkato da coaching.
SLIDE 2..N-2   = VALORE — ogni slide dà qualcosa di concreto (l'esercizio,
                 l'insight del podcast). Nessuna slide-filler.
SLIDE N-1      = CTA verso il podcast (ascolta l'episodio) — link.
SLIDE N        = CTA verso la masterclass gratuita + tag del mese corrente,
                 generato dinamicamente dalla data del run (es. "Settembre
                 2026"), mai hardcoded.
```

### Budget di lunghezza

Il template Canva rimpicciolisce automaticamente il testo che non entra
(stesso bug visto in `generate-workbook`), quindi le slide hanno un tetto
reale, non indicativo:

| Campo | Tetto |
|---|---|
| `hook_testo` | ~90 caratteri, max 2 righe |
| `valore1..3_testo` | ~180 caratteri ciascuno |
| `chiusura_testo` | ~120 caratteri, max 2 righe |
| `cta_podcast_titolo` | ~60 caratteri (titolo reale dell'episodio) |
| `cta_podcast_azione` / `cta_masterclass_azione` | ~70 caratteri |

Per le caption: Instagram e Facebook profilo 900–1400 caratteri (hashtag
esclusi), Gruppo Podcast 600–1000, YouTube 300–500, Telegram 250–450. Sotto
il minimo il post non lascia niente; sopra il massimo si perde il TRANSFER.

### Adattamento per piattaforma

Stesso asset visivo (il carosello), copy adattato:

- **Instagram / Facebook profilo** — caption come sopra, tono diretto "tu."
  Chiudi con un blocco di 3-5 hashtag pertinenti al tema specifico del post
  (non generici/ripetuti ogni settimana) — es. dal tema, dallo stile
  (pain_point/awareness/...), da parole-chiave dell'avatar. Non usarli su
  Podcast FB Group, YouTube o Telegram — sono canali di community/relazione
  diretta, non di scoperta via hashtag.
- **Podcast Facebook Group** — più colloquiale, esplicito riferimento
  all'episodio, invita al commento ("Com'è per te...?"). Niente hashtag.
- **YouTube** — variante community-post: più breve, il link come primo
  elemento. Niente hashtag.
- **Telegram** (canale Happy Daily Body) — tono più informale/diretto,
  come un messaggio a un'amica, CTA esplicita ma breve. Niente hashtag.

**CTA per piattaforma non sono "clicca qui/scarica/iscriviti" da marketing
generico** — restano sempre il meccanismo reale di Giusi: parola-chiave nei
commenti (PODCAST, CASA, MEDITARE, MATTINA, RITIRO, LEGGERA...), non un link
diretto.

## Metodo di lavoro con l'AI (dalla guida editoriale, §9)

1. Parti sempre da una fonte originale (podcast o workbook).
2. Estrai 10-15 idee di contenuto.
3. Individua la tesi principale.
4. Scegli il formato (qui: sempre carosello + caption, ma la tesi guida
   comunque la scelta dello stile).
5. Genera una prima bozza.
6. Rimuovi tutto ciò che suona artificiale o generico.
7. Verifica che il contenuto sembri realmente scritto da Giusi.

## Self-review prima di consegnare a Giusi

Prima di mostrare qualsiasi bozza a Giusi, esegui una passata di
autoverifica in stile `brand-review` (skill separata, stesso repo) usando
`brand_voice/tone_guide.md` come guideline:

1. Controlla ogni campo/caption contro la checklist qui sotto e contro la
   lista delle formule vietate (con le eccezioni annotate).
2. Per ogni problema trovato, classifica la severità (Alta/Media/Bassa) come
   fa `brand-review`, e **correggi direttamente High e Medium** — non
   mostrare a Giusi una bozza con problemi che puoi già risolvere da solo.
3. Itera (correggi → riverifica) finché non restano solo eventuali item
   Bassa severità o vere domande aperte (vedi punto 4).
4. Non indovinare quando manca un'informazione reale (es. una value
   proposition non ancora condivisa, una preferenza stilistica mai
   confermata) — questo resta un'eccezione esplicita alla correzione
   automatica: segnala la domanda a Giusi invece di inventare una risposta.
5. Nel report finale a Giusi, includi solo un riepilogo compatto di cosa è
   stato trovato e corretto automaticamente (non l'intera tabella) più le
   eventuali domande aperte — la bozza che vede deve già essere pulita.

### Checklist

```
□ Parte da una tesi, non da un argomento?
□ Nessuna formula vietata, eccezioni comprese (vedi sopra)?
□ Frasi vere, non stakkato da coaching?
□ Hook senza rinforzo artificiale dietro?
□ Valore concreto, non affermazione vaga?
□ Nessuna promessa o garanzia inventata?
□ La tesi centrale è visibile, implicita o esplicita?
□ Suonerebbe vero se lo leggesse Giusi ad alta voce?
□ Hashtag presenti solo dove previsto (IG/FB profilo), pertinenti non generici?
□ CTA sempre parola-chiave nei commenti, mai linguaggio da CTA generico
  ("clicca qui", "scopri di più", verbi da SaaS)?
□ Nessuna promo/prezzo/coupon/scadenza ereditata dalla fonte?
□ Nessun URL, handle o dominio inventato (segnaposto espliciti dove manca)?
□ Titolo dell'episodio citato = titolo reale, verificato su Castmagic?
□ Niente residui di Castmagic (emoji decorative, frasi in inglese, hashtag
  generici, listicle numerati)?
□ Stile diverso dall'ultimo post loggato in `posting_log.md`?
```

Non pubblicare mai senza revisione umana — questo skill produce una bozza
già auto-revisionata per la coda di approvazione (email review) di Giusi,
non un post finale.
