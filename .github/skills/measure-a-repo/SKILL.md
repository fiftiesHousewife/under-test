---
name: measure-a-repo
description: Measure a Gradle repo's tests with the toolkit's measurement init script, under the airgap agent - five runs for flaky tests, coverage with JaCoCo, planted bugs with PIT, the test mix - and write the tests and level sections of its testing/assessment.yaml. Use after the safety inventory, when asked to measure a repo, find its flaky tests, or get its coverage or mutation score.
---

# Measuring a repo

[`measure.init.gradle`](../../../tools/measurement/measure.init.gradle) adds JaCoCo, per-run test results and PIT to
any Gradle build (5.6 or later) without changing it. Your part is to run it the same way every time, read its
reports, and write the `tests` and `level` sections of `testing/assessment.yaml`
([its schema](../../../schema/assessment.schema.json)). Maven isn't covered yet: say so and stop.

## 1. Check it is safe to run

Running the build runs the repo's code. Go on only if:

* the assessment file has a `safety` section, and every finding with effect `blocks` has a decided `safety/<id>`
  decision; otherwise stop and say which findings still block;
* you will run under the airgap agent (its `airgap.init.gradle`, from
  [its repo](https://github.com/fiftiesHousewife/under-test-airgap)), or on a CI runner with no route out. The init
  script refuses to run tests otherwise; **never** pass `-Dmeasure.network=blocked-by-runner` anywhere else.

Use the repo's own Gradle wrapper and the JDK its build expects; with no wrapper, ask the person which Gradle the
team uses. If that JDK is older than 11, find a JDK 11 or later
for PIT and pass `-Dmeasure.java=<its bin/java>`.

## 2. Run it

`I` stands for `--init-script <airgap.init.gradle> --init-script <toolkit>/tools/measurement/measure.init.gradle`.

```bash
./gradlew clean test jacocoTestReport -Dmeasure.run=1 I
./gradlew test -Dmeasure.run=2 I      # and runs 3, 4 and 5 the same way
```

Only run 1 cleans: a test that leaves files behind then fails on the run after, and shows as flaky, which it is.
Run 1 also writes the coverage report. If run 1 doesn't compile, stop: write nothing, and tell the person the first
error.

Then compare the five runs (step 3) and plant bugs, leaving out every flaky or failing test class:

```bash
./gradlew measurePlantedBugs -Dmeasure.targets='<globs>' -Dmeasure.excludedTests='<flaky and failing classes>' I
```

**Targets:** the project's group, as `<group>.*`, if its main code has 200 classes or fewer. Otherwise PIT takes too
long: ask the person which packages hold the key code, plant bugs there, and mark the result `sampled`.

## 3. Read the reports

For each project in the build (sum the counts across projects):

| What | From | How |
|---|---|---|
| Each test's result in each run | `build/under-test/runs/<n>/<task>/*.xml` | Each `testcase` by class and name: failed if it has `failure` or `error`, disabled if it has `skipped`, otherwise passed |
| `count` | run 1 | every `testcase`, disabled ones included |
| `disabled` | run 1 | `testcase`s with `skipped` |
| `flaky` | all five runs | tests that passed in at least one run and failed in at least one |
| `failing` | all five runs | tests that failed in every run |
| `line_coverage`, `branch_coverage` | `build/reports/jacoco/test/jacocoTestReport.xml` | the `LINE` and `BRANCH` `counter`s directly under `report`: covered ÷ (missed + covered) × 100, to one decimal place |
| `planted_bugs` | `build/under-test/planted-bugs/mutations.xml` | `planted`: every `mutation`; `caught`: those with status `KILLED`, `TIMED_OUT` or `MEMORY_ERROR` (not `RUN_ERROR`, which is PIT failing, not a test catching the bug) |
| `mix` | the run 1 results | per cent of `count` in the `test` task (`local`), in a task named `integrationTest` (`container`), and in any task whose name has `e2e`, `acceptance` or `system` in it (`broad`) |

A test that fails with `refused by the airgap agent` in its message failed because it tried to reach something: name
the target from `build/airgap/test/calls.jsonl` or `build/airgap/calls.jsonl`. Its connection needs a stand-in (see the
draft-the-connection-list skill). Group flaky tests that failed in exactly the same runs: they likely share a cause,
so they are fixed together (see [How flaky tests are found](../../../decision-guides/0043-how-flaky-tests-are-found.md)).

## 4. Write it down

Rewrite both sections in full, leaving every other section as it is. `found_by` is `{tool: measure-a-repo, version:
"<toolkit version, or unreleased>", commit: "<short commit>"}`. The commit is the measured repo's (`git rev-parse
--short HEAD` in it), in quotes: unquoted, a commit such as `1234567` or `1e12345` is read as a number.

```yaml
tests:
  found_by: {tool: measure-a-repo, version: unreleased, commit: "1a2b3c4"}
  framework: JUnit 4             # from the build file; add the engine if it runs on the JUnit Platform, e.g. "JUnit 4 on the Vintage engine"
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

**Level** ([What each test maturity level means](../../../decision-guides/0012-what-each-test-maturity-level-means.md)):
0 when all five runs built. 1 only when the runs were on a CI runner with no route out and no test failed or was
flaky. A run on a developer's machine never shows more than 0: level 1 is proved in CI. If the existing `level` shows
more than you measured, leave it and say why yours differs.

## 5. Report

Tell the person, briefly: the level, the counts, each flaky group, each test that fails every run and why, the
coverage and planted-bug figures (with `sampled` and what was left out). The reports stay in `build/`, which isn't
committed.
