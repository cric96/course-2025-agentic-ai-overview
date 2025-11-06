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

= Introduzione AI Agents

== Generative AI - Cosa abbiamo visto finora?
#note-block[Large Language Models (LLM)][
  - Modelli di linguaggio addestrati su *grandi* quantità di dati testuali
  - Modello di funzionamento semplice: _preso del testo produce il prossimo token_
  - Dimostrano capacità sorprendenti in vari compiti linguistici
]
#note-block[Applicazioni viste finora][
  - Chatbot (es. ChatGPT)
  - Completamento di codice (es. GitHub Copilot)
]
- È possibile costruire applicazioni più complesse combinando LLM con altri componenti?

== Verso il concetto di Agente

#definition-block[Agente][
  Un agente è un'entità #underline[autonoma] che può percepire il suo *ambiente* e #underline[agire] su di esso per raggiungere #underline[obiettivi specifici].  
]
- Le applicazioni di generative AI viste finora sono agenti?
  - *In parte sì!*
  - ChatGPT usa il web per rispondere a domande su eventi recenti (ambiente)
  - GitHub Copilot interagisce con l'IDE e il codice esistente (ambiente)


== Appliicazioni generative AI - Come le abbiamo viste finora ...

#align(center)[
  #image("images/agente-semplice.png", width: 80%)
]

== ... Come sono in realtà
#align(center)[
  #image("images/agente-complesso.png", width: 80%)
]

== Componenti Principali - LLM Provider
#grid(
  columns: 2,
  gutter: 2em,
  [
    #image("images/services.png", width: 80%)
  ],
  [
    - Un #strong[agente AI] è un esecutore #underline[autonomo] di compiti che utilizza #strong[modelli di linguaggio grandi] (LLM)
    - I #strong[provider] permettono di connettersi a diversi LLM (#emph[OpenAI], #emph[Hugging Face], #emph[modelli locali])
    - Forniscono un'interfaccia #underline[standardizzata] per interagire con gli LLM  
      - Tipicamente via #strong[REST API]
      - Permettono di #underline[astrarre] le differenze tra i vari LLM
  ]
)


== Componenti Principali - Strumenti
#grid(
  columns: 2,
  gutter: 2em,
  [
    - Gli agenti possono usare #strong[strumenti] per #underline[estendere le loro capacità]
    - Gli strumenti sono #strong[elementi esterni] che l'agente può #underline[invocare] per ottenere informazioni o eseguire azioni
    - #emph[Esempi di strumenti]:
      - #strong[Funzioni di calcolo] (es. calcolatrice)
      - #strong[Accesso a database]
      - #strong[Interfacce API] a servizi esterni (es. motori di ricerca)
  ],
  [
    // Immagine placeholder, da sostituire
    #align(center)[
      #image("images/mcp.png", width: 50%)
    ]
  ]
)

#grid(
  columns: 2,
  gutter: 2em,
  [
    #align(center)[
      #image("images/tool-idea.png", width: 100%)
    ]
  ],
  [
    == Strumenti - Come funzionano?
    - Gli LLM generano *solo* testo
    - Il testo può essere interpretato come #strong[comandi] da eseguire
    - #strong[Flusso]:
      + LLM riceve istruzioni su strumenti disponibili nel contesto
      + LLM genera comando per invocare lo strumento
      + Interprete esegue il comando
      + Risultato ritorna all'LLM
    - Lo approfondiremo tra poco :)
  ]
)

== Componenti Principali - Memoria
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Memoria a breve termine]
    - Mantiene lo stato del compito #underline[corrente]
    - #emph[Esempio]: conversazione attuale in un chatbot
    - Implementazione: lista di fatti, buffer temporaneo
  ],
  [
    #strong[Memoria a lungo termine]
    - Persiste informazioni tra #underline[sessioni diverse]
    - #emph[Esempio]: preferenze utente, cronologia
    - Implementazione: database, sistemi di archiviazione
  ]
)

== Posso crearmi un agente AI?
- Inizialmente, gli strumenti AI erano principalmente:
  - Modelli LLM closed-source (es. GPT-3, GPT-4)
  - Servizi cloud proprietari (es. OpenAI, Claude)
- Oggi è possibile creare agenti AI #underline[localmente] grazie a:
  - Modelli open weight/source (LLaMA, Mistral, Qwen)
  - Strumenti per esecuzione locale (#emph[Ollama], #emph[LM Studio])
  - Framework di sviluppo (#emph[LangChain], #emph[LangGraph])
  - Interfacce web self-hosted (#emph[Open WebUI])

== Strumenti per Agenti AI Locali
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Runtime e Model Serving]
    - #emph[Ollama]: esecuzione semplificata di modelli LLM locali
    - #emph[LM Studio]: interfaccia grafica per gestire e testare modelli
    - Supportano API compatibili con OpenAI
  ],
  [
    #strong[Framework e Interfacce]
    - #emph[LangChain/LangGraph]: framework per costruire agenti con controllo granulare
    - #emph[Open WebUI]: interfaccia web self-hosted con supporto RAG, tools e MCP
  ]
)

== Open Weight vs Open Source
- Quando si parla dei *modelli* è importante distinguere:
  - #strong[Open Weight]: pesi accessibili, codice non necessariamente aperto (es. LLaMA 3, Qwen)
  - #strong[Open Source]: codice e pesi completamente aperti (es. Mistral, Falcon)
  - #strong[Closed Source]: proprietari, solo via API (es. GPT-4, Claude)
- #strong[Approccio ibrido]: si possono combinare modelli closed-source (via API) con infrastruttura e tools open source

= Generative AI - Provider

== Provider - Cosa sono?
- I provider sono #strong[interfacce di astrazione] che permettono di connettersi a modelli di linguaggio grandi (LLM)
- Ricordiamo: un modello è composto da #strong[pesi] (parametri appresi) e #strong[architettura] (struttura della rete neurale)
- I provider forniscono un modo #underline[standardizzato] per interagire con diversi LLM
  - Nascondono le differenze implementative tra modelli
  - Unificano API eterogenee sotto un'interfaccia comune
- Possono essere servizi cloud (es. OpenAI, Anthropic, Hugging Face) 
- Oppure runtime locali (es. Ollama, LM Studio, vLLM)

== Provider - Architettura
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Componenti chiave]
    - #strong[Client]: interfaccia per inviare richieste
    - #strong[API Gateway]: gestisce autenticazione e rate limiting
    - #strong[Model Server]: carica ed esegue il modello
    - #strong[Inference Engine]: ottimizza l'esecuzione (quantizzazione, batching)
  ],
  [
    #strong[Standardizzazione]
    - La maggior parte segue il formato #emph[OpenAI Chat Completions API]
    - Consente di #underline[cambiare provider] senza modificare il codice client
    - Parametri comuni: `temperature`, `max_tokens`, `top_p`
  ]
)

== Provider Cloud vs Locali
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Provider Cloud]
    - #emph[Pro]: scalabilità, modelli all'avanguardia, manutenzione zero
    - #emph[Contro]: costo per token, latenza di rete, privacy dei dati
    - Esempi: OpenAI (GPT-4), Anthropic (Claude), Google (Gemini)
  ],
  [
    #strong[Provider Locali]
    - #emph[Pro]: privacy totale, nessun costo ricorrente, controllo completo
    - #emph[Contro]: richiede hardware adeguato, setup iniziale, aggiornamenti manuali
    - Esempi: Ollama, LM Studio, vLLM
  ]
)

== Ollama - Panoramica
- Ollama è un #strong[runtime ottimizzato] per eseguire LLM localmente
- Caratteristiche principali:
  - #strong[Quantizzazione automatica]: riduce requisiti memoria (es. da FP16 a Q4)
  - #strong[Context window management]: gestione efficiente della memoria contestuale
  - #strong[Multi-model serving]: più modelli caricabili simultaneamente
  - #strong[API compatibile OpenAI]: drop-in replacement per applicazioni esistenti

== Ollama - Architettura Interna
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Componenti]
    - #strong[GGUF/GGML]: formato di serializzazione modelli
    - #strong[llama.cpp]: engine di inferenza in C++
    - #strong[Model Registry]: repository modelli (pull/push)
    - #strong[HTTP Server]: espone API REST
  ],
  [
    #strong[Ottimizzazioni]
    - #emph[GPU acceleration]: CUDA, Metal, ROCm
    - #emph[Memory mapping]: carica solo parti necessarie
    - #emph[KV cache]: riutilizza computazioni precedenti
    - #emph[Batching]: processa più richieste insieme
  ]
)

== Ollama - Modelli Supportati
- Link: https://ollama.com/models

- #strong[Famiglia LLaMA]: LLaMA 2/3/3.1/3.2 (7B-405B parametri)
- #strong[Mistral]: Mistral 7B, Mixtral 8x7B (Mixture of Experts)
- #strong[Qwen]: Qwen2 0.5B-72B (multilingua, coding)
- #strong[Phi]: Microsoft Phi-3 (modelli compatti 3B-14B)
- #strong[Gemma]: Google Gemma 2B-27B
- Ogni modello disponibile in #underline[varianti quantizzate]: Q4, Q5, Q8, FP16

== Ollama - Quantizzazione
#definition-block[Quantizzazione][
  Processo di riduzione della precisione numerica dei pesi del modello (es. da 16-bit float a 4-bit int) per ridurre memoria e aumentare velocità, con minima perdita di qualità.
]
- #strong[Q4_K_M]: 4-bit, bilanciamento qualità/performance (default)
- #strong[Q8_0]: 8-bit, qualità quasi originale, +100% memoria
- Trade-off: modello più piccolo = inferenza più veloce ma risposte meno accurate

== Requisiti di Memoria - Calcolo Approssimativo
#align(center)[
  #strong[Formula base]: #text(fill: rgb("#1e40af"))[Memoria (GB) ≈ Parametri × Bit per peso / 8 × 10⁹]

  #table(
    columns: 5,
    [*Modello*], [*Parametri*], [*FP16 (16-bit)*], [*Q8 (8-bit)*], [*Q4 (4-bit)*],
    [Phi-3], [3.8B], [~7.6 GB], [~3.8 GB], [~1.9 GB],
    [LLaMA 3.2], [7B], [~14 GB], [~7 GB], [~3.5 GB],
    [Mistral], [7B], [~14 GB], [~7 GB], [~3.5 GB],
    [LLaMA 3.1], [13B], [~26 GB], [~13 GB], [~6.5 GB],
    [Qwen 2.5], [32B], [~64 GB], [~32 GB], [~16 GB],
    [LLaMA 3.1], [70B], [~140 GB], [~70 GB], [~35 GB],
  )

]

== Requisiti Hardware - Linee Guida
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Modelli Small (3B-7B)]
    - #emph[CPU only]: 16 GB RAM, ~5-15 token/s
    - #emph[GPU consumer]: GTX 1660 (6GB), ~30-50 token/s
    - #emph[GPU mid-range]: RTX 3060 (12GB), ~60-80 token/s
    - #emph[Uso]: laptop, desktop consumer
  ],
  [
    #strong[Modelli Medium (13B-34B)]
    - #emph[CPU only]: 32+ GB RAM, ~2-5 token/s
    - #emph[GPU enthusiast]: RTX 4070 Ti (12GB), ~20-40 token/s
    - #emph[GPU workstation]: RTX 4090 (24GB), ~50-80 token/s
    - #emph[Uso]: workstation, server entry
  ]
)

#text(size: 0.8em)[
  #strong[Modelli Large (70B+)]: Richiedono GPU server (A100 80GB, H100) o multi-GPU setup
]

/*
== Performance: CPU vs GPU
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Inferenza CPU]
    - #emph[Velocità]: 5-20 token/s (modelli Q4 7B)
    - #emph[Pro]: accessibile, nessun driver speciale
    - #emph[Contro]: lento per modelli >13B
    - #emph[Ottimizzazioni]: AVX2/AVX512, multi-threading
    - #emph[Scenario]: prototipazione, batch offline
  ],
  [
    #strong[Inferenza GPU]
    - #emph[Velocità]: 30-200+ token/s (stesso modello)
    - #emph[Pro]: #strong[10-40x più veloce], gestisce modelli grandi
    - #emph[Contro]: costo hardware, limitazione VRAM
    - #emph[Ottimizzazioni]: CUDA cores, tensor cores
    - #emph[Scenario]: produzione, real-time, UI interattive
  ]
)
*/
== Performance: Fattori Critici
#strong[Throughput dipende da]:
- #strong[Context length]: più lungo = più lento (crescita quadratica per attention)
- #strong[Batch size]: più richieste parallele = migliore utilizzo GPU
- #strong[Quantizzazione]: Q4 è 2-3x più veloce di FP16 (ma meno preciso)
- #strong[Hardware specifico]:
  - CPU: cache L3, frequenza, core count
  - GPU: VRAM, bandwidth memoria, compute capability

#text(size: 0.9em)[
  #strong[Esempio pratico]: LLaMA 3.2 7B-Q4
  - Intel i7-12700K (CPU): ~8-12 token/s
  - RTX 4070 12GB (GPU): ~80-100 token/s
  - #text(fill: rgb("#059669"))[Speedup: ~10x]
]

== Ollama - Comandi Pratici
```bash
# Eseguire un modello (download automatico se necessario)
ollama run llama3.2:3b

# Listare modelli installati localmente
ollama list

# Scaricare un modello senza eseguirlo
ollama pull qwen2.5:7b-instruct-q4_K_M

# Rimuovere un modello
ollama rm mistral:7b

# Avviare server API (porta 11434)
ollama serve
```

== Ollama - Esempio API
```python
import requests

# Chiamata API compatibile OpenAI
response = requests.post(
    "http://localhost:11434/v1/chat/completions",
    json={
        "model": "llama3.2:3b",
        "messages": [
            {"role": "system", "content": "Sei un assistente esperto."},
            {"role": "user", "content": "Spiega la quantizzazione."}
        ],
        "temperature": 0.7,
        "max_tokens": 500
    }
)
print(response.json()["choices"][0]["message"]["content"])
```

== Ollama - Modelfile Personalizzati
```dockerfile
# Modelfile: configura comportamento modello
FROM llama3.2:3b

# System prompt personalizzato
SYSTEM """Sei un assistente che risponde sempre in italiano 
e usa un tono formale."""

# Parametri di inferenza
PARAMETER temperature 0.8
PARAMETER top_p 0.9
PARAMETER num_ctx 4096  # Context window

# Creare modello custom
# ollama create assistente-italiano -f Modelfile
```

== Ollama vs Alternativi
#table(
  columns: 4,
  [*Tool*], [*Pro*], [*Contro*], [*Uso ideale*],
  [Ollama], [CLI semplice, API standard], [Meno UI, config limitata], [Sviluppo, CI/CD],
  [LM Studio], [GUI completa, comparazione modelli], [Solo desktop], [Sperimentazione],
  [vLLM], [Performance massima, batching], [Setup complesso], [Production, high-load],
  [llama.cpp], [Massimo controllo], [Basso livello, C++], [Embedding custom],
)
= Agenti AI - Primo esempio

= MCP 

= Esempi di Workflow complessi

