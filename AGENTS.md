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
| [`docs/JOURNEY.md`](docs/JOURNEY.md) | A repo's journey step by step, linking every decision guide (the build checks it). |
| [`docs/decisions/`](docs/decisions/README.md) | The toolkit's own decisions, made by its maintainers, in MADR form. |
| [`decision-guides/`](decision-guides/README.md) | Decision guides for adopting organisations; each organisation accepts, narrows or replaces them in its organisation repo. |
| [`docs/REFERENCES.md`](docs/REFERENCES.md) | Background and sources. |
| [`techniques/`](techniques/README.md) | One `technique.yaml` per technique: the rules the toolkit's tools read. |
| [`templates/`](templates/) | Starting points an organisation copies into its own repo: its backlog, a testing guide, a shared test kit. Testing guides and shared test kits themselves belong to each organisation. |
| `tools/` | The few tools and rule files adopting organisations run. The toolkit is AI first: a step of the journey is a skill that runs existing tools, and code that must be code gets its own repo (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)). |
| `maintainer-tools/` | Tools that keep this repo itself in order, not used by adopters: [`repo-checks`](maintainer-tools/repo-checks/build.gradle.kts) checks this repo's own files (`./gradlew check`), rebuilds decision indexes (`buildDecisionIndexes`) and repairs decision links (`fixDecisionLinks`); [`skill-evals`](.github/evals/README.md) runs every skill's eval cases with `claude plugin eval` and writes [the results page](docs/skill-evaluations/eval-results.md); [`drawing-export`](maintainer-tools/drawing-export/README.md) turns an Excalidraw drawing into the SVG the README shows; [`apm-package`](maintainer-tools/apm-package/README.md) checks the toolkit installs as an APM package and lists a release's changes; [`discovery-check`](maintainer-tools/discovery-check/README.md) runs a field-trial repo's tests under the airgap agent and compares them with discovery; [`safety-inventory-rules`](maintainer-tools/safety-inventory-rules/check.sh) runs gitleaks with the safety inventory's rule files over its sample repo, in CI, and compares the findings with the expected lists. |
| [`.apm/skills/`](.apm/skills) | The skills an adopting repo gets from the toolkit's APM package: links to the journey skills in `.github/skills/`. Maintainer skills stay out. |
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
| [run-the-safety-inventory](.github/skills/run-the-safety-inventory/SKILL.md) | Turn a repo's gitleaks reports, and a list of keystores ever committed, into the safety section of its assessment file, the gate before any of its tests or its application first run |
| [draft-the-external-systems-list](.github/skills/draft-the-external-systems-list/SKILL.md) | Draft a repo's external systems list from its code with under-test-external-calls and from its settings, grade each test reaches, may reach or cannot reach for each external system, and later merge in the airgap agent's reports |
| [find-meaningless-and-unreliable-tests](.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | Find a repo's meaningless tests (never run, can't fail, check only their mocks) and unreliable ones (sleep, depend on order), the same way every time |
| [measure-a-repo](.github/skills/measure-a-repo/SKILL.md) | Measure a Gradle repo under the airgap agent, in stages: build, one run leaving out the tests graded reaches, repeats in varied orders for flaky tests, with coverage, then planted bugs; and the test mix |
| [score-obstacles](.github/skills/score-obstacles/SKILL.md) | Score a repo's obstacles to testing from what is already recorded, by the named list in the decision guide |
| [choose-techniques](.github/skills/choose-techniques/SKILL.md) | Propose adopt, defer or reject for every technique, each traced to the rule that decided it |
| [write-the-testing-plan](.github/skills/write-the-testing-plan/SKILL.md) | Generate a repo's testing plan from its assessment file and external systems list, each piece of work with a stable key |
| [render-the-assessment-report](.github/skills/render-the-assessment-report/SKILL.md) | Fill the report template from a repo's files, and apply the changes people paste back from it |
| [write-a-decision-record](.github/skills/write-a-decision-record/SKILL.md) | Draft a decision guide in this repo |
| [record-an-organisation-decision](.github/skills/record-an-organisation-decision/SKILL.md) | Record an organisation's own choice in its private organisation repo |
| [load-repo-work-into-the-issue-tracker](.github/skills/load-repo-work-into-the-issue-tracker/SKILL.md) | Turn a repo's approved testing plan into work items (placeholder until the loader exists) |
| grilling (installed by APM) | Interview a person about a decision. In Claude Code, ask one question at a time with the AskUserQuestion tool |
| architecture-decision-records (installed by APM) | The mechanics of writing a MADR record; use it with write-a-decision-record, which adds this repo's rules |

Each journey skill has an eval case in [`.github/evals/`](.github/evals/README.md), run five times with and without the skills by `claude plugin eval` (see [Skill evals run on a clean copy of the whole toolkit, which is the plugin, so skills can read its files](docs/decisions/0047-skill-evals-run-on-a-clean-copy-of-the-whole-toolkit-which-is-the-plugin-so-skills-can-read-its-files.md)); the latest results are in [`docs/skill-evaluations/eval-results.md`](docs/skill-evaluations/eval-results.md). A new skill gets a case too: it must save effort or make the result the same every time, and a change to a skill is kept only if its case still passes in every run.

Prompts, for short, repeatable jobs where a skill would add more than it saves:

| Prompt | Use it to |
|---|---|
| [strengthen-tests-until-pit-catches-the-planted-bugs](.github/prompts/strengthen-tests-until-pit-catches-the-planted-bugs.prompt.md) | Improve tests until PIT catches the planted bugs in key code, after measurement's planted bugs show they can't be trusted |

External skills are declared in [`apm.yml`](apm.yml), pinned, and installed with `apm install` (APM, the Agent Package Manager). Run it once after cloning.

## Code standards (enforced by `./gradlew check`)
| Standard | Enforced by |
|---|---|
| Line coverage at least 80% per project (raise it with `quality.minLineCoverage`) | JaCoCo coverage verification |
| No more than **three parameters** for any method or constructor. Use a Lombok `@Builder` instead | Checkstyle `ParameterNumber`, PMD `ExcessiveParameterList` |
| No record with more than three components. Use a Lombok `@Builder` class instead of a large record | Checkstyle `RecordComponentNumber` |
| A test makes one assertion statement: one `assert...` or `assertThat` chain, or one `assertAll(...)` | PMD rule `MultipleAssertionsMustUseAssertAll` |
| Logging through Lombok `@Slf4j` (SLF4J API, Log4j 2 at run time). No `System.out`, no `java.util.logging` | forbidden-APIs check |
| Time comes from an injected `java.time.Clock`, never `now()` or `currentTimeMillis()` | forbidden-APIs check |
| No unsafe, deprecated, internal or non-portable JDK APIs, and no reflection tricks | forbidden-APIs bundled signatures |
| Methods short and simple: 20 lines or fewer (blank lines not counted), cyclomatic complexity 5 or less, cognitive complexity 6 or less, NPath complexity under 50, boolean expressions of 3 operators or fewer; files of 150 lines or fewer | Checkstyle and PMD |
| No comment on a field (name it, or say it on the class or method); Javadoc only on public API, other comments as `//` | Checkstyle |
| Advice, never failing the build: a stream or `forEach` rather than a for-each loop | PMD, in `pmdAdvice` ([why](docs/decisions/0100-all-our-java-applies-the-java-conventions-plugin-which-holds-our-code-quality-standards.md)) |
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
Never run another repo's tests or application unless its secrets scan is clean, and only where production can't be
reached (see [Old code runs first only where production cannot be reached](decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)).
Building it, or resolving its dependencies, without running tests is allowed before that
(see [A repo may be built, without running its tests, before the safety gate](docs/decisions/0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md)).
The one exception is the field trial's old releases of public repos: to check the toolkit's tools, their tests may run
without a safety inventory, and only under the airgap agent with every call to another machine refused
(see [The field trial's public repos run their tests under the airgap agent without a safety inventory first](docs/decisions/0089-the-field-trials-public-repos-run-their-tests-under-the-airgap-agent-without-a-safety-inventory-first.md)).

## Before you finish
Run `./gradlew check`. It must pass. Then commit and `git push`. On each push to `main` that changes
`plan/toolkit-backlog.yaml`, GitHub Actions brings this repo's issues up to date and refreshes `docs/BACKLOG.md`
(the [backlog sync workflow](.github/workflows/sync-backlog.yml), run by hand with `relink` to post every issue link
again; [why](docs/decisions/0101-every-repos-backlog-is-synced-to-its-issues-by-one-shared-github-actions-workflow-on-push.md)).
