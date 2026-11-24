# Glossary and word list

**Status: agreed.** Propose changes by editing this file in a pull request. Check new documents against it.

## Rules for words

1. **Use common English in its everyday sense.** Don't give an ordinary word a special meaning (no "ladder", "track", "wave").
2. **Industry-standard technique and tool names are allowed** (mutation testing, contract testing, Testcontainers), but each one must be explained in plain words the first time it appears in a document.
3. **No letter or number codes.** Write "fix flaky tests" or "the database is hard to replace", never a short code for them. Machine files use descriptive keys, not codes.
4. **Spell out abbreviations** the first time: subject-matter expert (SME), not just SME.
5. **One word per idea.** If two things share a word (for example "tier" meant both application importance and test type), rename one of them.
6. **Names say what something is or does.** A file, decision or task name should make sense to a newcomer.
7. **Refer to things by name, with a link.** Never by a code or number, in documents or in chat.
8. **No organisation-specific details in this repo.** Name a product only as an option or an example; an organisation's own facts and choices live in its private organisation repo.

## Words we use

| Word or phrase | Meaning | Replaces (don't use) |
|---|---|---|
| **test maturity level** (0 to 5) | How far a repo has got with testing, from "it builds" to "it is checked in production". Each level has a name, below. Based on the industry idea of a maturity model (as in TMMi). | ladder, rung, testing pyramid (that means the mix of unit / integration / end-to-end tests) |
| Level 0: **builds reliably** | A fresh copy builds the same way every time, with only approved package sources reachable. |  |
| Level 1: **runs on its own** | The app starts and its tests run in CI without reaching any real external system. | runs isolated |
| Level 2: **current behaviour recorded** | Tests capture what the system does today at its edges (API calls, messages, files), so changes are noticed. | characterisation, golden master, pinned |
| Level 3: **checked against requirements** | Tests check what the system *should* do, as confirmed by someone who knows the business rules. | checked against intent |
| Level 4: **tests proven to catch bugs** | Deliberately introduced bugs are caught by the tests (measured by mutation testing). |  |
| Level 5: **checked in production** | Automated checks confirm key user journeys work after each release. | verified in production |
| **business criticality** (high / medium / low) | How important an application is to the business. Sets its target test maturity level. | tier, tier 1/2/3 |
| **local tests** | Tests that run anywhere, including a developer machine with no container runtime. | local tier |
| **container tests** | Tests that need a container runtime (real databases, message brokers). They run wherever a runtime exists, such as CI, and on developer machines that have one. They skip themselves, with a clear message, where there is no runtime. | container tier, integrationTest tier, CI-only tests |
| **technology stack** | The framework, runtime and language a codebase uses, e.g. "EJB on WebSphere", "Spring Boot 3", "Angular", "Node". Decides *which test tools* to use. Detected from build files. | archetype (in part) |
| **application type** | What a codebase does: web service, batch job, message consumer, web UI, back-end-for-front-end, shared library. Decides *where the edges are, what to record, and the target test mix*. Detected from code and configuration. Not to be confused with *an application* (the business system a repo belongs to). | archetype (in part), cluster |
| (stack, type) pair | How a repo is described: one or more pairs, e.g. "Spring Boot 3 + message consumer" and "Angular + web UI". |  |
| **testing guide** (technology stack testing guide / application type testing guide) | The default testing approach for one technology stack or one application type, worked out on a pilot app. A repo's plan combines the guides for each of its pairs. | playbook, archetype playbook |
| **pilot application** | One real application per common (technology stack, application type) pair, treated by hand first so what we learn becomes the testing guide. | reference app, exemplar |
| **shared test kit** | A reusable package that lets any repo test against a shared dependency (a database, a queue, an internal API) without touching the real one. Has a version for local tests and one for CI-only tests. | enabler |
| **test stand-in approach** | How tests will stand in for one external system a repo depends on: run it in a container, use recorded responses, agree a contract, put a fake behind an interface, use a shared test environment for now, or accept the risk. | disposition |
| **workstream** (names below; always use the full name) | A group of testing work for a repo, with its own issues and finish condition. Done roughly in this order; some overlap. |  |
| – make it run on its own | Get the app building and starting without real external systems. |  |
| – fix flaky tests | Make tests pass or fail consistently. |  |
| – record current behaviour | Add tests that capture what the system does today. |  |
| – make code testable | Change code so its dependencies can be replaced in tests. | seams |
| – test against requirements | Add tests for the business rules experts confirm. | specification tests |
| – strengthen tests | Use mutation testing to find and fix weak tests. | mutation hardening |
| – check in production | Add automated post-release checks. |  |
| **replaceable dependency** | Code that receives its database, clock, HTTP client etc. from outside, so a test can pass in a stand-in. | seam |
| **obstacle** (named) | Something that makes a repo hard to test, e.g. "uses the system clock directly", "needs a real Oracle database". | blocker |
| **expected-results source** | Where we get the right answer for a test: an expert, a spec, or the old system. | oracle |
| **external system** | A database, service, mail server, directory, file share or queue a test reaches off the machine it runs on. A test that reaches one is tagged `external` and left out of normal runs. | shared system |
| **high-risk files** | Files that change often *and* are complex: the top 10% by both. | hotspots |
| **outbound network calls** | Connections a test makes to other systems. | egress |
| **measurement run** | The automated run that builds a repo and runs its tests in stages, each gating the next: once, then repeated in varied orders for flaky tests, then with planted bugs; it measures coverage and test strength. | probe, dynamic probe |
| **assessment file** | `testing/assessment.yaml` in each repo: measured results plus decisions people have made. | record, assessment record |
| **batch** (of repos) | The set of repos being worked on together this quarter, chosen within one part of the organisation. | wave |
| **the organisation** / **its repos** | The organisation using the toolkit, and the repositories in scope. | estate |
| **summary by organisation unit** | Results grouped up the five levels of the organisation chart. | roll-up |
| **key user journey** | A business process that must work end to end, such as "post a payment". | critical journey |
| **acceptance check** | The automatic checks an AI-written test must pass before it is kept. | gate, ttGate |
| **done by** (a tool / AI / a person) | Who carries out a task. |  |
| **AI-written** (test, plan, change) | Drafted by an AI assistant. Always passes automated checks before it is kept. Name a specific product only when a product-specific file or feature is meant. | Copilot-written, Copilot-generated |
| **AI assistant** | Whichever AI tool the organisation approves (listed in its organisation profile). | a product name (except when naming the product) |
| **AI coding assistance** | A person works with an AI assistant in their editor or terminal. The person directs it, reviews everything it produces, and owns the result. **This is how the programme works today.** | agentic, autonomous |
| **independent AI agent** | An AI that works unattended, for example by being assigned work items and opening pull requests on its own. **A future direction only**, after approval, vetting and testing. | AI coding agent, Copilot coding agent (when meaning unattended work) |

## Engagement roles

The programme runs as a forward deployed engagement (see [The programme runs as a forward deployed engagement with named roles](decision-guides/0001-the-programme-runs-as-a-forward-deployed-engagement-with-named-roles.md) and [references](docs/REFERENCES.md#engagement-model)). These roles replace the names of any client's internal bodies.

| Role | Side | What they do | What they decide |
|---|---|---|---|
| **Programme Sponsor** | Client | Owns the outcome and the funding | Scope, sign-off of targets, escalations, moving between phases (through the Steering Group) |
| **Engagement Lead** | Delivery | Runs the plan and the order of work, and reports to the sponsor | Rollout batches and pilots (with the sponsor), how results are recorded, the order of work |
| **Forward Deployed Engineer** | Delivery | Builds the toolkit and does the work inside client repos, with AI coding assistance | How things are built day to day |
| **Technical Architect** | Delivery or client | Owns the overall technical design | Where tests run, which tools to reuse, repo classification |
| **Test Quality Lead** | Delivery or client | Sets the testing standard | Maturity levels, evidence, targets, checks on AI-written tests |
| **Security and Platform Owner** | Client | Guards production and the platforms tests run on | Production safety (can veto); approves container runtimes |
| **Application Owner** | Client | Owns an application and its repos | Commits to a batch; approves the repo and application testing plans; accepts the results |
| **Toolkit Owner** | Delivery, moving to client at handover | Keeps the testing guides, shared test kits and lessons current | Releases of the toolkit; who maintains each shared test kit (with the Steering Group) |
| **Knowledge Curator** | Client | Decides which knowledge sources count for an application (regression packs, wiki pages, tracker queries, other repos) and how current each is | The application's source list |
| **Architecture Owner** | Client | Confirms an application's external systems list and owns its boundary contracts | What the application reaches, and its contracts |
| **Subject-matter expert** | Client | Knows the business rules | The expected results for tests against requirements |
| **Data Protection Officer** | Client | The organisation's own data protection role, required in law for many organisations | Whether cleaned recordings of real data may be treated as anonymous; capture from production |
| **Steering Group** | Both | Programme Sponsor, Engagement Lead, Technical Architect and Security and Platform Owner | Disputes, approving moves between phases, cross-cutting decisions |

## Phases

| Phase | Ends when |
|---|---|
| **Set-up** | The Security and Platform Owner approves the environment, and roles are agreed |
| **Finding out what repos we have** | Repos are classified and the first batches proposed |
| **Pilots** | Each pilot application meets its success criteria, and the testing guides are written |
| **Rolling out in batches** | Each batch is signed off by its Application Owners |
| **Handing over** | The client's teams run batches without the forward deployed team, and the Toolkit Owner role has moved to them |

## Industry terms we keep (explain on first use)

| Term | Plain explanation |
|---|---|
| mutation testing | Deliberately change the code in small ways and check that a test fails each time. |
| contract testing | Two teams agree in code what a request and response look like, and both test against that agreement. |
| property-based testing | Instead of single examples, state a rule ("debits always equal credits") and let a tool try many inputs. |
| snapshot testing | Save a known-good output once; future runs compare against it and a person approves any change. |
| test double / fake / stub | A stand-in for a real dependency during a test. |
| characterisation test | A test that records what code does today, bugs included, so it can be changed safely (Feathers' term). The first step for code nobody can fully explain. |
| golden master | A saved output from a known-good run, compared against every later run; another name for a snapshot or approval test of a whole program. |
| stand-in command | A small program placed first on `PATH` so a script under test calls it instead of the real tool. |
| parallel run | Sending the same work to the old and the new version, comparing results, and still trusting the old one until they agree. |
| strangler fig | Replacing a system piece by piece, routing each piece to the new version as it is ready, instead of all at once. |
| flaky test | A test that sometimes passes and sometimes fails without any code change. |
| Testcontainers, WireMock, Pact, PIT, ArchUnit, jetCheck, bats-core | Tool names. Say what the tool does the first time. |
| **external systems list** | A file listing every external system an application reaches (databases, services, mail, directories, queues, file shares), with the stand-in tests use for each and the addresses tests must never reach; `testing/external-systems.calm.json`, in CALM's format. | connection list |
| **safety inventory** | The gate before any of a repo's tests or its application first runs, done alongside discovery: secrets, keystores, real personal data, jobs that start by themselves, automatic migrations, build tasks that publish or deploy, fixed file paths and file shares. Some findings block the repo from running. | security scan (for the whole step) |
| **discovery** | The first step on every repo, in which nothing runs but its build: a draft external systems list (from its code and settings), the meaningless and unreliable tests, a source list, and the test assets that already exist. Coverage targets apply only afterwards. | |
| **meaningless test** | A test that passes whatever the code does: it never runs, can't fail (no real assertion, or a swallowed failure), or checks only its mocks. | |
| **unreliable test** | A test that may give a different answer on another run: it sleeps for a fixed time, or depends on the order tests run in. | |
| **repair** | The step after measurement that turns each test reaching an external system into a pair from one set of test bodies: one injects a stand-in and runs normally, the other is tagged `external` and runs against the real system. It changes only test code; what needs production code changed is left as work for the testing plan. | clean-up, remediation |
| **reach point** | A place in the code that opens or uses an external system: a database, an HTTP service, mail, a directory, a queue, a socket. | connection point |
| **system** (on the external systems list) | Something outside the program the code connects to: one host, or, while its address isn't known, one setting or one class that opens it. | node, dependency |
| **dispatch point** | A call through an interface with many implementations, such as "notify every listener", which a call graph reports instead of following. | |
| **call graph** | Which methods call which, worked out from the source, used to find the tests that may reach each reach point. | |
| **chain** (of calls) | The calls from a test to a reach point, one method a step: the test first, then the method it calls (or the set-up that leads there), the reach point last. | path, trace |
| **through set-up** | Said of a chain that starts in what runs with a test rather than in the test itself: a set-up or tear-down method, the test class's constructor or fields, or a superclass's. | |
| **shared chain** | The calls every test that may reach one system goes through, nearest the test first, without the test: where one stand-in can cover all of them. | seam |
| **alternatives** (of a system) | Systems reached through the same interface or superclass method, which a program chooses between, so a test reaches one of them, not all. | |
| **local** (connection) | A connection that stays on the machine: a database in memory or in a file, a file, a jar, a classpath resource, localhost. Part of no system. | |
| **test that starts a framework** | A test whose annotation (such as Spring's or Quarkus's) starts a framework that wires objects together and may connect in ways no call in the source shows. | |
| **test assets** | Tests that live outside the repo: automation suites run against a shared test environment, manual test scripts, regression packs. A source of behaviour, never evidence for a test maturity level. | QA artefacts |
| **capture** (of current behaviour) | Recording what an application receives and sends, so it can become approval tests and recorded responses. Always followed by cleaning. | traffic sniffing |
| **cleaning** (of captured data) | Removing or replacing personal and sensitive data in a capture, inside the environment it was captured in, before it is copied anywhere. | sanitising, scrubbing |
| **current behaviour** / **intended behaviour** | What a system does today (pinned by approval tests) and what it should do (recorded in a specification). Every difference becomes an open question. | as-is / to-be |
| **open question** | A difference or unknown that a named person must settle; for behaviour, the Application Owner decides: keep it, fix it, or correct the specification. | red card, hotspot |
| **source list** | The knowledge sources the Knowledge Curator has chosen for an application, checked against a schema. Every drafted rule must cite one. | source manifest |
| **required tests** | The tests a repo must have: one of the right kind for each connection, and passing tests for each specification rule. Measured alongside coverage and mutation results. | test obligations |
| **issue tracker** | Where the programme backlog and each repo's work items are kept. Whichever the organisation already uses (for example GitHub Issues or Jira); named in its organisation profile. | (a product name, except as an example) |
| **organisation profile** | A file in the organisation's private organisation repo recording facts the toolkit can't choose: issue tracker, CI platform, package repository, approved AI assistants, who fills each role. |  |
| **organisation repo** | A separate, private repo that holds **only** an organisation's own additions: its organisation profile, its own decision records, and folders for its organisation units. It names which toolkit version it uses, and that version's artifacts arrive through the organisation's own package repository; the toolkit itself is used unchanged, and the toolkit's tools read both. **Not a fork:** a fork is a copy of the toolkit that you change, which then drifts and has to be merged by hand at every update. Think of the toolkit as a printed map and the organisation repo as a clear sheet laid over it for your own notes. | overlay, fork, config repo |
| **decision guide** | A decision record in this toolkit, written so any organisation can follow it: options, and which fits which situation. |  |
| testing pyramid | The recommended *mix* of tests in a suite: many unit tests, fewer integration tests, few end-to-end tests. Not the maturity levels. Each repo-type guide states a target mix; the measurement run records the actual mix ("test mix"). Legacy repos start top-heavy (broad tests at the edges, level 2) and move toward the pyramid from level 3. |
| forward deployed engineering | Engineers working inside a client's teams to solve their problem end to end, then turning what they learn into reusable tools. |
| ADR (architecture decision record) | A short document recording one decision, the options considered, and why. |
