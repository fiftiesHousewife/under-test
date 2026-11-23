---
name: measure-a-repo
description: Measure a Gradle repo's tests under the airgap agent with the toolkit's measurement init script (five runs for flaky tests, JaCoCo coverage, PIT planted bugs, the test mix) and write the tests and level sections of its testing/assessment.yaml. Use after the safety inventory, or when asked to measure a repo, find its flaky tests, or get its coverage or mutation score.
---

# Measuring a repo

Run [`measure.init.gradle`](../../../tools/measurement/measure.init.gradle)
([why](../../../docs/decisions/0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md))
and write the `tests` and `level` sections of `testing/assessment.yaml` ([schema](../../../schema/assessment.schema.json)).
Planted bugs measure the [mutation testing](../../../techniques/mutation-testing/technique.yaml) technique. Never
change the repo's build files or tests.

Never copy a secret's value (a password, key or token met in code, settings or a report) into a file you write or
your reply: point at its file and line instead
([why](../../../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

## 1. Stop unless

| Check | Otherwise |
|---|---|
| It builds with Gradle | Maven or another build tool isn't covered yet: say so and stop |
| Its Gradle is 5.6 or later | Say the measurement script needs Gradle 5.6 or later, and stop |
| The assessment file has a `safety` section, and each finding with `effect: blocks` has a decided `safety/<id>` decision | Stop; name the findings still blocking |
| Every run uses the airgap agent's `airgap.init.gradle` ([its repo](https://github.com/fiftiesHousewife/under-test-airgap)) | Stop. Only a CI runner with no route out may pass `-Dmeasure.network=blocked-by-runner` instead; **never** pass it anywhere else |
| It has a Gradle wrapper | Ask which Gradle the team uses, and use that `gradle` for `./gradlew` throughout |

The **JDK** is the one set by `org.gradle.java.home` or a toolchain in the build, else `JAVA_HOME`
(`sourceCompatibility` doesn't choose it); if older than 11, pass `-Dmeasure.java=<bin/java of a JDK 11 or later>`. If
Gradle stops at once with `Unsupported class file major version` and `airgap.agent` isn't set in `gradle.properties`,
download `io.github.fiftieshousewife.airgap:airgap-agent` from the organisation's package repository (or Maven
Central), check it against its `.sha512`, and pass `-Dairgap.agent=<the jar>`.

## 2. Run

`I` is `--init-script <airgap.init.gradle> --init-script <toolkit>/tools/measurement/measure.init.gradle`.

```bash
./gradlew clean test jacocoTestReport -Dmeasure.run=1 I   # only run 1 cleans
./gradlew test -Dmeasure.run=2 I                          # then 3, 4, 5 the same way
./gradlew measurePlantedBugs -Dmeasure.targets='<targets>' -Dmeasure.excludedTests='<left out>' I   # after step 3
```

* If a run fails to build: stop, write nothing, give the first error.
* `<targets>`: `<group>.*` for each project's `group`, comma-separated, if the main code has 200 classes or fewer
  (`.class` files without `$`). Otherwise, or with no `group`, ask which packages hold the key code. `sampled` is
  `true` only when the targets leave some main code out.
* `<left out>`: each test class with a flaky or failing test (including ones PIT would skip anyway), fully
  qualified, sorted, comma-separated; no flag if none.

## 3. Read the reports

Sum over all projects. A test is its task, class and method; name it in the reply as `<Class>.<method>`.

| Field | From | Rule |
|---|---|---|
| result | `build/under-test/runs/<n>/<task>/*.xml` | a `testcase` with `failure` or `error` failed; with `skipped`, disabled; else passed |
| `count` | run 1 | every `testcase` |
| `disabled` | run 1 | with `skipped` |
| `flaky` | five runs | passed in one or more and failed in one or more |
| `failing` | five runs | failed in all five |
| `line_coverage`, `branch_coverage` | `build/reports/jacoco/test/jacocoTestReport.xml` | `LINE`, `BRANCH` `counter` directly under `report`: covered ÷ (missed + covered) × 100 (0 when missed + covered is 0), summing over projects first |
| `planted`, `caught` | `build/under-test/planted-bugs/mutations.xml` | every `mutation`; those with status `KILLED`, `TIMED_OUT` or `MEMORY_ERROR` (not `RUN_ERROR`) |
| `mix` | run 1 | per cent of `count`, each test in exactly one: `broad` if its fully qualified class or method name contains `e2e`, `acceptance` or `system` in any case; otherwise by task, `test` (`local`) or `integrationTest` (`container`); a test in any other task is in none, and its task is named in the report |

Per cents: round half up to one decimal, dropping `.0` (`64.7`, `100`, `0`).

For each test failing in every run, give the host it tried to reach, from its failure message (one containing
`refused by the airgap agent`) or the agent's report (`build/airgap/test/calls.jsonl` or `build/airgap/calls.jsonl`),
as a host name, not an address; if neither names one, say so. Its connection needs a stand-in
([draft-the-connection-list](../draft-the-connection-list/SKILL.md)). Group flaky tests that failed in exactly the same
runs ([How flaky tests are found](../../../decision-guides/0043-how-flaky-tests-are-found.md)).

## 4. Write

Replace each section where it is; a new one goes where the schema orders it (`level` after `repo`; `tests` after
`running_offline`, else after `safety`), with no blank line between sections. Keys within each section go in the
order shown. Leave the first line and the other sections as they are. `version`: the
organisation profile's `toolkit.version` if you have it, else `unreleased`. `commit`: `git rev-parse --short HEAD` in
the measured repo, in double quotes. Quote `targets`, each `evidence` line, and any other text value starting with a digit or
containing `:` or `#`; numbers stay bare. Write every field (`0`, `false`, `[]` when empty).

```yaml
tests:
  found_by: {tool: measure-a-repo, version: unreleased, commit: "1a2b3c4"}
  framework: JUnit 4
  count: 6
  runs: 5
  flaky: 1
  failing: 1
  disabled: 1
  line_coverage: 64.7
  branch_coverage: 62.5
  planted_bugs:
    planted: 14
    caught: 5
    sampled: false
    targets: "com.example.orders.*"
    left_out: [com.example.orders.MailerTest, com.example.orders.ReminderMarkerTest]
  mix: {local: 100, container: 0, broad: 0}
level:
  found_by: {tool: measure-a-repo, version: unreleased, commit: "1a2b3c4"}
  reached: 0
  evidence:
    - "Built and ran its tests five times on Gradle 6.9.4 and JDK 11, under the airgap agent"
```

* `framework`, from the build file: `JUnit 3`, `JUnit 4`, `JUnit 5` or `TestNG`; JUnit 3 or 4 under
  `useJUnitPlatform()` adds ` on the Vintage engine`.
* `left_out`: the `<left out>` classes, same order.
* `evidence`: exactly one line, `"Built and ran its tests five times on Gradle <version from ./gradlew --version> and
  JDK <the JDK's major version: 8, 11, 17>, under the airgap agent"`, with `on a CI runner with no route out` in place of
  `under the airgap agent` there.
* `reached` ([levels](../../../decision-guides/0012-what-each-test-maturity-level-means.md)): `1` only on a CI runner
  with no route out with `flaky` and `failing` both `0`; otherwise `0`. If the existing `level.reached` is higher,
  leave the whole `level` section unchanged, still write `tests`, and say why yours differs.

## 5. Report

Briefly: the level; the counts; each flaky group by test name; each test failing every run and the host the agent
refused; coverage; planted bugs, with `sampled` and what was left out. Reports stay in `build/`, not committed.
