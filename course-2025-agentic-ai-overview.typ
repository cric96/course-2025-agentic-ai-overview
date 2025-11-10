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
  titlefmt: strong,
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
      ),
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

  *code*: #link("https://github.com/cric96/code-2025-agentic-ai")
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

= Introduzione agli Agenti AI

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
  Un agente è un'entità #underline[autonoma] che può percepire il suo *ambiente* e capace di #underline[agire] su di esso per raggiungere #underline[obiettivi specifici].
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
  #image("images/agente-complesso.jpg", width: 50%)
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
  ],
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
  ],
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
  ],
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
  ],
)

== Agenti AI Locali - Panoramica
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
  ],
)

== Open Weight vs Open Source
#grid(
  columns: 2,
  gutter: 2em,
  [
    - Quando si parla dei *modelli* è importante distinguere:
      - #strong[Open Weight]: pesi accessibili, codice non necessariamente aperto (es. LLaMA 3, Qwen)
      - #strong[Open Source]: codice e pesi completamente aperti (es. Mistral, Falcon)
      - #strong[Closed Source]: proprietari, solo via API (es. GPT-4, Claude)
      - #strong[Approccio ibrido]: si possono combinare modelli closed-source (via API) con infrastruttura e tools open source
  ],
  [
    #align(right)[#image("images/oss.png", width: 100%)]
  ],
)

== Perché open weight / open source è importante?
- #strong[Trasparenza]
  - Codice e pesi verificabili per analisi di bias, sicurezza e limiti.
- #strong[Privacy & controllo]
  - Esecuzione locale/privata: dati sotto controllo (es. GDPR).
- #strong[Flessibilità]
  - Fine-tuning, quantizzazione e integrazione personalizzata.
- #strong[Indipendenza & costi]
  - Riduce vendor lock-in; permette ottimizzazioni costo/prestazioni.
- #strong[Ecosistema e responsabilità]
  - Comunità e risorse condivise; però maggiore onere operativo (manutenzione, sicurezza, responsabilità legale).

= Provider Generative AI

== Provider - Cosa sono?
#grid(
  columns: 2,
  gutter: 2em,
  [
    #align(center)[
      #image("images/overview-provider.png", width: 80%)
    ]
  ],
  [
    - I provider sono #strong[interfacce di astrazione] che unificano l'accesso ai LLM: standardizzano le API e nascondono differenze implementative.
    - Ricordiamo: un modello = #strong[pesi] + #strong[architettura] + #strong[runtime].
    - Tipi: servizi cloud (OpenAI, Anthropic, Hugging Face) o runtime locali (Ollama, LM Studio, vLLM).
  ],
)

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
  ],
)

== Provider Cloud vs Locali
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Provider Cloud]
    - #emph[Pro]: scalabilità, modelli all'avanguardia,  zero manutenzione
    - #emph[Contro]: costo per token, latenza di rete, privacy dei dati
    - Esempi: OpenAI (GPT-4), Anthropic (Claude), Google (Gemini)
  ],
  [
    #strong[Provider Locali]
    - #emph[Pro]: privacy totale, nessun costo ricorrente, controllo completo
    - #emph[Contro]: richiede hardware adeguato, setup iniziale, aggiornamenti manuali
    - Esempi: Ollama, LM Studio, vLLM
  ],
)

== Ollama - Panoramica
#align(center)[
  #image("images/ollama.png", width: 20%)
]
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
  ],
)

== Ollama - Modelli Supportati
- Link: https://ollama.com/models

- #strong[Famiglia LLaMA]: LLaMA 2/3/3.1/3.2 (7B-405B parametri)
- #strong[Mistral]: Mistral 7B, Mixtral 8x7B (Mixture of Experts)
- #strong[Qwen]: Qwen2 0.5B-72B (multilingua, coding)
- #strong[Phi]: Microsoft Phi-3 (modelli compatti 3B-14B)
- #strong[Gemma]: Google Gemma 2B-27B
- Ogni modello disponibile in #underline[varianti quantizzate]: Q4, Q8, FP16

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
  ],
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
- #strong[Quantizzazione]: Q4 è 2-3x più veloce di FP16 (ma meno preciso)
- #strong[Hardware specifico]:
  - CPU: cache L3, frequenza, core count
  - GPU: VRAM, bandwidth memoria, compute capability

#text(size: 0.9em)[
  #strong[Esempio pratico]: LLaMA 3.2 7B-Q4
  - Intel i7-12700K (CPU): ~8-12 token/s
  - RTX 4070 12GB (GPU): ~80-100 token/s
]

== Ollama - Comandi Pratici
Installazione sia Nativa che via Docker: https://ollama.com/download

Alcuni comandi utili:
```bash
# Esegue un modello (download automatico se necessario)
ollama run llama3.2:3b

# Elenca i modelli installati localmente
ollama list

# Scarica un modello senza eseguirlo
ollama pull gemma3:270m

# Avvia il server API (porta 11434)
ollama serve
```

== Ollama - Esempio API (via Python)
```python
import ollama

ollama.generate("gemma3:270m", "Ciao, come stai?")
```

O direttamente via OpenAI API (standard corrente de facto):
```python
from openai import OpenAI
client = OpenAI(
    base_url="http://localhost:11434/v1",
    api_key="none" # Ollama non richiede API key
)
client.completions.create(model="gemma3:270m", prompt="Ciao, come stai?").choices[0].text
```
= Interfacce Uomo - Macchina per Agenti AI
== Interazione via Agenti AI
- Il focus principale di questo corso sono agenti *conversazionali* che interagiscono con utenti umani
  - Possono avere dell'autonomia (lo vedremo dopo)
  - Ma necessitano *sempre* di un input dall'umano (e feedback) per funzionare
  #align(center)[
    #image("images/chatbot.jpg", width: 40%)
  ]
== Interfacce Standard per Agenti
- Le interfacce ormai sono abbastanza standardizzate:
  - #strong[Input testuale]: l'utente fornisce istruzioni/domande
  - #strong[Output testuale]: l'agente risponde con testo generato
  - #strong[Strumenti integrati]: l'agente può usare strumenti (RAG, calcolatrice, API esterne)

Due approcci principali:
- #emph[Web UI]: interfaccia web accessibile che ha accesso ai modelli locali
  - Esempio: Open WebUI
- #emph[Servizi ad-hoc]: applicazioni dedicate per prototipare agenti specifici in maniera visuale
  - Esempio: LM Studio, Comfy UI

#text(size: 0.9em)[
  #emph[Nota]: Tutto è possibile farlo anche via codice usando framework come LangChain/LangGraph
]
== OpenWebUI - Panoramica
#align(center)[
  #image("images/openwebui.png", width: 15%)
]
#feature-block("Open WebUI", icon: fa-globe() + " ")[
  _Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate *entirely offline*. It supports various LLM runners like Ollama and OpenAI-compatible APIs, with a built-in inference engine for RAG, making it a powerful AI deployment solution._
]


== Interfacce Utente - Panoramica

#align(center)[
  #image("images/openwebui-overview.png")
]

== OpenWebUI - Installazione
- Si può utilizzare OpenWebUI localmente usando Docker:
```bash
docker run -d --network=host -v ./.open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```
- Alcune note:
  - `-d` fa girare il container in background
  - `--network=host` permette di esporre le porte direttamente sulla macchina host
  - `-v ...` monta una cartella (persistenza tra sessioni)
  - `--restart always` fa partire il container automaticamente al riavvio del sistema
- Oppure installandolo usando `pip`
```bash
pip install open-webui
open-webui serve
```
== OpenWebUI - Paradigma di Utilizzo
- OpenWebUI funziona come un'interfaccia web self-hosted per interagire con modelli LLM locali o remoti
- #strong[Due tipologie di utenti]:
  - #emph[Amministratori]: configurano modelli, strumenti e impostazioni globali
  - #emph[Utenti finali]: interagiscono con l'interfaccia per eseguire agenti AI
- #strong[Casi d'uso principali]:
  - #strong[Chatbot aziendale]: deploy per dipendenti con accesso controllato
    - Integrazione RAG per interrogare documenti interni
    - Privacy: dati rimangono on-premise

== OpenWebUI - Configurazione Modelli
- OpenWebUI supporta vari provider LLM:
  - #emph[Ollama]: modelli locali (LLaMA, Mistral, Qwen)
  - Qualsiasi endpoint #strong[OpenAI-compatible]
- #strong[Configurazione (via admin panel)]:
  + Accedi a `http://localhost:8080/admin`
  + Vai su #emph[Connections] → #emph[Ollama API] → #emph[Add Connection]
  + Inserisci nome e URL endpoint (es. `http://localhost:11434/v1`)
  + Per provider OpenAI: stesso processo, aggiungi API key se richiesta

== OpenWebUI - Workspace
- Simile al concetto di GPTs su ChatGPT, OpenWebUI permette di creare #strong[workspaces] personalizzati per diversi scenari d'uso
- #strong[Componenti configurabili]:
  - #emph[Modelli]: selezione LLM con system prompt, parametri e features specifiche
  - #emph[Knowledge base]: documenti e dati per RAG (Retrieval-Augmented Generation)
  - #emph[Prompts]: template predefiniti per scenari comuni (es. coding assistant, customer support)
  - #emph[Tools]: strumenti integrati per estendere le capacità dell'agente (approfondiremo dopo)
- Ogni workspace può essere #underline[condiviso] tra utenti o mantenuto privato

== LM Studio - Panoramica
#align(center)[
  #image("images/lmstudio.png")
]
- LM Studio è un'interfaccia grafica per gestire ed eseguire modelli
- Caratteristiche principali:
  - #strong[Interfaccia user-friendly]: gestione modelli, test, monitoraggio
  - #strong[Supporto multi-modello]: carica ed esegui più modelli simultaneamente
  - #strong[API compatibile OpenAI]: integrazione con applicazioni esistenti
  - #strong[Strumenti integrati]: RAG, agenti, strumenti personalizzati

== Interfaccia Utente - Panoramica
#align(center)[
  #image("images/lmstudio-overview.png", width: 80%)
]

== LM Studio - Configurazione Modelli
- LM Studio è un #strong[provider LLM locale] con interfaccia grafica integrata per gestire modelli
- Supporta #underline[runtime multipli] (CUDA, Metal, CPU) e esecuzione simultanea di più modelli
- Offre #strong[estensibilità] tramite tools e plugin per ampliare le capacità degli agenti AI
- Permette #emph[configurazione avanzata]: quantizzazione, context length, temperatura, GPU layers

== LM Studio vs OpenWebUI - Confronto
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[LM Studio]
    - #emph[Applicazione desktop] per uso personale
    - Interfaccia grafica intuitiva
    - Testing e configurazione rapida modelli
    - Ideale per #underline[sperimentazione individuale]
  ],
  [
    #strong[OpenWebUI]
    - #emph[Piattaforma web] self-hosted
    - Multi-utente con workspaces collaborativi
    - RAG integrato e deploy scalabile
    - Ideale per #underline[team e produzione]
  ]
)

== Creasi il proprio Agente via Programmazione - LanghChain
#align(center)[
  #image("images/langchain-overview.png", width: 40%)
]
- #strong[LangChain]: framework open-source per applicazioni AI con LLM
- Permette di creare agenti che:
  - Interagiscono con modelli LLM
  - Usano strumenti esterni (API, database)
  - Gestiscono memoria a breve/lungo termine
- #strong[Caratteristiche]: modularità, integrazione facile con provider LLM, estensibilità

== LangChain - Creazione di un Agente Semplice
```python
from langchain.agents import create_agent
from langchain_openai import ChatOpenAI
model = ChatOpenAI( # ollama
    model="qwen/qwen3-vl-4b",
    base_url="http://127.0.0.1:1234/v1",
    api_key="none"
)
agent = create_agent(
    model=model
)
agent.invoke({
  "messages": [
    {"role": "user", "content": "Ciao, come stai?"}
  ]
})
```
= Strumenti e MCP

== Strumenti per Agenti AI
#grid(
  columns: (1.9fr, 0.5fr),
  gutter: 2em,
  [
    - Gli agenti devono poter interagire con #strong[strumenti esterni] per eseguire compiti specifici oltre le capacità del solo LLM
      - In base all'#underline[obiettivo], l'agente seleziona autonomamente quali strumenti utilizzare
    - Analogia umana: dato un goal, scegliamo gli strumenti più adatti per raggiungerlo
      - #emph[Esempio]: per appendere un quadro → martello, chiodi, livella, metro
    - #strong[Perché servono strumenti?]
      - LLM generano solo testo, non possono eseguire calcoli complessi, accedere a dati real-time o interagire con sistemi esterni
      - Gli strumenti colmano questo gap, estendendo le capacità dell'agente
  ],
  [
    #align(center)[
      #image("images/tools.png", width: 100%)
    ]
  ],
)

== Anatomia di uno strumento
- #strong[Strumento]: componente esterno che un agente può invocare per ottenere informazioni o eseguire azioni specifiche
- #strong[Componenti chiave]:
  - #emph[Interfaccia]: come l'agente comunica con lo strumento
    - Sinomimo umano: pulsanti di un attrezzo
  - #emph[Funzionalità]: cosa lo strumento può fare
  - #emph[Descrizione]: spiegazione dettagliata di come utilizzare lo strumento
    - Sinonimo umano: manuale d'uso
- Queste componenti permettono all'agente di capire quando e come usare lo strumento per raggiungere i suoi obiettivi

== Uso di uno strumento via LLM, idea generale:
    #strong[Flusso di esecuzione]:
    + Avrà una #underline[istruzione generale] su come usarli (come parte del system prompt)
    + LLM riceve nel contesto la #underline[lista di strumenti disponibili] (nome, descrizione, interfaccia), ancora come parte del system prompt
    + Dato l'input utente e il goal, l'LLM #strong[decide autonomamente] se usare uno strumento
    + Se necessario, genera un #emph[comando strutturato] per invocare lo strumento (seguendo l'interfaccia dichiarata)
    + Un #strong[interprete] (orchestratore) esegue il comando e ritorna il risultato all'LLM
    + L'LLM integra il risultato nel contesto e #underline[formula la risposta finale]

== Possibile esempio di Prompt
#set text(18pt)
```text
System Prompt:
You are an AI agent that can use the following tools to assist users:
Tools:
1. Get Current Time
   - Description: Returns the current time in HH:MM:SS format.
   - Interface: get_current_time() -> str
2. Get Current Date
   - Description: Returns the current date in YYYY-MM-DD format.
   - Interface: get_current_date() -> str

When given a user request, decide if you need to use a tool. If so, generate a command in the format:
<tool_name>()
following the tool's Interface (e.g., get_current_time(), or get_current_date()).

If you use a tool, respond with ONLY the tool call in the exact format specified.
If you don't need a tool, respond normally to the user.
```

#focus-slide[
  == Demo su LangChain
  Creazione di un agente con strumenti personalizzati
]

== LangChain - Esempio di agente con strumenti

- In #strong[LangChain], puoi #underline[creare agenti AI] che usano #strong[strumenti personalizzati] per estendere le loro capacità
- Un #strong[tool] in LangChain è una funzione annotata e documentata che l'agente può #underline[invocare autonomamente]:
```python
from langchain.tools import tool
from datetime import datetime

@tool
def get_current_time() -> str:
    """
    Ritorna l'ora corrente nel formato HH:MM:SS
    """
    return datetime.now().strftime("%H:%M:%S")
```


== LanghChain - Agenti con Strumenti
- Una volta definiti gli strumenti, si possono passare all'agente durante la creazione
```python
from langchain.agents import create_agent
agent = create_agent(
    model=model,
    tools=[get_current_time]
)
```
- L'agente ora può decidere autonomamente quando invocare `get_current_time()`
- Simulerà il flusso descritto prima:
  - Riceve input utente
  - Decide se usare lo strumento
  - Genera il comando
  - L'interprete esegue il comando e ritorna il risultato
  - L'agente formula la risposta finale

== Strumenti - Il Problema dell'Interoperabilità
#grid(
  columns: (0.7fr, 1.3fr),
  gutter: 2em,
  [
    #image("images/interoperability-issue.png", width: 100%)
  ],
  [
    - Ogni framework AI aveva il suo modo di definire strumenti:
      - LangChain usava decoratori Python
      - OpenAI richiedeva JSON Schema specifico
      - Altri framework avevano formati proprietari
    - #strong[Risultato]: stesso strumento, implementazioni diverse per ogni piattaforma!
    - #strong[Conseguenze]:
      - Strumenti non riutilizzabili tra progetti
      - Duplicazione di codice e sforzi
      - Difficoltà a mantenere consistenza
  ],
)

#focus-slide[
  == Soluzione: MCP - Model Context Protocol
  Lo standard per l'integrazione AI
  
  #image("images/mcp-view.png", width: 90%)
]

== MCP - Il Problema della Torre di Babele

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Analogia con il Web]
    - Prima di REST API: ogni sito web con protocolli diversi
    - Con REST: un'unica interfaccia standard per tutti i servizi web
    - Per l'AI serve lo stesso approccio → #strong[MCP]
    - Con MCP: un'unica interfaccia standard per strumenti AI
  ],
  [
    #align(center)[
      #image("images/with-mcp-without.png", width: 100%)
    ]
  ],
)




== MCP - Cos'è?
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Model Context Protocol (MCP)]
    - Standard #underline[aperto] sviluppato da Anthropic
    - Permette di #underline[connettere AI a strumenti e dati]
    - Come REST API per il web, #underline[MCP per l'AI]
    
    #strong[Benefici immediati]
    - Uno strumento MCP #underline[non dipende da chatbot specifici]
    - #underline[Ecosistema condiviso] di strumenti riusabili
    - #underline[Riduce complessità] di integrazione
  ],
  [
    #align(center)[
      #image("images/mcp.png", width: 70%)
    ]
  ],
)

== MCP - Architettura: i 3 Attori Principali
#align(center)[
  #image("images/host-client-server.png", width: 80%)
]

== MCP - Architettura: i 3 Attori Principali
#grid(
  columns: 3,
  gutter: 1.5em,
  [
    #strong[1. Host]
    - L'applicazione che usi (VS Code, Claude Desktop)
    - Gestisce l'interfaccia utente
    - #emph[Esempio]: il tuo editor di codice
  ],
  [
    #strong[2. Client]
    - "Interprete" che traduce richieste le tra host e server
    - 1 client per ogni server
    - Trasparente (non lo vedi)
    - #emph[Gestito automaticamente dall'host]
  ],
  [
    #strong[3. Server]
    - Fornisce gli strumenti veri e propri
    - Es: accesso file, database, API
    - Può essere locale (stdio) o remoto (streamable http)
    - #emph[Esempio]: server filesystem MCP
  ],
)

== MCP - Come Funziona in Pratica
#strong[Scenario]: Vuoi che l'AI legga un file e ti faccia un riassunto
#image("images/flusso.png", width: 100%)


== Output Strutturato - Cosa Significa?
#strong[Gli strumenti MCP usano #emph[JSON Schema] per definire input e output]

#definition-block[Output Strutturato][
  Un formato predefinito e validabile che descrive esattamente quali dati vengono restituiti da uno strumento, permettendo all'AI di sapere cosa aspettarsi.
]

#strong[Perché è importante?]
- L'AI sa esattamente cosa riceverà
- Evita errori di parsing
- Permette validazione automatica
- Facilita il debugging

== Esempio di Output Strutturato
#strong[Caso d'uso]: Strumento per ottenere l'ora corrente

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Definizione dello strumento]
    ```json
    {
      "name": "get_time",
      "description": "Restituisce l'ora corrente",
      "inputSchema": {
        "type": "object",
        "properties": {}
      }
    }
    ```
  ],
  [
    #strong[Schema dell'output]
    ```json
    {
      "type": "object",
      "properties": {
        "result": {
          "title": "Result",
          "type": "string"
        }
      },
      "required": ["result"],
      "title": "get_timeOutput"
    }
    ```
  ],
)

#strong[Output effettivo]: `{"result": "14:30:45"}`

== MCP - I Tre Building Blocks

#table(
  columns: (auto, 1.2fr, 1fr, auto),
  [*Feature*], [*Cosa fa*], [*Esempi*], [*Chi decide*],
  [*Tools*], [Azioni che l'AI può eseguire. Modificano lo stato (es. chiamano API)], [Cerca voli, Invia email, Crea eventi], [AI Model],
  [*Resources*], [Dati che l'AI può leggere per capire il contesto (read-only)], [File, Calendari, Documenti, Schema DB], [Application],
  [*Prompts*], [Template predefiniti che guidano l'AI su come combinare tools e resources], [Pianifica vacanza, Riassumi meeting], [Utente],
)

== MCP Tools - Come Funzionano
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Ciclo di vita di un tool]
    1. #emph[Discovery]: AI scopre tool disponibili (`tools/list`)
    2. #emph[Decision]: AI decide se usare il tool
    3. #emph[Invocation]: AI genera comando strutturato (`tools/call`)
    4. #emph[Approval] (opzionale): utente conferma l'esecuzione
    5. #emph[Execution]: tool viene eseguito
    6. #emph[Response]: risultato torna all'AI in formato strutturato
    
    #strong[Input/Output]
    - Definiti tramite #underline[JSON Schema]
    - AI sa esattamente cosa inviare e ricevere
  ],
  [
    #align(center)[
      #image("images/interaction-mcp.png")
    ]
  ],
)


== MCP - Dettagli Tecnici

#strong[Architettura Client-Host-Server]
- Host crea e gestisce client multipli (1 client = 1 server)
- Protocollo basato su #emph[JSON-RPC 2.0] (messaggi codificati in UTF-8)
- Due transport standard: #underline[stdio] (subprocess) e #underline[HTTP Streamable] (servizi remoti)

#strong[Lifecycle in 3 fasi]
1. #emph[Initialization]: negoziazione versione protocollo e capacità
2. #emph[Operation]: scambio messaggi secondo capacità negoziate
3. #emph[Shutdown]: terminazione graceful della connessione

#strong[Principi di design]
- Server facili da costruire (host gestisce complessità)
- Alta componibilità (server multipli si combinano facilmente)
- Isolamento e sicurezza (server riceve solo il contesto necessario)

== MCP Transport - Due Modalità

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[stdio] (processi locali)
    - Client lancia server come sotto processo
    - Comunicazione via stdin/stdout
    - Semplice e diretto (uno a uno)
    - #emph[Uso]: server locali, strumenti filesystem
  ],
  [
    #strong[HTTP Streamable] (servizi remoti)
    - Server indipendente con endpoint HTTP
    - POST per inviare, GET+SSE per ricevere (opzionalmente)
    - Supporta connessioni multiple 
    - #emph[Uso]: API remote, servizi cloud
  ],
)
#align(center)[
  #image("images/mcp-stdio-streamable.png", width: 40%)
]



== MCP - Ecosistema e Adozione
#strong[Chi usa MCP oggi?]
- #emph[Host Applications]: Claude Desktop, VS Code, Zed, Sourcegraph Cody
- #emph[Server Ufficiali]: Filesystem, Git, PostgreSQL, Slack, Google Drive, Sentry
- #emph[Community]: 100+ server open-source disponibili
- Docker Hub: server MCP pronti all'uso → https://hub.docker.com/r/mcpservers

#align(center)[
  #image("images/mcp-servers-docker.png", width: 45%)
]


== MCP - Ricapitolando
#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Cosa abbiamo imparato]
    - MCP è uno #underline[standard aperto] per strumenti AI
    - Risolve il problema di #emph[interoperabilità]
    - Architettura: Host → Client → Server
    - 3 componenti: Tools, Resources, Prompts
    - Output strutturato tramite JSON Schema
    
  ],
  [
    #strong[Perché è importante]
    - Riduce complessità di sviluppo
    - Ecosistema condiviso e riusabile
    - Strumenti funzionano su più piattaforme
    - Futuro degli agenti AI componibili
    
    #emph[Riferimenti]:
    - Specifica completa: `modelcontextprotocol.io`
  ],
)


== MCP - Esempio Pratico: Creare un Server
#strong[Server MCP in Python con FastMCP]

```python
from datetime import datetime, timezone
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("Time")

@mcp.tool()
async def get_time(timezone: str = "local") -> str:
    """Get current time: 'local' (default) or 'UTC'."""
    tz = timezone.strip().lower()
    now = datetime.now(timezone.utc) if tz == "utc" else datetime.now()
    return now.isoformat(sep=" ", timespec="seconds")

mcp.run(transport="streamable-http")

```

== MCP Client - MCP Inspector
#align(center)[
  #image("images/mcp-inspector-example.png", width: 100%)
]

== Docker MCP Servers
- #strong[Implementare] un server MCP da zero può essere #underline[complesso]
- #strong[Fortunatamente], esistono #underline[molti server MCP open-source] pronti all'uso su Docker
#align(center)[
  #image("images/docker-desktop.png", width: 70%)
]


== MCP Gateway - Il Problema della Frammentazione

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Scenario reale]
    - Un'applicazione AI può usare #underline[decine di server MCP]:
      - Filesystem per leggere documenti
      - Database per query SQL
      - API esterne (meteo, email, calendario)
      - Servizi aziendali interni
    
    #strong[Senza Gateway]
    - Host deve gestire #emph[N client] separati
    - Configurazione complessa e ripetitiva
    - Difficile manutenzione e debugging
  ],
  [
    #strong[Soluzione: MCP Gateway]
    - #underline[Un'unica interfaccia] verso l'host
    - Gateway come #emph[proxy intelligente]
    - Smista le richieste ai server corretti
    - Gestione centralizzata di:
      - Autenticazione
      - Rate limiting
      - Logging e monitoring
      - Failover e retry logic
  ],
)

== MCP Gateway - Architettura
#align(center)[
  #image("images/mcp-gateway-docker.png", width: 100%)
]

== MCP Gateway via Docker - Setup Rapido

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Avvio del Gateway]
    ```bash
    docker mcp run gateway
    ```
    
    #strong[Cosa fa questo comando?]
    - Avvia un container Docker con il Gateway MCP
    - Espone un #underline[singolo endpoint] che aggrega tutti i server MCP
    - Pronto all'uso senza configurazione complessa
  ],
  [
    #strong[Opzioni di configurazione]
    - #emph[Transport]: scegli `stdio` o `http-streamable`
      ```bash
      docker mcp run gateway --transport http
      ```
    - #emph[Server selettivi]: includi solo alcuni server
      ```bash
      docker mcp run gateway \
        --servers filesystem,postgres
      ```
   
  ],
)

#focus-slide[
  == Demo
  Mostriamo come usare un MCP Gateway con OpenWebUI e LM Studio (e LangChain)
]

== MCP - Ricapitolando

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Punti chiave appresi]
    - MCP #underline[standardizza] l'integrazione di strumenti AI
    - Architettura #emph[Host-Client-Server] componibile
    - #strong[3 building blocks]: Tools, Resources, Prompts
    - Ecosistema in rapida crescita (100+ server)
    - #strong[Gateway] unifica più server in un'unica interfaccia
    
    #strong[Vantaggi pratici]
    - Strumenti #underline[riusabili] tra piattaforme diverse
    - Riduzione della complessità di integrazione
    - Deploy semplificato (Docker, HTTP, stdio)
  ],
  [
    #strong[Applicazioni reali]
    - VS Code, Claude Desktop (host)
    - Filesystem, Database, API (server)
    - OpenWebUI, LM Studio (integrazione)
    
  ],
)

== MCP - Argomenti Avanzati (Non Trattati)

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Sicurezza e Governance]
    - #emph[Sandboxing]: isolamento esecuzione tools
    - #emph[Autorizzazioni]: controllo accesso granulare
    - #emph[Audit logging]: tracciabilità completa
    - #emph[Rate limiting]: prevenzione abusi
    - #emph[Secrets management]: gestione credenziali sicura
  ],
  [
    #strong[Sviluppo Avanzato]
    - #emph[Host personalizzati]: creare proprie applicazioni MCP
    - #emph[Resources]: esporre dati dinamici read-only
    - #emph[Prompts]: template riusabili per workflow
  ],
)


= Prospettive Future

== Sistemi Multi-Agente?
#definition-block[Sistema Multi-Agente (MAS)][
  Sistema con #underline[molteplici agenti autonomi] che collaborano per obiettivi complessi impossibili per un singolo agente.
]

#grid(
  columns: 2,
  gutter: 2em,
  [
    #strong[Limiti del singolo agente]
    - Difficoltà con task multi-step
    - Mancanza di specializzazione
    - Single point of failure
    - Scalabilità limitata
  ],
  [
    #strong[Vantaggi MAS]
    - #emph[Specializzazione]: domini specifici
    - #emph[Robustezza]: no single point of failure
    - #emph[Scalabilità]: aggiungere/rimuovere agenti
    - #emph[Tracciabilità]: workflow trasparenti
  ],
)

== Pattern e Framework MAS

#strong[Pattern di collaborazione]
#align(center)[
  #image("images/architecture.png")
]

== Pattern e Framework MAS

#grid(
  columns: 4,
  gutter: 1.5em,
  [
    #strong[Router Agent]
    - Un agente centrale smista task a specialisti
    - Esecuzione uno-a-uno sequenziale
  ],
  [
    #strong[Parallel]
    - Task distribuiti a più agenti contemporaneamente
    - Risultati aggregati
  ],
  [
    #strong[Sequential / Circular]
    - Pipeline predefinita A → B → C
    - Workflow ciclici possibili
  ],
  [
    #strong[Dynamic]
    - Agenti comunicano liberamente
    - Rete all-to-all adattiva
  ],
)

#strong[Framework principali (2025)]
- #emph[LangGraph]: low-level, controllo granulare su grafi di esecuzione
- #emph[CrewAI]: high-level, role-based con task automation
- #emph[AutoGen]: conversazionale, enterprise-ready multi-agent
- #emph[N8n AI]: integrazione con workflow no-code N8N

= Conclusioni

== Ricapitolando

- Gli #strong[agenti AI] sono sistemi che combinano #underline[LLM], #underline[strumenti esterni], e #underline[memoria] per eseguire compiti complessi
- I #strong[provider] (cloud o locali) permettono di accedere a diversi LLM in modo standardizzato
- #strong[MCP] risolve il problema dell'interoperabilità tra strumenti AI attraverso un protocollo standard aperto
- Gli #strong[agenti locali] (Ollama, OpenWebUI, LM Studio) abilitano deployment privati e controllati

== Prospettive Future

#grid(
columns: 2,
gutter: 2em,
[
  #strong[Sistemi Multi-Agente]
  - Orchestrazione complessa di agenti specializzati
  - Pattern emergenti: router, parallel, dynamic
  - Framework: LangGraph, CrewAI, AutoGen
],
[
  #strong[Standardizzazione Ecosistema]
  - Protocolli universali (A2A, ACP)
  - Marketplace di agenti riusabili
  - Interoperabilità cross-platform
],
)

#grid(
columns: 2,
gutter: 2em,
[
  #strong[Agentic RAG & Deep Research]
  - Retrieval con reasoning avanzato
  - Sintesi multi-sorgente automatica
  - Collaborative research agents
],
[
  #strong[Computer Use Agents (CUA)]
  - Controllo diretto GUI e applicazioni
  - Automazione workflow end-to-end
  - Interazione cross-application facilitata
],
)

== Punti Aperti

#strong[Sfide Tecniche]
- #emph[Scalabilità]: gestione efficiente di migliaia di agenti concorrenti
- #emph[Coordinazione]: meccanismi di comunicazione e sincronizzazione tra agenti
- #emph[Osservabilità]: debugging e monitoring di sistemi multi-agente distribuiti

#strong[Governance e Sicurezza]
- #emph[Sandboxing]: isolamento esecuzione per prevenire comportamenti malevoli
- #emph[Rate limiting]: prevenzione abusi e controllo costi
- #emph[Audit trails]: tracciabilità decisioni e azioni degli agenti

#strong[Ricerca e Sviluppo]
- #emph[Emergent behavior]: comprensione dinamiche collettive non previste
- #emph[Human-in-the-loop]: quando e come integrare supervisione umana
- #emph[Benchmark standardizzati]: metriche condivise per valutare agenti