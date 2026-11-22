# Agent guide

Guidance for any AI coding assistant working in this repo, and for the people directing it.

**What this repo is:** a generic toolkit for raising test quality across many legacy repositories: decision guides, tools,
and AI assistant skills. Lessons on testing techniques live in their own repo,
[under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons). It is used by people with AI coding assistance. AI agents working
unattended are a future direction only.

**Keep it generic.** Never write an organisation's own facts or decisions here. They belong in that organisation's
private organisation repo (see [Organisation-specific facts and decisions live in a private organisation repo](docs/decisions/0003-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md)).
Name a product only as an option or an example.

## Words and references
- Follow [GLOSSARY.md](GLOSSARY.md): plain English, no repurposed words, industry terms explained on first use.
- Refer to anything by its **name, as a link**, never by a code or number.
- No dates in titles or text: source control records when things changed.
- Every YAML file has a JSON Schema in [`schema/`](schema/), referenced from its first line.

## Where things are
| Path | What |
|---|---|
| [`docs/decisions/`](docs/decisions/README.md) | The toolkit's own decisions, made by its maintainers, in MADR form. |
| [`decision-guides/`](decision-guides/README.md) | Decision guides for adopting organisations; each organisation accepts, narrows or replaces them in its organisation repo. |
| [`docs/REFERENCES.md`](docs/REFERENCES.md) | Background and sources. |
| [`techniques/`](techniques/README.md) | One `technique.yaml` per technique: the rules the toolkit's tools read. |
| [`templates/`](templates/) | Starting points an organisation copies into its own repo: its backlog, a testing guide, a shared test kit. Testing guides and shared test kits themselves belong to each organisation. |
| `tools/` | The few tools and rule files adopting organisations run. The toolkit is AI first: a step of the journey is a skill that runs existing tools, and code that must be code gets its own repo (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)). |
| `maintainer-tools/` | Tools that keep this repo itself in order, not used by adopters: [`repo-checks`](maintainer-tools/repo-checks/build.gradle.kts) checks this repo's own files (`./gradlew check`), rebuilds decision indexes (`buildDecisionIndexes`) and repairs decision links (`fixDecisionLinks`); [`sync`](maintainer-tools/sync/README.md) is the maintainers' push script; `git-hooks` refuses a plain `git push`. |
| [`schema/`](schema/) | Schemas for every YAML format. |
| [`ADOPTION.md`](ADOPTION.md) | Step-by-step adoption for an organisation |
| [`examples/organisation-repo/`](examples/organisation-repo/README.md) | The shape of an organisation's private organisation repo. |
| [`plan/toolkit-backlog.yaml`](plan/toolkit-backlog.yaml) | Work to build the toolkit, imported into this repo's issues. |
| [`templates/programme-backlog.yaml`](templates/programme-backlog.yaml) | An organisation's starting backlog, imported into its own tracker. |
| `build-logic/`, `config/quality/` | Gradle conventions and the quality-check rules. |

## Skills
| Skill | Use it to |
|---|---|
| [work-on-an-item](.github/skills/work-on-an-item/SKILL.md) | Pick up a work item from the issue tracker and finish it |
| [run-the-safety-inventory](.github/skills/run-the-safety-inventory/SKILL.md) | Turn a repo's two gitleaks reports into the safety section of its assessment file, before any of its code runs |
| [draft-the-connection-list](.github/skills/draft-the-connection-list/SKILL.md) | Draft a repo's connection list from the airgap agent's reports, with a proposed stand-in for each connection |
| [find-test-anti-patterns](.github/skills/find-test-anti-patterns/SKILL.md) | Count the anti-patterns in a repo's existing tests the same way every time, and note what the list misses |
| [choose-techniques](.github/skills/choose-techniques/SKILL.md) | Propose adopt, defer or reject for every technique, each traced to the rule that decided it |
| [render-the-assessment-report](.github/skills/render-the-assessment-report/SKILL.md) | Fill the report template from a repo's files, and apply the changes people paste back from it |

Each skill's trial, with and without it, is in [`docs/skill-evaluations/`](docs/skill-evaluations/). A new skill gets one too: it must save effort or make the result the same every time.
| [write-a-decision-record](.github/skills/write-a-decision-record/SKILL.md) | Draft a decision guide in this repo |
| [record-an-organisation-decision](.github/skills/record-an-organisation-decision/SKILL.md) | Record an organisation's own choice in its private organisation repo |
| [load-repo-work-into-the-issue-tracker](.github/skills/load-repo-work-into-the-issue-tracker/SKILL.md) | Turn a repo's approved testing plan into work items (placeholder until the loader exists) |
| grilling (installed by APM) | Interview a person about a decision. In Claude Code, ask one question at a time with the AskUserQuestion tool |
| architecture-decision-records (installed by APM) | The mechanics of writing a MADR record; use it with write-a-decision-record, which adds this repo's rules |

Prompts, for short, repeatable jobs where a skill would add more than it saves:

| Prompt | Use it to |
|---|---|
| [strengthen-tests-until-pit-catches-the-planted-bugs](.github/prompts/strengthen-tests-until-pit-catches-the-planted-bugs.prompt.md) | Improve tests until PIT catches the planted bugs in key code, after discovery has shown they can't be trusted |

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
| No copy-pasted code (75 tokens or more) | PMD's copy-paste detector (`cpdCheck`) |
| No bug patterns or security bugs | SpotBugs with FindSecBugs |
| No dependency with a known vulnerability | OSV check in `maintainer-tools/repo-checks` (planned; a one-off check found none) |
| Dependencies kept current (pre-releases ignored) | Ben Manes versions plugin: `./gradlew dependencyUpdates`; checked in CI, failing if `quality.failOnStaleDependencies=true` |
| Local variables `final` where not reassigned; braces always; no star imports | Checkstyle |
| Versions only in [`gradle/libs.versions.toml`](gradle/libs.versions.toml) | Review |
| Ids use the `io.github.fiftieshousewife` namespace | Review |

Tests that need a container go in the `integrationTest` source set, and skip themselves where there's no container runtime.

## Commits
If the organisation profile sets `commit_messages.must_name_work_item`, every commit names its work item key. This repo itself has no such rule.

## Safety
Never build or run code from another repo unless its secrets scan is clean, and only where production can't be reached
(see [Old code runs first only where production cannot be reached](decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)).

## Before you finish
Run `./gradlew check`. It must pass. Push only with `maintainer-tools/sync/sync.sh "What changed"`, which syncs the issues and
backlog page before pushing; never with a plain `git push`.
