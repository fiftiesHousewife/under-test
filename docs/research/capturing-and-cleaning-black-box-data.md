# Capturing and cleaning black-box data from old applications

A prior-art review: which existing tools a forward deployed team should use to capture what an old application
receives and sends, remove personal and sensitive data from it, and turn it into approval tests, recorded responses
and replay or differential tests, inside a locked-down corporate network. Numbers in square brackets point to
[References](#references). Words follow [the glossary](../../GLOSSARY.md).

This is research, not a decision. It ends with [proposed decision guides](#proposed-new-or-changed-decision-guides)
for the toolkit's maintainers and adopting organisations to settle.

---

## The question

[Every repo starts with discovery: a draft external systems list, a source list and a check of its existing tests, and a first approval-test baseline follows](../../decision-guides/0032-every-repo-starts-with-discovery-a-draft-external-systems-list-a-source-list-and-a-check-of-its-existing-tests-and-a-first-approval-test-baseline-follows.md)
makes approval tests (tests that save what the code does today and fail when it changes) the first deliverable on
every old repo. For many old applications the quickest honest source of examples is the application itself, run as a
black box: what requests and messages it receives, what it answers, what it asks of the systems behind it, and what
files and rows it writes. Captured, those examples can become:

- **approval tests** pinning current behaviour, the first of the two records in
  [Current and intended behaviour are recorded side by side, and every difference is an open question](../../decision-guides/0033-current-and-intended-behaviour-are-recorded-side-by-side-and-every-difference-is-an-open-question.md);
- **recorded responses** standing in for the systems the application calls, the second choice in
  [Order of preference for test stand-in approaches](../../decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md),
  kept in a shared test kit as
  [Recorded responses and fakes live in shared test kits, not in each repo](../../decision-guides/0039-recorded-responses-and-fakes-live-in-shared-test-kits-not-in-each-repo.md)
  asks;
- **replay and differential tests**, which send the same saved inputs to the old and the new version and compare
  what comes out ([the differential-testing technique](../../techniques/differential-testing/technique.yaml)).

Anything captured from a real environment can hold customers' personal data, and often secrets (session cookies,
bearer tokens, passwords in form posts). [Personal data is removed from any recorded traffic or data](../../decision-guides/0046-personal-data-is-removed-from-any-recorded-traffic-or-data.md)
already says removal is required, but not how, where, or how anyone knows it worked.

So the question is: **where can capture happen and who must approve it; which tools capture, replay and compare;
how is personal and sensitive data removed and the removal checked; and which of these work inside a corporate
network?**

---

## The corporate constraints that decide it

From [Using the toolkit inside a corporate network](../CORPORATE-USE.md), [Old code runs first only where production
cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md) and the
toolkit's tool rules:

| Constraint | What it rules in or out |
|---|---|
| Windows laptops, no administrator rights, often no container runtime | Anything that needs a driver, packet capture, a trusted certificate added to the machine's store, or Docker Desktop can't run on the laptop. Java programs and jars from the package repository can. |
| Nothing installed from the internet; every tool needs a security review that takes weeks | Every extra tool is a cost. A Java library already approved (WireMock, JUnit, ApprovalTests, JSONUnit, XMLUnit) beats a new binary. Python tools need Python and its packages approved. |
| CI on Kubernetes or OpenShift, no Docker daemon, restricted pod security | Tools that need privileged pods or kernel features (eBPF, the Linux kernel's way of running small programs inside the kernel to watch traffic) need a custom security policy the platform team must grant [11]. Ordinary Java processes and sidecar containers from the internal registry are fine. |
| Production and non-production are separated, and old code runs first where production can't be reached | Capture runs first in non-production environments. Capturing in production is a change to production, under change control, with the data owner's approval. |
| Every named tool is checked for maintenance and licence ([Every tool the toolkit names is checked for maintenance and licence](../decisions/0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md)) | Archived, non-commercial or source-available tools are dropped or flagged. AGPL and LGPL are flagged for legal review. |
| Reuse before building ([We reuse existing tools before building new ones](../decisions/0021-we-reuse-existing-tools-before-building-new-ones.md)) | The toolkit builds only the glue that no tool provides. |
| Old applications often run on JDK 8 | Anything that runs *inside* the application (a filter, an agent) must work on JDK 8. Tools that run in their own process (a proxy, a replayer) only need an approved JDK of their own. |
| Data protection law | Captured personal data is still personal data. It has to be cleaned before it leaves the environment it was captured in, and the cleaning has to be shown to work. |

The last two rows matter most. **The capture point decides the approval; the cleaning point decides the legal
risk.**

---

## Options considered

Each table ends with a corporate verdict. "Maintained" means a release within about twelve months when checked,
as [Every tool the toolkit names is checked for maintenance and licence](../decisions/0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md)
asks. The latest release named is the one found at the source during this review.

### 1. Where capture can happen, and who must approve it

#### Recording proxies (between the application and something it calls, or between a client and the application)

| Option | What it does | Where it can run | Laptop: no admin, no containers | Licence, latest release | Corporate verdict |
|---|---|---|---|---|---|
| **WireMock record mode and snapshots** | A Java HTTP server set to proxy to a real service; every request and response passing through is saved as a stub mapping (a request pattern and its saved answer) [1]. `captureHeaders`, `excludeHeaders`, request filters, a size threshold for body files, and custom `StubMappingTransformer`s that rewrite each stub as it is saved [1]. No built-in masking [1]. | Laptop, CI, a test or user acceptance testing (UAT) environment, as a Java process. The application's setting for the service's address is pointed at WireMock. | Yes: one jar from the package repository. WireMock 3 needs Java 11 or later for its own process [3]. | Apache-2.0; 3.13.2 stable, 4.0 in beta [2] | **Adopt first.** Already named by the toolkit and taught in the recorded-responses lesson. Only sees traffic sent to it, which is exactly what is wanted. Cleaning hooks in through a transformer. For HTTPS targets WireMock connects onwards over TLS itself, so the application talks plain HTTP to it in tests and no certificate needs trusting. |
| **Hoverfly capture mode** | A Go proxy that records requests and responses, then simulates them; captured data is exported, changed and re-imported [4]. Middleware can change traffic. No masking feature is described [4]. | Laptop, CI, UAT, as a separate binary or sidecar. | A native binary needs approval as an executable. The Java binding [6] supplies the binary for tests; how it gets it (bundled and unpacked at run time, or downloaded) is not stated in its README, and that matters on locked-down laptops where unpacked executables may be blocked. **Not verified.** | Apache-2.0; 1.12.18 [5] | **Second choice**, where an organisation already approves it. Adds a non-Java binary and a second stub format beside WireMock's. |
| **MockServer** | A Java mock server and proxy that records expectations and can import HAR files (the browser's standard format for saved HTTP traffic) [30]. | Laptop, CI, UAT. | Yes, a jar. | Apache-2.0; 9.4.0 [30] | **Only where already approved.** Overlaps WireMock; the lessons' gap review already prefers WireMock's verify to adding MockServer. |
| **mitmproxy** | An intercepting proxy built for security testing; decrypts HTTPS only when the client trusts mitmproxy's own certificate authority, installed into the machine's or Java's trust store [7]. | Wherever Python runs. | No: needs Python, and trusting a new root certificate, which is a security-team decision and, for the Java trust store, usually administrator rights [7]. | MIT; 12.3.1 [8] | **Reject for routine use.** A tool for breaking TLS is exactly what a corporate security team will refuse, and nothing it does is needed when the application can be pointed at a plain-HTTP WireMock. |
| **Microcks** | A mocking and testing platform on Kubernetes that turns HAR captures, OpenAPI and Postman collections into mocks; its documentation tells users to strip sensitive data from a HAR before loading it [31]. | CI or a shared platform, as a Kubernetes service. | No. | Apache-2.0; 1.16.0 [31] | **Defer.** A useful shared catalogue later; a second mock format for now. |

#### Inside the application

| Option | What it does | Where it can run | Java 8 | Licence, latest release | Corporate verdict |
|---|---|---|---|---|---|
| **Logbook (servlet filter and HTTP-client interceptors)** | Logs whole HTTP requests and responses: a servlet filter for what the application receives, and interceptors for Apache HttpClient 4 and 5, OkHttp, Spring's `RestTemplate`, JAX-RS clients and Netty for what it sends [17]. Built-in filters remove or replace headers (`Authorization` by default), query parameters (`access_token` by default), form fields and JSON body fields, including by JSONPath (a way of naming a field inside a JSON document) [17]. | Any environment the application runs in, as a library added to its build or its server's class path. | The current line needs Java 17 [17]. The older 2.x line has a `javax.servlet` filter and ran on Java 8 [18], but is no longer the maintained line. | MIT; 4.2.0 [17] | **Adopt for capturing what the application itself receives and sends**, where a proxy can't be put in the path (calls to many hosts, a client that can't be repointed). On JDK 8 applications, using the old line conflicts with the maintenance rule: either take a time-limited exception or write a small filter in the repo (Spring's `ContentCachingRequestWrapper` [54] does the buffering in Spring applications). Needs the application's own release process to deploy into UAT. |
| **A Java agent recording bodies (for example, a recording mode in the toolkit's [airgap agent](https://github.com/fiftiesHousewife/under-test-airgap))** | The airgap agent rewrites the JDK's network calls to refuse and report them, and records the target, test, caller and setting for each, but not the content [52]. A recording mode would have to capture bodies. | Laptop and CI (its purpose today); UAT would be a new use. | Yes, by design [52]. | Apache-2.0 (toolkit's own) | **Don't add body capture to the airgap agent.** At the JDK's socket level, HTTPS bodies are already encrypted, so it would need hooks in each HTTP client library, which is what Logbook already does. It would also change a developer-machine safety tool, built to refuse, into a data-capture tool needing different approval in different environments, and would break [Refused calls fail as an unplugged machine would, never with made-up success](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/docs/decisions/0003-refused-calls-fail-as-an-unplugged-machine-would-never-with-made-up-success.md)'s clean story. **Do** use its report: every HTTP target it lists is a place to put a WireMock proxy and record (its own design already says so [52]). |
| **Application and access logs** | Web-server access logs give method, path, query string, status and timing for every request; application logs sometimes give payloads. | Wherever the logs already are. | Not applicable | Not applicable | **Use for shape, not content.** They show which endpoints and parameters matter and how often, so recording sessions cover the real mix. Replaying only from access logs works for reads with no body. Query strings in logs often hold personal data, so logs copied out need the same cleaning. |

#### Live-traffic mirroring (a copy of real traffic sent to a second instance)

| Option | What it does | Where it can run | Licence, latest release | Corporate verdict |
|---|---|---|---|---|
| **Service-mesh mirroring (Istio, and service meshes based on it such as OpenShift Service Mesh)** | Sends a copy of a percentage of live requests to a second service; the copy's responses are thrown away, and its host header gains `-shadow` [10]. | Only on a platform already running a service mesh; normally production or a pre-production environment with real traffic. | Apache-2.0 (Istio) | **Only where the platform already offers it, and only for read-only endpoints.** The copy really runs: a mirrored write writes, and a mirrored call to a payment service pays, unless every downstream system of the copy is a stand-in [10]. Production change control and the data owner's approval apply. Best used as the feed for a differential comparison run inside production's boundary, keeping only the comparison results. |
| **GoReplay** | Listens on a network port and copies HTTP traffic to files or another host [9]. | A Linux host where it is allowed to capture raw traffic; its examples run it with `sudo` [9]. | Core LGPL-3.0, with a commercial licence for the Pro files [9]; last stable release 1.3.3, with the 2.0 release candidates never finished [9] | **Reject.** Needs raw capture rights on the server, its open-source line has had no stable release for years, and the useful extras (binary protocols, storage) are paid. |
| **Keploy** | Records an application's incoming calls and its outgoing calls (HTTP, databases, queues) as test cases and mocks, then replays them [12][14]. On Linux it uses eBPF and runs as root in some set-ups [12]; its documentation now describes a native Windows mode running in user space with no administrator rights and no Docker, alongside older pages that say Windows needs WSL [12]. A `sanitize` command is listed "to remove the sensitive data" without saying how [13]. The CLI reports which paid plan a login key is on [12]. | Linux hosts with kernel capture rights; possibly Windows natively. | Apache-2.0; 3.7.15 [14] | **Defer, pending a trial.** The native Windows mode changes the verdict in [the traffic-record-and-replay technique](../../techniques/traffic-record-and-replay/technique.yaml) and needs checking: whether it needs a Keploy account or contact with Keploy's servers, which would be a blocker in a closed network, was **not verified**. On OpenShift its eBPF capture needs a non-default security policy [11]. Its sanitiser is undocumented, so cleaning stays the toolkit's own step either way. |
| **Packet capture (Wireshark, tcpdump)** | Records every packet on the machine. | Hosts where capture is allowed. | Various | **Reject**, as the airgap agent's design already found: needs elevated rights and a capture driver, and sees other people's traffic [52]. |

#### Databases, message queues and batch files

| Source | Ways to capture | Who must approve | Corporate verdict |
|---|---|---|---|
| **Database snapshots** | A subset of rows that keeps foreign keys intact, extracted with Jailer (Java, runs on Windows desktops, Apache-2.0 [22]); masked in place by PostgreSQL Anonymizer (a PostgreSQL extension, PostgreSQL licence [23]) or Greenmask (PostgreSQL dump and restore with masking, Apache-2.0, 0.2.27 [24]); the database vendor's own masking products for Oracle and others. | The database's owner and its DBA (database administrator); extensions need the DBA to install them. | **Jailer** for subsets, run against a non-production copy; masking at the database before export where the owner allows an extension; otherwise masking by the toolkit's cleaning step on the exported rows. Seed data for shared test kits stays synthetic, as [the personal data guide](../../decision-guides/0046-personal-data-is-removed-from-any-recorded-traffic-or-data.md) says. |
| **Change data capture** (reading every insert, update and delete from the database's own change log) | Debezium [19], which can mask columns as it reads: fixed-length masking, truncation, and hashing with a salt named in the setting [19]. Its own documentation warns that hashed output "may not be fully masked" depending on algorithm, salt and data [19]. | The DBA (it needs a replication user and, for PostgreSQL, publication rights [19]) and the platform team (Kafka Connect or Debezium Server). | **Only where the organisation already runs it.** Too heavy to set up for one repo's discovery; where it exists it is the best record of what a batch job or service wrote. |
| **Kafka** | A separate consumer group reading a topic, which leaves other consumers undisturbed; Kafka Connect's built-in `MaskField` transform blanks or replaces named fields as records are copied [20]. | The topic's owner. | **Adopt** a read-only consumer with its own group, in non-production first, writing records to files for cleaning. `MaskField` only replaces a field with one fixed value, so it is a first pass, not the cleaning step [20]. |
| **JMS queues (IBM MQ, ActiveMQ Artemis and others)** | A `QueueBrowser` looks at messages without removing them [21]; providers don't promise a fixed snapshot, and a browser may miss messages while a consumer is active [21]. Broker features such as copying messages to a second queue vary by product. | The queue's owner, and the middleware team for broker changes. | **Adopt** browsing in non-production, with a small Java program or the broker's own tools, accepting that a browse can miss messages. |
| **Batch files in and out** | Copy an input file and the output the job wrote from the same run in a test or UAT environment. | The data owner of the files. | **Adopt.** The simplest capture of all, and the input to [the batch file-in, file-out technique](../../techniques/batch-file-in-file-out/technique.yaml). Files must be cleaned with substitutes that stay the same across files, or references between them (an account number in the input and the output) stop matching. |

#### Which environment, and what approval

| Environment | What can be captured there | Approval implied |
|---|---|---|
| Developer laptop | Traffic from tests and from the application started locally against stand-ins. Contains no real data unless someone copies it in. | None beyond the tools' own security review. |
| CI | The same, on runners that can't reach production. | The platform team, for any sidecar or extra process. |
| Test or UAT environment | Real behaviour of the application and its real non-production neighbours. Test data in these environments is often a copy of production, so **treat it as personal data unless the data owner says it is synthetic**. | The environment owner, the owners of each system recorded, and the data owner. A change to deploy a filter or repoint settings. |
| Production | Real traffic, real people. | The Security and Platform Owner (can veto), the data owner and the Data Protection Officer, under production change control; usually a data protection impact assessment. Capture and cleaning both run inside production's boundary; only cleaned and checked output leaves. |

### 2. Replay and comparison

| Option | What it does | Fits | Licence, latest release | Corporate verdict |
|---|---|---|---|---|
| **ApprovalTests.Java** | Saves an output as an approved file and fails when a later run differs; scrubbers remove changing text such as dates and identifiers before comparing [25]. | Approval tests of whole responses, reports and files. Supports JDK 8 per its README [25]. | Apache-2.0; 32.1.0 [25] | **Adopt.** Already the toolkit's choice for characterisation tests. |
| **JSONUnit and XMLUnit** | Compare JSON and XML by structure, ignoring chosen fields, order or values [26][27]. | Comparing captured responses where some fields legitimately change. | Apache-2.0; JSONUnit 6.4.0 per its README [26], XMLUnit 2.14.0 [27] | **Adopt.** Already in [the structured-output comparison technique](../../techniques/structured-output-comparison/technique.yaml). JSONUnit's README does not state a Java version; which line supports JDK 8 was **not verified**. |
| **datacompy** | Compares tables (CSV, data frames) row by row with tolerances [28]. | Batch output. | Apache-2.0; 1.2.0 [28] | **Only where Python is approved**; otherwise a Java comparison of records. |
| **WireMock playback** | Replays saved stub mappings; can also check which requests the code sent [1]. | Recorded responses for systems the application calls. | As above | **Adopt.** |
| **Hoverfly simulate mode** | Replays a captured simulation [4]. | As WireMock. | As above | **Only where already approved.** |
| **Diffy-style comparison proxy** | Sends each request to the new version, the old version and a second copy of the old, and uses the two old copies to tell noise from real differences [15]. | Read-only traffic during a rewrite. | Original archived [16]; the maintained fork is under CC BY-NC-ND 4.0, a non-commercial, no-changes licence [15] | **Reject**, as [the differential-testing technique](../../techniques/differential-testing/technique.yaml) already says. Its idea of a second old copy to measure noise is worth copying in the toolkit's own replay. |
| **Keploy replay** | Replays its test cases against a new build with its mocks standing in for dependencies [12]. | HTTP services on hosts where Keploy runs. | As above | **Defer**, as above. |
| **Offline replay of saved requests against two builds** | Saved, cleaned requests are sent to the old build and the new build, both running against the same recorded responses, and the answers are compared with JSONUnit or XMLUnit. | Migrations and refactors; the fallback the differential-testing technique already names. | Not applicable (JUnit, an HTTP client, JSONUnit) | **Adopt as the default differential test.** Runs on a laptop and in CI with tools already approved. |
| **Pact** | Contract tests: a consumer's expectations, checked against the provider [29]. | Between teams who will both maintain a contract. | Apache-2.0; 4.7.7 [29] | **Not a capture tool.** Captured requests and responses can show what to put in a first contract, but a contract is agreed, not recorded. Keep it in its place in [Order of preference for test stand-in approaches](../../decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md). |

### 3. Removing personal and sensitive data

#### What the law counts as anonymous

- **Pseudonymised data is still personal data.** The GDPR defines pseudonymisation as processing so that data can no
  longer be linked to a person without additional information kept separately and protected [40]. The ICO says
  pseudonymised data "is personal data in the hands of someone who holds the additional information" [41]. The
  EDPB's (European Data Protection Board) guidelines on pseudonymisation take the same line [44].
- **Anonymous data is outside the law**, but only if no one can identify anyone "by means reasonably likely to be
  used" [40][42]. The ICO describes identifiability as a spectrum, and asks controllers to apply a *motivated
  intruder* test: could a competent person with ordinary resources identify someone? [42]. Its three risks are
  singling a person out, linking records about the same person, and inferring new facts about them [42]; the older
  Article 29 Working Party opinion on anonymisation techniques sets out the same three tests [46].
- **Whose view counts is shifting.** The EU Court of Justice, in *EDPS v SRB* (case C‑413/23 P), held that
  pseudonymised data may not be personal data for a recipient who has no reasonable means to re-identify it, while
  remaining personal data for the sender [45]. The ICO also says pseudonymised data shared without the key "may be
  anonymous information" in the recipient's hands [41]. The ICO says its anonymisation guidance is under review
  following the Data (Use and Access) Act [43]; whether that Act changes the UK test of identifiability was **not
  verified** at the source (the government's summary of the Act doesn't cover it [51]).

**What this means for the toolkit:** a recording cleaned with keyed substitutes, where the key stays inside the
capture environment, is pseudonymised for the organisation that holds the key. It is safer to treat every cleaned
recording as personal data of low risk (kept in internal repos, access-controlled, not published) than to claim it is
anonymous. Claiming anonymity is a decision for the Data Protection Officer, not the engineer. Free text (notes,
addresses, descriptions) is where re-identification hides; dropping or replacing it whole is safer than trying to
clean inside it.

#### Where the cleaning must happen

**Inside the environment the data was captured in, before it is copied anywhere.** A recording taken in UAT is
cleaned in UAT (or on a machine inside the same boundary that the data owner approves) and only the cleaned,
checked result is copied to a developer's laptop or committed. This keeps raw captures out of source control
history, which is very hard to rewrite, and out of the AI assistant's context. Two practical consequences: the
cleaning tool has to be a plain Java program that can run where the capture runs, and the key for keyed substitutes
lives in that environment's vault, never in the repo.

#### Detection: finding what needs cleaning

| Option | What it does | Runs on | Licence, latest release | Corporate verdict |
|---|---|---|---|---|
| **Field rules written from the external systems list and the schema** | People name the fields that hold personal data (by JSONPath, XPath, header, column) from the API description, the database schema and a look at sample captures. | Anything | Not applicable | **The primary method.** Known structure beats guessing; every rule is reviewable. |
| **Pattern and check-digit detectors in Java** | Regular expressions plus check digits for card numbers (Luhn), IBANs, email addresses (Apache Commons Validator [37]), and patterns for national identifiers, phone numbers and postcodes. | JDK 8 and later | Apache-2.0 (Commons Validator) | **Adopt as the gate's core.** Few false alarms on structured identifiers; runs anywhere. Misses names and free text. |
| **gitleaks** | Scans files and folders, not only Git history, for secrets [38]. | A single binary | MIT [38] | **Adopt for secrets in recordings** (tokens, cookies, keys). Already required by [No repo's tests or application run until its secrets scan is clean](../../decision-guides/0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md). Its README now says it is feature complete and will get security fixes only, as its maintainer moves to a successor project [38]; the secrets-scan guide should watch this. |
| **Presidio** | Detects personal data in text with patterns, checksums and named-entity recognition (a language model that spots names, places and organisations), and replaces it; has a module for structured and semi-structured data, and HTTP services in Docker images [32]. States plainly that "there is no guarantee that Presidio will find all sensitive information" [32]. Moved from Microsoft to an independent organisation, keeping its MIT licence [32]. | Python, or its container images | MIT; 2.2.366 [32] | **Second line, in CI or the capture environment where Python or its images are approved.** Best at names in free text, which the Java detectors miss. The language models it uses come as extra packages, which a closed network must also mirror (**not verified** in detail). Never the only check. |
| **Cloud detection services (Google Cloud's and Amazon's data loss prevention services)** | Managed detection. | The provider's cloud | Commercial | **Reject** for this purpose: the raw data would leave the boundary to be checked. |

#### Replacement: what goes in place of personal data

| Technique | How | Keeps | Corporate verdict |
|---|---|---|---|
| **Drop or fixed text** | Remove the field, or replace with `REMOVED`. WireMock's `excludeHeaders` [1], Logbook's filters [17], Kafka's `MaskField` [20]. | Nothing. | **Adopt for secrets and free text.** Breaks tests that depend on the value. |
| **Keyed substitutes** | An HMAC (a hash mixed with a secret key, in the JDK's `javax.crypto.Mac` [39]) of the value picks a substitute: either the hash itself, or a seed for a realistic fake value. The same input always gives the same substitute, so an account number matches across requests, files and tables. | Joins, repeated values, counts. | **Adopt as the default for identifiers.** Uses only the JDK. Without the key nobody can reverse it; with the key, anyone can check a guess, so the key is a secret. A plain unsalted hash is not enough: identifiers such as phone numbers can be guessed and hashed. Debezium's own warning about its hashing shows why [19]. |
| **Realistic synthetic values** | Datafaker generates names, addresses and other values in many locales, including en-GB [34]; seeded from the keyed hash, the same input always gets the same fake. | Format, realism, consistency. | **Adopt**, where the repo's JDK allows: Datafaker 2 needs Java 17 and the Java 8 line is no longer maintained [34]. The cleaning tool runs in its own JVM, so this is a constraint only for test code in JDK 8 repos. |
| **Format-preserving encryption** | Encrypts a value into another value of the same format (a 16-digit number stays a 16-digit number), and can be reversed with the key. Bouncy Castle has the NIST methods FF1 and FF3-1 [35]. NIST's second draft revision removes FF3 because of a weakness affecting FF3-1 as well, and raises the minimum size of the values it may be used on [36]. | Format, reversibility. | **Rarely needed.** Reversibility is a risk, not a benefit, for test data. Use FF1 only where a downstream system validates format and a keyed substitute can't satisfy it. |
| **Date shifting and generalisation** | Move every date for one person by the same keyed offset; reduce precision (birth year, not birth date; postcode district, not full postcode). | Intervals and order. | **Adopt** for dates of birth and similar. |
| **Statistical anonymisation (ARX)** | Measures and reduces re-identification risk in tables with privacy models such as k-anonymity (every record looks like at least k-1 others on the fields an intruder might know), l-diversity and differential privacy [33]. Java, with a desktop program and a library [33]. | Statistical use. | **Only for the Data Protection Officer's evidence**, when someone wants to claim a table extract is anonymous. Too heavy for routine test data, and generalising values breaks exact-match tests. Apache-2.0; 3.9.2 [33]. |

#### Commercial products, for contrast only

| Product | What it is | Note |
|---|---|---|
| Tonic Structural | Test-data platform: de-identifies and subsets databases, with detection, masking, consistent substitutes and format-preserving encryption, self-hosted or cloud [47]. | Does what the toolkit's database and file cleaning would do, at a price; organisations that already own it should use it. |
| Delphix | Test-data virtualisation and masking, now owned by Perforce [49]. | As above. |
| Informatica test data management | Masking and subsetting, part of Informatica, now owned by Salesforce [50]. | As above. |
| Gretel | Synthetic data generation, reported as bought by NVIDIA [48]. | Shows the direction of synthetic data, not needed for test recordings. |

None of them captures traffic; all of them clean databases. Where an organisation owns one, the toolkit should use it
for database extracts and keep its own step for traffic and files.

#### Checking that the cleaning worked

Cleaning rules miss things: a new field, a name inside a comment, a token in a URL. So the check is separate from the
cleaning, and fails the build:

1. **A detector gate** runs on every recording and captured file in the repo or shared test kit, in the build and in
   CI: the Java pattern and check-digit detectors, plus gitleaks for secrets. Anything found fails the build until
   it is cleaned or listed in an allowlist with a reason (as `.gitleaksignore` works today).
2. **A second detector where available** (Presidio) runs on the same files in the capture environment before export,
   for names in free text.
3. **The substitutes are checked to be substitutes:** the gate fails if any value that a cleaning rule covers still
   matches the raw capture (the cleaner records a keyed hash of each original, so the check needs no raw data).
4. **A person signs off a sample** the first time a system's cleaning rules are written, and whenever they change:
   the owner of the shared test kit, with the data owner.

---

## Recommended approach, in order of preference

**Capture**, taking the first that fits each connection in the external systems list:

1. **Generate the examples, don't capture them,** where the inputs are simple enough: synthetic requests and files
   (Datafaker) driven through the application on a laptop or in CI. No personal data, no approval. Many approval
   tests need nothing more.
2. **A WireMock recording proxy in a non-production environment,** for each HTTP service the application calls, with
   the airgap agent's report saying which targets to record. Cleaning runs as a WireMock transformer at the moment
   stubs are saved, so raw responses are never written.
3. **Logbook inside the application in a test or UAT environment,** for what the application receives, or where a
   proxy can't be placed. Logbook's own filters drop secrets at source; the cleaning step does the rest before
   export. On JDK 8 applications, a small filter in the repo or a time-limited exception for Logbook's old line.
4. **Read-only copies from queues and files** in non-production: a separate Kafka consumer group, a JMS queue
   browser, copies of a batch run's input and output.
5. **Database subsets** with Jailer from a non-production copy, cleaned by the database's own masking where the
   owner allows, otherwise by the cleaning step; or the organisation's commercial test-data product if it has one.
6. **Production capture only with the approvals in the table above,** through service-mesh mirroring or Logbook,
   with capture, cleaning and checking all inside production's boundary.
7. **Keploy** only after a trial shows it runs with no outside contact on the organisation's machines, and only on
   read-mostly HTTP services. The trial is decided in
   [Keploy is trialled on a pilot application to record current behaviour from real traffic](../decisions/0037-keploy-is-trialled-on-a-pilot-application-to-record-current-behaviour-from-real-traffic.md):
   on Windows and Apple-silicon macOS Keploy runs as an ordinary user, and fully understands HTTP and HTTPS, MySQL and
   MongoDB there; PostgreSQL, Redis and Kafka are captured only as raw bytes. Some of its protocol components aren't
   open source.

**Clean** inside the capture environment, by field rules kept with the shared test kit for that system: drop
secrets and free text; keyed substitutes for identifiers; seeded Datafaker values where realism matters; date shifts
for dates of birth; format-preserving encryption only when a format check demands it.

**Check** with the detector gate in every build, a second detector where Python is approved, and a person's sign-off
on the first sample.

**Use** the cleaned data three ways: ApprovalTests with JSONUnit or XMLUnit comparisons for current behaviour;
WireMock playback for recorded responses in shared test kits; and offline replay of saved requests against old and
new builds, compared with the same tools, for differential tests, with a second run of the old build to measure
noise as Diffy did.

---

## What to build, if anything

Reuse covers capture, replay and comparison. Nothing found covers cleaning and checking captured traffic and files
with stable substitutes, in plain Java, inside a closed network. So the toolkit would build:

1. **A recording cleaner** (a Java library and a command-line program, JDK 8 runtime or later for the command-line
   program, built with the toolkit's conventions). It reads WireMock stub mappings, Logbook's JSON log lines, JSON,
   XML, CSV and fixed-width files, and applies rules from a YAML file with a JSON Schema: per field (JSONPath through
   Jayway JsonPath [53], XPath through the JDK, header, query parameter, CSV column), one action (drop, fixed text,
   keyed substitute, seeded Datafaker value of a named kind, date shift, format-preserving encryption). The key comes
   from an environment variable or the vault, never a file in the repo. It ships as a WireMock
   `StubMappingTransformer` too, so it cleans during recording. Each run writes a report of rules applied and fields
   seen that no rule covered.
2. **A detector gate** in the convention plugin: a check task over `testing/` and shared test kits using Apache
   Commons Validator and the toolkit's own patterns (UK and EU identifiers to begin with, each with check digits where
   they have one), calling gitleaks for secrets and Presidio where configured, with an allowlist file with reasons.
3. **A converter from the airgap agent's report to a recording plan**: each HTTP target becomes a WireMock proxy
   mapping and a draft cleaning-rules file, and each target is marked in the draft external systems list as "recorded
   responses". Small, and it joins two things the toolkit already has.
4. **A replay helper for differential tests**: a JUnit extension that sends each saved request to two base URLs
   and compares the answers with JSONUnit or XMLUnit, with ignore rules shared with the approval tests. Possibly just
   a documented pattern rather than a library; decide after the lesson is written.

Not to build: a recording proxy, a body-capturing Java agent, a personal-data detector based on language models, a
database masking tool.

---

## Proposed new or changed decision guides

Titles follow the toolkit's style. Each would sit in the "Standing in for real systems" or "Test hygiene" groups.

1. **New: Black-box captures are taken in non-production environments first, and from production only with the data
   owner's and Security and Platform Owner's approval.** Options: non-production only; non-production first, production
   with named approvals and a data protection impact assessment; free choice per team. Proposed outcome: the second.
   Builds on [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md).
2. **New: Order of preference for where behaviour is captured.** Options: generated examples, then a recording proxy,
   then a filter inside the application, then read-only copies from queues and files, then database subsets, then
   production mirroring; or free choice. Proposed outcome: the order, with Keploy deferred until a trial, and packet
   capture and TLS-intercepting proxies ruled out. Builds on [Order of preference for test stand-in approaches](../../decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md).
3. **New: Recordings are cleaned inside the environment they were captured in, before they are copied anywhere.**
   Options: clean at capture or before export; clean on the developer machine before commit; clean in CI after
   commit. Proposed outcome: the first; the other two leave raw data on laptops, in repos' history or in an AI
   assistant's context.
4. **New: How personal data in recordings is replaced: dropped, keyed substitutes or synthetic values, chosen per
   field.** Options: fixed text everywhere; keyed substitutes and seeded synthetic values per field, with dropping for
   secrets and free text; format-preserving encryption everywhere; a commercial product. Proposed outcome: the second,
   with the key in the capture environment's vault, and format-preserving encryption (FF1 only) as a named exception.
5. **New: Cleaned recordings pass a detector check before they are committed, and the first sample is signed off by
   a person.** Options: a pattern and check-digit gate plus a secrets scan in every build, a language-model detector
   where approved, and a person's sign-off on first rules; a person's review only; a detector only. Proposed outcome:
   the first.
6. **New: Cleaned recordings are treated as personal data of low risk unless the Data Protection Officer agrees they
   are anonymous.** Options: treat as personal data (internal repos, access-controlled, never public); treat as
   anonymous after cleaning; ask each time. Proposed outcome: the first, reflecting the GDPR, ICO guidance and *EDPS v
   SRB* [40][41][45]. Decided by the Data Protection Officer, a role the toolkit would need to add to its role list.
7. **Changed: [Personal data is removed from any recorded traffic or data](../../decision-guides/0046-personal-data-is-removed-from-any-recorded-traffic-or-data.md).**
   Keep its outcome, and add consequences pointing to guides 3 to 6: where cleaning happens, how values are
   replaced, how cleaning is checked, and the legal status. Extend "personal data" to "personal and sensitive data,
   including secrets", since tokens and cookies are the commonest leak in recorded HTTP traffic.
8. **Changed: [Recorded responses and fakes live in shared test kits, not in each repo](../../decision-guides/0039-recorded-responses-and-fakes-live-in-shared-test-kits-not-in-each-repo.md).**
   Add that each shared test kit holds the cleaning rules for its system, so every repo that records it cleans the
   same way, and that its owner signs off rule changes.
9. **New: Differential tests replay saved requests against old and new builds offline, and live comparison runs only
   on read-only traffic.** Options: offline replay with recorded responses; live mirroring with comparison inside
   production's boundary; a comparison proxy such as Diffy (ruled out by licence). Proposed outcome: offline replay
   by default, live comparison only for read-only endpoints with named approvals. Would update
   [the differential-testing technique](../../techniques/differential-testing/technique.yaml).

Technique files that would change once the guides are settled: [traffic-record-and-replay](../../techniques/traffic-record-and-replay/technique.yaml)
(its "Windows-only runtime" rejection may no longer hold; add "needs no contact outside the network" as a
precondition check), [recorded-http-responses](../../techniques/recorded-http-responses/technique.yaml) (add the
cleaning step and the detector gate as precondition checks, and Logbook as a capture tool), and
[structured-output-comparison](../../techniques/structured-output-comparison/technique.yaml) (captured and cleaned
output as a source of examples).

---

## Open questions

1. **Keploy on closed networks:** does the native Windows mode, or the Linux mode, need a Keploy account or any
   contact with Keploy's servers? What does `sanitize` actually detect? A trial on a machine with no internet route
   would answer both.
2. **Logbook on JDK 8:** is a time-limited exception for its old line acceptable, or should JDK 8 applications get a
   small filter in the repo? How many target applications still run on JDK 8 decides how much this matters.
3. **UK identifiability test:** does the Data (Use and Access) Act change how the UK judges whether data identifies
   someone, and what does the ICO's revised anonymisation guidance say once published [43][51]? Not verified here.
4. **Who holds the substitution key,** per environment, and does the Data Protection Officer accept keyed
   substitutes as adequate pseudonymisation for internal test repos?
5. **Presidio inside a closed network:** can its Python packages, container images and language models all be
   mirrored and approved? If not, the gate rests on Java detectors and people's review.
6. **gitleaks' future:** its README says it is feature complete, with security fixes only [38]; [No repo's tests or
   application run until its secrets scan is clean](../../decision-guides/0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md)
   may need to name a successor.
7. **Hoverfly's Java binding on locked-down Windows:** how does it supply the Hoverfly binary, and would application
   allowlisting block it? Not verified [6].
8. **Data Protection Officer as a role:** the toolkit's role list has no one who decides legal status of data. Add the
   role, or name the Security and Platform Owner as the route to them?
9. **Test environments seeded from production:** many organisations' UAT data is a production copy. Should
   discovery record, per environment, whether its data is synthetic, and should capture there count as production
   capture when it isn't?

---

## References

1. WireMock, Record and playback. <https://wiremock.org/docs/record-playback/>
2. WireMock repository and releases (Apache-2.0; 3.13.2 stable, 4.0.0 betas on Maven Central). <https://github.com/wiremock/wiremock/releases>
3. OpenRewrite, Upgrade WireMock to 3.x (WireMock 3 requires Java 11 or higher). <https://docs.openrewrite.org/recipes/java/testing/wiremock/upgradewiremockdependencyversion>
4. Hoverfly, Capture mode. <https://docs.hoverfly.io/en/latest/pages/keyconcepts/modes/capture.html>
5. Hoverfly repository (Apache-2.0; v1.12.18). <https://github.com/SpectoLabs/hoverfly>
6. Hoverfly Java binding. <https://github.com/SpectoLabs/hoverfly-java>
7. mitmproxy, About certificates. <https://docs.mitmproxy.org/stable/concepts/certificates/>
8. mitmproxy repository (MIT; v12.3.1). <https://github.com/mitmproxy/mitmproxy>
9. GoReplay repository, and its licence (LGPL-3.0 core, commercial licence for Pro files; 1.3.3 latest stable). <https://github.com/probelabs/goreplay>, <https://github.com/probelabs/goreplay/blob/master/LICENSE.txt>
10. Istio, Mirroring. <https://istio.io/latest/docs/tasks/traffic-management/mirroring/>
11. Red Hat OpenShift Container Platform, Managing security context constraints. <https://docs.redhat.com/en/documentation/openshift_container_platform/4.22/html/authentication_and_authorization/managing-pod-security-policies>
12. Keploy, Installation (platforms, eBPF, native Windows, plans). <https://keploy.io/docs/server/installation/>
13. Keploy, CLI commands (`sanitize`). <https://keploy.io/docs/running-keploy/cli-commands/>
14. Keploy repository (Apache-2.0; v3.7.15). <https://github.com/keploy/keploy>
15. Diffy, maintained fork (CC BY-NC-ND 4.0). <https://github.com/opendiffy/diffy>
16. Diffy, original repository (archived). <https://github.com/twitter-archive/diffy>
17. Logbook repository (MIT; 4.2.0; Java 17; integrations and filters). <https://github.com/zalando/logbook>
18. Logbook servlet 2.16.0 build file (`javax.servlet`). <https://repository.jboss.org/nexus/content/groups/m2-proxy/org/zalando/logbook-servlet/2.16.0/logbook-servlet-2.16.0.pom>
19. Debezium, PostgreSQL connector; and column masking properties as documented for the MySQL connector. <https://debezium.io/documentation/reference/stable/connectors/postgresql.html>, <https://docs.confluent.io/platform/current/connect/debezium-connect-mysql/mysql_source_connector_config.html>
20. Kafka Connect `MaskField` transform; and KIP-437, custom replacement for `MaskField`. <https://docs.confluent.io/platform/current/connect/transforms/maskfield.html>, <https://cwiki.apache.org/confluence/display/KAFKA/KIP-437:+Custom+replacement+for+MaskField+SMT>
21. Jakarta Messaging, `QueueBrowser`. <https://jakarta.ee/specifications/platform/11/apidocs/jakarta/jms/queuebrowser>
22. Jailer repository (Apache-2.0). <https://github.com/Wisser/Jailer>
23. PostgreSQL Anonymizer (PostgreSQL licence). <https://www.pgxn.org/dist/postgresql_anonymizer/>
24. Greenmask repository (Apache-2.0; v0.2.27). <https://github.com/GreenmaskIO/greenmask>
25. ApprovalTests.Java repository (Apache-2.0; 32.1.0); and its Options reference (scrubbers). <https://github.com/approvals/ApprovalTests.Java>, <https://github.com/approvals/ApprovalTests.Java/blob/master/approvaltests/docs/reference/Options.md>
26. JSONUnit repository (Apache-2.0; 6.4.0 in README). <https://github.com/lukas-krecan/JsonUnit>
27. XMLUnit for Java repository (Apache-2.0; v2.14.0). <https://github.com/xmlunit/xmlunit>
28. datacompy repository (Apache-2.0; v1.2.0). <https://github.com/capitalone/datacompy>
29. Pact JVM repository (Apache-2.0; 4.7.7). <https://github.com/pact-foundation/pact-jvm>
30. MockServer repository (Apache-2.0; 9.4.0). <https://github.com/mock-server/mockserver-monorepo>
31. Microcks repository (Apache-2.0; 1.16.0); and Microcks, Using HAR files. <https://github.com/microcks/microcks>, <https://microcks.github.io/documentation/using/har/>
32. Presidio documentation and repository (MIT; 2.2.366; moved from Microsoft). <https://presidio.dataprivacystack.org/>, <https://github.com/data-privacy-stack/presidio>, <https://raw.githubusercontent.com/microsoft/presidio/main/README.MD>
33. ARX, Overview; and ARX repository (Apache-2.0; v3.9.2). <https://arx.deidentifier.org/overview/>, <https://github.com/arx-deidentifier/arx>
34. Datafaker repository (Apache-2.0; 2.7.0; Java 17; en-GB locale). <https://github.com/datafaker-net/datafaker>
35. Bouncy Castle, `FPEFF1Engine` (FF1; `FPEFF3_1Engine` alongside it). <https://downloads.bouncycastle.org/java/docs/bcprov-jdk18on-javadoc/org/bouncycastle/crypto/fpe/FPEFF1Engine.html>
36. NIST SP 800-38G Revision 1, second public draft (FF3 removed). <https://csrc.nist.gov/pubs/sp/800/38/g/r1/2pd>
37. Apache Commons Validator. <https://commons.apache.org/proper/commons-validator/>
38. gitleaks repository (MIT; `dir` scans plain folders; feature-complete notice). <https://github.com/gitleaks/gitleaks>
39. Java SE, `javax.crypto.Mac`. <https://docs.oracle.com/javase/8/docs/api/javax/crypto/Mac.html>
40. Regulation (EU) 2016/679 (GDPR), Article 4(5) and Recital 26. <https://eur-lex.europa.eu/eli/reg/2016/679/oj>
41. ICO, Pseudonymisation. <https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/pseudonymisation/>
42. ICO, How do we ensure anonymisation is effective? <https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/how-do-we-ensure-anonymisation-is-effective/>
43. ICO, Anonymisation guidance (notice that it is under review following the Data (Use and Access) Act). <https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/>
44. EDPB, Guidelines 01/2025 on pseudonymisation. <https://www.edpb.europa.eu/our-work-tools/documents/public-consultations/2025/guidelines-012025-pseudonymisation_en>
45. Court of Justice of the EU, case C‑413/23 P, *EDPS v SRB*. <https://eur-lex.europa.eu/case/EN/C_413_23_P>
46. Article 29 Data Protection Working Party, Opinion 05/2014 on anonymisation techniques. <https://ec.europa.eu/justice/article-29/documentation/opinion-recommendation/files/2014/wp216_en.pdf>
47. Tonic.ai, Tonic Structural. <https://www.tonic.ai/products/tonic-structural>
48. TechCrunch, Nvidia reportedly acquires synthetic data startup Gretel. <https://techcrunch.com/2025/03/19/nvidia-reportedly-acquires-synthetic-data-startup-gretel>
49. Perforce, Perforce completes Delphix acquisition. <https://www.perforce.com/press-releases/perforce-completes-delphix-acquisition>
50. Salesforce, Salesforce completes acquisition of Informatica. <https://www.salesforce.com/news/press-releases/2025/11/18/salesforce-completes-acquisition-of-informatica/>
51. GOV.UK, Data (Use and Access) Act 2025: data protection and privacy changes. <https://www.gov.uk/guidance/data-use-and-access-act-2025-data-protection-and-privacy-changes>
52. The airgap agent's design. <https://github.com/fiftiesHousewife/under-test-airgap/blob/main/docs/design.md>
53. Jayway JsonPath repository. <https://github.com/json-path/JsonPath>
54. Spring Framework, `ContentCachingRequestWrapper`. <https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/util/ContentCachingRequestWrapper.html>

**Checked at the source:** licences and latest releases from each project's repository or documentation, except
where noted. **Not verified:** Keploy's need for outside contact and what its `sanitize` does; how Hoverfly's Java
binding supplies its binary; which JSONUnit line supports JDK 8; whether the Data (Use and Access) Act changes the UK
identifiability test; how Presidio's language models are packaged for a closed network; the Java version and
maintenance status of Logbook's 2.x line beyond its build file.
