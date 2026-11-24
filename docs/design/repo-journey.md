# A repo's journey: diagrams

Four diagrams showing how one repo moves from "we don't know what it does" to "tested to its target", and who does what.
They are drawn by GitHub from the text below (Mermaid), so they never go stale. Words follow [GLOSSARY.md](../../GLOSSARY.md);
the decisions behind them are in [decision-guides/](../../decision-guides/README.md).

## 1. The repo journey

Two tracks, joined at the testing plan; [the journey page](../JOURNEY.md) says who does each step and links every
decision guide, and [the drawing](repo-journey.excalidraw) names each step's skill.

```mermaid
flowchart TB
    subgraph SY["Syntactic track: can its tests run here, and can they be trusted?"]
        S1["Find what stops tests running<br/>(external systems, graded; meaningless and unreliable tests)"] --> S2["Measure<br/>(under the airgap agent, in stages)"]
        S2 --> S3["Repair<br/>(pair each test that reaches an external system)"] --> S4["Measure again"]
    end
    subgraph SE["Semantic track: what does the code do, and what should it do?"]
        E1["Find the sources<br/>of intended behaviour"] --> E2["Capture current behaviour<br/>(approval tests at the edges)"]
        E2 --> E3["Elicit intended behaviour<br/>(requirements from cited sources)"] --> E4["Design tests<br/>from the requirements"]
    end
    G{{"Safety inventory<br/>(the gate before anything runs)"}}
    S1 -.-> G
    E1 -.-> G
    G -.-> S2
    G -.-> E2
    S4 --> P["Testing plan"]
    E4 --> P
    P --> W["The work"] --> K["Keep it there"]
```

## 2. Current and intended behaviour, compared

```mermaid
flowchart TB
    CUR["Current behaviour<br/>approval tests"] --> CMP{"Same?"}
    INT["Intended behaviour<br/>specification"] --> CMP
    CMP -->|yes| TRUST["Trusted regression test,<br/>explained by its rule"]
    CMP -->|no| OQ["Open question"]
    OQ --> AO["Application Owner decides"]
    AO -->|keep current behaviour| KEEP["Test stays pinned;<br/>known issue recorded"]
    AO -->|fix it| FIX["Test changes deliberately,<br/>with expert sign-off"]
    AO -->|specification was wrong| SPEC["Specification corrected"]
```

## 3. External systems list to test types

```mermaid
flowchart LR
    CL["External systems list<br/>(one entry per external system)"] --> K{"Kind of external system"}
    K -->|in-house service| CT["Contract test<br/>(Pact; pacts shared through the package repository)"]
    K -->|outside service| RR["Recorded responses or contract<br/>(WireMock)"]
    K -->|database or queue| CO["Container test<br/>(Testcontainers; CI if no local runtime)"]
    K -->|no image, no test instance| FK["Fake behind an interface<br/>(local tests)"]
    CL --> NR["Never-reach addresses<br/>(production)"]
    NR --> STOP["Tests stop at once if configured<br/>with one; unknown outbound calls flagged"]
```

## 4. Who does what

```mermaid
flowchart TB
    KC["Knowledge Curator"] -->|chooses sources| S["Source list"]
    AR["Architecture Owner"] -->|confirms| C["External systems list"]
    FDE["Forward Deployed Engineer<br/>+ AI assistant"] -->|runs discovery, drafts rules and tests| W["Repo work"]
    SME["Subject-matter expert"] -->|answers questions| SP["Specification"]
    APO["Application Owner"] -->|settles open questions,<br/>approves plans| P["Testing plan"]
    TQL["Test Quality Lead"] -->|sets standards and checks| G["Acceptance check"]
    S --> W
    C --> W
    SP --> W
    P --> W
    W --> G
```
