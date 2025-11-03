#import "@preview/touying:0.6.1": *
#import "themes/theme.typ": *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "utils.typ": *

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let pdfpc-config = pdfpc.config(
    duration-minutes: 30,
    start-time: datetime(hour: 14, minute: 10, second: 0),
    end-time: datetime(hour: 14, minute: 40, second: 0),
    last-minutes: 5,
    note-font-size: 12,
    disable-markdown: false,
    default-transition: (
      type: "push",
      duration-seconds: 2,
      angle: ltr,
      alignment: "vertical",
      direction: "inward",
    ),
  )

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    // handout: true,
    preamble: pdfpc-config,
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
  ),
  config-info(
    title: [Agentic AI],
    subtitle: [Componenti principali, MCP e agenti locali
     #image("images/disi.svg", width: 55%)],
    author: author_list(
      (
        (first_author("Gianluca Aguzzi"), "gianluca.aguzzi@unibo.it"),
      )
    ),
    date: datetime.today().display("20 Ottobre 2025"),
    institution: [Università di Bologna - DISI],
    //logo: align(right)[#image("images/disi.svg", width: 55%)],
  ),
)

#set text(font: "Fira Sans", weight: "regular", size: 20pt)

#set raw(tab-size: 4)
#show raw: set text(size: 1em)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: (x: 1em, y: 1em),
  radius: 0.7em,
  width: 100%,
)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)

// #set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// == Outline <touying:hidden>

== Sommario

#text(size: 1.3em)[
  #components.adaptive-columns(outline(title: none, indent: 1em, depth: 1))
]
#focus-slide[
  == Obiettivi
  #align(left)[
    - Componenti principali di un'agente di (generative) AI
    - Provider per usare modelli di linguaggio grandi (LLM)
    - MCP come mezzo per far interagire strumenti/servizi esterni con LLM
    - Esempi di agenti locali
  ]
]

= Introduzione agli agenti di AI

== Generative AI - Cosa abbiamo visto finora?
- Abbiamo visto il funzionamento base
  - Addestrati su grandi quantità di dati testuali
  - Preso del testo produce il prossimo token
  - Dimostrano capacità sorprendenti
- Modi d'uso
  - Abbiamo visto chatbot (come ChatGPT) e completamento di codice (come GitHub Copilot)
- Visto queste capacità, possono essere usati per fare cose più complesse?
  - Ad esempio, eseguire compiti che richiedono più passaggi di ragionamento
  - Oppure interagire con strumenti esterni (es. motori di ricerca, database, API)

== agente
- Un agente è un'entità autonoma che può percepire il suo ambiente e agire su di esso per raggiungere obiettivi specifici.
- Quello che abbiamo visto finora sono agenti?
  - In parte, sì!
  - Chatgpt usa il web per rispondere a domande su eventi recenti (ambiente)
  - GitHub Copilot interagisce con l'IDE e il codice esistente (ambiente)
- Ma possiamo fare di più?

== LLM - Quello che pesniamo che stia

== LLM - Agent 

== Agent - LLM
- *Noi* abbiamo usato gli LLM sempre come servizi interni
- Ma possono anche essere usati esternamente
- Via API (remota)
- Oppure localmente (scaricando il modello)

== Agent - Memoria/Contesto
- Gli agenti spesso hanno bisogno di memoria
- Per ricordare informazioni tra interazioni
- O per mantenere lo stato di un compito in corso
- La memoria può essere semplice (es. una lista di fatti)
- Oppure complessa (es. una base di conoscenza strutturata)

== Agent - Strumenti
- Gli agenti possono usare strumenti per estendere le loro capacità
- Strumenti possono essere:
  - Funzioni di calcolo (es. calcolatrice)
  - Accesso a database
  - Interfacce API a servizi esterni (es. motori di ricerca, social
- Un agente deve poter scegliere quando e come usare questi strumenti
in base al contesto e al compito richiesto

== Agent - Importanza del Open Source
- Molti agenti AI usano modelli proprietari (es. GPT-4)
- Ma c'è un crescente interesse per modelli open source
- Vantaggi:
  - Trasparenza
  - Personalizzazione
  - Controllo sui dati e sulla privacy
- Esempi di modelli open source:
  - LLaMA
  - Falcon
  - Mistral
- Come posso usare questi modelli?

= Generative AI - Provider

== Provider - Cosa sono?
- I provider sono interfacce che permettono di connettersi a modelli di
  linguaggio grandi (LLM)
- Ricordiamo che un modello non è altro che un isnieme di pesi e architetture
- I provider forniscono un modo standardizzato per interagire con diversi LLM
- Possono essere servizi cloud (es. OpenAI, Hugging Face) 
- Oppure modelli locali (es. LLaMA, Falcon)

== Ollama
- Ollama è una piattaforma per eseguire modelli di linguaggio grandi localmente
- Supporta modelli open source come LLaMA, Falcon, Mistral
- Fornisce un'interfaccia semplice per caricare e usare modelli
- Permette di eseguire modelli senza bisogno di una connessione internet
- Esempio di comando per eseguire un modello con Ollama:
= Agenti AI - Primo esempio

= MCP 

= Esempi di Workflow complessi

