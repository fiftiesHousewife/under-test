# Agent guide

Guidance for any AI coding assistant working in this repo, and for the people directing it.

**What this repo is:** a generic toolkit for raising test quality across many legacy repositories: decision guides, tools,
AI assistant skills, and lessons on testing techniques. It is used by people with AI coding assistance. AI agents working
unattended are a future direction only.

**Keep it generic.** Never write an organisation's own facts or decisions here. They belong in that organisation's
private overlay repo (see [Organisation-specific facts and decisions live in a private overlay repo](docs/decisions/0004-organisation-specific-facts-and-decisions-live-in-a-private-overlay-repo.md)).
Name a product only as an option or an example.

## Words and references
- Follow [GLOSSARY.md](GLOSSARY.md): plain English, no repurposed words, industry terms explained on first use.
- Refer to anything by its **name, as a link**, never by a code or number.
- No dates in titles or text: source control records when things changed.
- Every YAML file has a JSON Schema in [`schema/`](schema/), referenced from its first line.

## Where things are
| Path | What |
|---|---|
| [`docs/decisions/`](docs/decisions/README.md) | Decision guides, one small decision each, in MADR form. Agents draft; the deciding role approves by pull request. |
| [`docs/REFERENCES.md`](docs/REFERENCES.md) | Background and sources. |
| [`techniques/`](techniques/README.md) | One folder per technique: `technique.yaml` rules, a `README.md` lesson, and a runnable `example/`. |
| `testing-guides/` | Default approach per technology stack and per application type. |
| `shared-test-kits/` | Stand-ins for widely shared systems. |
| `tools/` | Automated tools. Reuse existing tools before building anything. |
| [`schema/`](schema/) | Schemas for every YAML format. |
| [`examples/organisation-overlay/`](examples/organisation-overlay/README.md) | The shape of an organisation's private overlay repo. |
| [`plan/backlog-seed.yaml`](plan/backlog-seed.yaml) | Starting work list, imported once into the organisation's issue tracker. After that, work comes from the tracker. |
| `build-logic/`, `config/quality/` | Gradle conventions and the quality-check rules. |

## Skills
| Skill | Use it to |
|---|---|
| [work-on-an-item](.github/skills/work-on-an-item/SKILL.md) | Pick up a work item from the issue tracker and finish it |
| [write-a-decision-record](.github/skills/write-a-decision-record/SKILL.md) | Draft a decision guide in this repo |
| [record-an-organisation-decision](.github/skills/record-an-organisation-decision/SKILL.md) | Record an organisation's own choice in its private overlay repo |
| [load-repo-work-into-the-issue-tracker](.github/skills/load-repo-work-into-the-issue-tracker/SKILL.md) | Turn a repo's approved testing plan into work items (placeholder until the loader exists) |
| [write-a-technique-lesson](.github/skills/write-a-technique-lesson/SKILL.md) | Write a technique lesson and example |
| grilling (installed by APM) | Interview a person about a decision. In Claude Code, ask one question at a time with the AskUserQuestion tool |
| architecture-decision-records (installed by APM) | The mechanics of writing a MADR record; use it with write-a-decision-record, which adds this repo's rules |

External skills are declared in [`apm.yml`](apm.yml), pinned, and installed with `apm install` (APM, the Agent Package Manager). Run it once after cloning.

## Code standards (enforced by `./gradlew check`)
| Standard | Enforced by |
|---|---|
| Line coverage at least 80% per project (raise it with `quality.minLineCoverage`) | JaCoCo coverage verification |
| No more than **three parameters** for any method or constructor. Use a Lombok `@Builder` instead | Checkstyle `ParameterNumber`, PMD `ExcessiveParameterList` |
| No record with more than three components. Use a Lombok `@Builder` class instead of a large record | Checkstyle `RecordComponentNumber` |
| A test with more than one assertion wraps them in `assertAll(...)` | PMD rule `MultipleAssertionsMustUseAssertAll` |
| Logging through Lombok `@Slf4j` (SLF4J API, Log4j 2 at run time). No `System.out`, no `java.util.logging` | forbidden-APIs check |
| Time comes from an injected `java.time.Clock`, never `now()` or `currentTimeMillis()` | forbidden-APIs check |
| No unsafe, deprecated, internal or non-portable JDK APIs, and no reflection tricks | forbidden-APIs bundled signatures |
| Methods short and simple: cyclomatic complexity 10 or less, cognitive complexity 15 or less, 50 lines or fewer | Checkstyle and PMD |
| No copy-pasted code (75 tokens or more) | Copy-paste detection |
| No bug patterns or security bugs | SpotBugs with FindSecBugs |
| Dependencies kept current (pre-releases ignored) | Ben Manes versions plugin: `./gradlew dependencyUpdates`; checked in CI, failing if `quality.failOnStaleDependencies=true` |
| Local variables `final` where not reassigned; braces always; no star imports | Checkstyle |
| Versions only in [`gradle/libs.versions.toml`](gradle/libs.versions.toml) | Review |
| Ids use the `io.github.fiftieshousewife` namespace | Review |

Tests that need a container go in the `integrationTest` source set, and skip themselves where there's no container runtime.

## Commits
If the organisation profile sets `commit_messages.must_name_work_item`, every commit names its work item key. This repo itself has no such rule.

## Safety
Never build or run code from another repo unless its secrets scan is clean, and only where production can't be reached
(see [Old code runs first only where production cannot be reached](docs/decisions/0019-old-code-runs-first-only-where-production-cannot-be-reached.md)).

## Before you finish
Run `./gradlew check`. It must pass.
