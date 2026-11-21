# A repo's journey: diagrams

Four diagrams showing how one repo moves from "we don't know what it does" to "tested to its target", and who does what.
They are drawn by GitHub from the text below (Mermaid), so they never go stale. Words follow [GLOSSARY.md](../../GLOSSARY.md);
the decisions behind them are in [decision-guides/](../../decision-guides/README.md).

## 1. The repo journey

```mermaid
flowchart LR
    subgraph D["Discovery"]
        C["Draft connection list<br/>(what it talks to)"]
        A["Approval tests<br/>(pin current behaviour)"]
        S["Source list<br/>(knowledge that counts)"]
    end
    D --> Q["Expert sessions<br/>(answer prepared questions)"]
    Q --> SP["Specification<br/>(intended behaviour)"]
    SP --> R["Required tests<br/>(per connection and per rule)"]
    C --> R
    R --> AI["AI drafts tests"]
    AI --> G["Acceptance check<br/>+ person reviews"]
    G --> M["Progress measured<br/>(required tests met, open questions,<br/>coverage, mutation results)"]
```

## 2. Two tracks, compared

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

## 3. Connection list to test types

```mermaid
flowchart LR
    CL["Connection list<br/>(one entry per connection)"] --> K{"Kind of connection"}
    K -->|in-house service| CT["Contract test<br/>(Pact, via the broker)"]
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
    AR["Architecture Owner"] -->|confirms| C["Connection list"]
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
