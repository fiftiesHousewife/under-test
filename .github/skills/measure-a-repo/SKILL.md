---
name: measure-a-repo
description: Measure a Gradle repo's tests under the airgap agent, in stages that each gate the next (build; one run with the tests that reach external systems left out; four repeats in varied orders; planted bugs), with the toolkit's measurement init script; record each test's outcome in testing/tests.yaml and the totals in the tests and level sections of testing/assessment.yaml. Use after the safety inventory, or when asked to measure a repo, find its flaky tests, or get its coverage or mutation score.
---

# Measuring a repo

**Where the toolkit's files are:** this skill's links are relative to its folder in the toolkit, `.github/skills/measure-a-repo/`. In the toolkit's own repo, follow them as they are. In a repo that installed the toolkit with APM, this skill is a copy, so read each link from the toolkit's package folder instead: `TOOLKIT="$(dirname "$(find apm_modules -path '*/.github/skills/measure-a-repo/SKILL.md' | head -1)")/../../.."`, then `$TOOLKIT/<the link without its ../../../>`.

Run [`measure.init.gradle`](../../../tools/measurement/measure.init.gradle)
([why](../../../docs/decisions/0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md))
in four stages, each gating the next
([why](../../../docs/decisions/0070-measurement-runs-in-stages-each-gating-the-next-build-one-run-repeats-then-planted-bugs.md)).
Each stage writes what it learned before the next starts, so a repo that stops after any stage still has a result:
each test's outcome in `testing/tests.yaml` ([schema](../../../schema/tests.schema.json)), in `measurement`, the only
field this skill owns there; the totals in the `tests` and `level` sections of `testing/assessment.yaml`
([schema](../../../schema/assessment.schema.json)). Planted bugs measure the
[mutation testing](../../../techniques/mutation-testing/technique.yaml) technique. Never change the repo's build
files or tests.

Never copy a secret's value (a password, key or token met in code, settings or a report) into a file you write or
your reply: point at its file and line instead
([why](../../../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

## 1. Stop unless

| Check | Otherwise |
|---|---|
| It builds with Gradle | Maven or another build tool isn't covered yet: say so and stop |
| Its Gradle is 5.6 or later | Say the measurement script needs Gradle 5.6 or later, and stop |
| The assessment file has a `safety` section, and each finding with `effect: blocks` has a decided `safety/<id>` decision | Stop; name the findings still blocking |
| `testing/tests.yaml` has `found_by.draft-the-external-systems-list`, from discovery | Stop: run [draft-the-external-systems-list](../draft-the-external-systems-list/SKILL.md) first, so the tests that reach external systems can be left out |
| Every run uses the airgap agent's `airgap.init.gradle` ([its repo](https://github.com/fiftiesHousewife/under-test-airgap)) | Stop. Only a CI runner with no route out may pass `-Dmeasure.network=blocked-by-runner` instead; **never** pass it anywhere else |
| It has a Gradle wrapper | Ask which Gradle the team uses, and use that `gradle` for `./gradlew` throughout |

The **JDK** is the one set by `org.gradle.java.home` or a toolchain in the build, else `JAVA_HOME`
(`sourceCompatibility` doesn't choose it); if older than 11, pass `-Dmeasure.java=<bin/java of a JDK 11 or later>`. If
Gradle stops at once with `Unsupported class file major version` and `airgap.agent` isn't set in `gradle.properties`,
download `io.github.fiftieshousewife.airgap:airgap-agent` from the organisation's package repository (or Maven
Central), check it against its `.sha512`, and pass `-Dairgap.agent=<the jar>`.

`I` is `--init-script <airgap.init.gradle> --init-script <toolkit>/tools/measurement/measure.init.gradle`, and
`L` is `-Dmeasure.leaveOut=build/under-test/leave-out.txt`. If a run fails to build: stop, write nothing more, give the
first error. A test is its task, class and method; name it in the reply as `<Class>.<method>`.

## 2. Build

```bash
./gradlew clean testClasses I
```

It compiles the code and tests and runs none. If it fails, stop: the build is fixed first. Write `tests` with
`found_by`, `stage: build` and `framework`.

## 3. One run

Write `build/under-test/leave-out.txt`: one line per test in `testing/tests.yaml` with an `external_systems` entry
graded `reaches`, as `<fully qualified class>.<method>`, sorted; an empty file when there are none
([why](../../../docs/decisions/0059-measurement-leaves-out-external-tests-varies-the-test-order-and-sorts-connection-errors-by-where-they-were-going.md)).
The init script stops the run if the file is missing, so a test meant to be left out never runs by mistake.

```bash
./gradlew test jacocoTestReport -Dmeasure.run=1 L I
```

Read `build/under-test/runs/1/<task>/*.xml`: a `testcase` with `failure` or `error` failed; with `skipped`, it is
disabled; else it passed. Read the airgap agent's calls in `build/under-test/runs/1/<task>/calls.jsonl`, one JSON
object a line, each naming its `test`, `target` and `outcome`; only lines with `outcome: refused` count. The agent
always allows the machine itself, so each refused call is a call off the machine; a test that needs a service on its
own machine that isn't running just fails
([why](../../../docs/decisions/0090-only-a-system-on-another-machine-reaches-out-and-a-test-needing-a-service-on-its-own-machine-is-found-by-failing.md)).
This file is run 1's whole report, and the one to hand to
[draft-the-external-systems-list](../draft-the-external-systems-list/SKILL.md) afterwards: the init script deletes
`build/airgap/<task>/calls.jsonl` at the start of every run it keeps, so that file ends holding only the last run's
calls.

* **A test graded `may-reach`** is confirmed when it called off the machine, and cleared when it didn't.
* **A test that called off the machine** with no `external_systems` entry graded `reaches` or `may-reach` was missed by
  discovery's searches: record it (`missed_by_discovery`), and say so.
* **A shared start-up:** when five or more tests, or a fifth of them, failed with a refused call to the same target,
  something they all start (a Spring context, a static set-up) reaches it. Stop after writing this stage: the
  external systems list needs a stand-in for that target, and this stage runs once again after it is added. This is
  the only place measurement loops.

Write `stage: one-run`, `count` (the `testcase`s of run 1), `disabled`, `left_out` (the lines of the leave-out file),
`line_coverage`, `branch_coverage` and `mix`.

## 4. Repeats

Add every test that failed in run 1 to the leave-out file, then run four more times. With JUnit 5 or 6, each in a
random order from a seed (run 2 seed 2, run 3 seed 3, and so on); JUnit 4 tests keep their order, and the task says
so.

```bash
./gradlew test -Dmeasure.run=2 -Dmeasure.order.seed=2 L I     # then 3, 4 and 5 the same way
```

Rerun each test that failed in any run, alone, five times, keeping each rerun's results apart
([How flaky tests are found](../../../decision-guides/0043-how-flaky-tests-are-found.md)):

```bash
./gradlew test --tests '<Class>.<method>' -Dmeasure.run=<test>-<k> I    # k = 1 to 5, without L
```

| Outcome | When |
|---|---|
| `failed-every-run` | it failed in run 1 and in every rerun |
| `flaky` | it passed and failed with nothing changed: in runs, or in reruns alone |
| `order-dependent` | it failed in a run in another order, and passed in every rerun alone |
| `passed` | it passed in every run |

Write `stage: repeats`, `runs: 5`, `flaky` (flaky and order-dependent tests), `failing` (failed every run) and
`order_seeds` (`[2, 3, 4, 5]`, or `[]` when no test task runs on JUnit 5 or 6).

## 5. Planted bugs

```bash
./gradlew measurePlantedBugs -Dmeasure.targets='<targets>' -Dmeasure.excludedTests='<left out>' I
```

* `<targets>`: `<group>.*` for each project's `group`, comma-separated, if the main code has 200 classes or fewer
  (`.class` files without `$`). Otherwise, or with no `group`, ask which packages hold the key code. `sampled` is
  `true` only when the targets leave some main code out.
* `<left out>`: each test class with a test that didn't pass every run, or was left out, fully qualified, sorted,
  comma-separated; no flag if none.

`planted` is every `mutation` in `build/under-test/planted-bugs/mutations.xml`; `caught`, those with status `KILLED`,
`TIMED_OUT` or `MEMORY_ERROR` (not `RUN_ERROR`). Write `stage: planted-bugs` and `planted_bugs`.

## 6. What each stage writes

**In `testing/tests.yaml`**, a `measurement` for every test that already has an entry, and for every test that didn't
pass every run, was left out, or was refused a call; never touch another skill's keys, and add an entry (`test`, `at` as
`"path:line"` of its method) for a test that has none. Set `found_by.measure-a-repo` (`version`, `commit`). Keys in
this order:

* `outcome`: from the table, or `disabled`, or `left-out`;
* `runs`: each run in order, `P` passed, `F` failed, `S` skipped, `-` not run; `reruns` for a test rerun alone;
* `left_out_because`: for `left-out`, `"graded reaches <node>"`;
* `called`: each `target` of its report lines with `outcome: refused`, distinct, sorted;
* `missed_by_discovery: true` where the rule in step 3 says.

```yaml
  - test: "com.example.orders.MailerTest.sendsTheConfirmation"
    at: "src/test/java/com/example/orders/MailerTest.java:12"
    measurement:
      outcome: failed-every-run
      runs: "F----"
      reruns: "FFFFF"
      called: ["mail.orders.invalid:25"]
      missed_by_discovery: true
```

**In `testing/assessment.yaml`**, the `tests` and `level` sections. Replace each where it is; a new one goes where the
schema orders it (`level` after `repo`; `tests` after `running_offline`, else after `safety`), with no blank line
between sections. Keys in the order shown. Leave the first line and the other sections as they are. `version`: the
organisation profile's `toolkit.version` if you have it, else `unreleased`. `commit`: `git rev-parse --short HEAD` in
the measured repo, in double quotes. Quote `targets`, each `evidence` line, and any other text value starting with a
digit or containing `:` or `#`; numbers stay bare. A stage writes its fields and keeps the earlier stages'.

```yaml
tests:
  found_by: {tool: measure-a-repo, version: unreleased, commit: "1a2b3c4"}
  stage: planted-bugs
  framework: JUnit 4
  count: 6
  runs: 5
  flaky: 1
  failing: 1
  disabled: 1
  left_out: 0
  order_seeds: []
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
* `line_coverage`, `branch_coverage`: from `build/reports/jacoco/test/jacocoTestReport.xml`, the `LINE` and `BRANCH`
  `counter` directly under `report`: covered ÷ (missed + covered) × 100 (0 when missed + covered is 0), summing over
  projects first.
* `mix`: per cent of `count`, each test in exactly one: `broad` if its fully qualified class or method name contains
  `e2e`, `acceptance` or `system` in any case; otherwise by task, `test` (`local`) or `integrationTest` (`container`);
  a test in any other task is in none, and its task is named in the report.
* Per cents: round half up to one decimal, dropping `.0` (`64.7`, `100`, `0`).
* `evidence`: exactly one line, `"Built and ran its tests five times on Gradle <version from ./gradlew --version> and
  JDK <the JDK's major version: 8, 11, 17>, under the airgap agent"`, with `on a CI runner with no route out` in place of
  `under the airgap agent` there.
* `reached` ([levels](../../../decision-guides/0012-what-each-test-maturity-level-means.md)): `1` only on a CI runner
  with no route out with `flaky` and `failing` both `0`; otherwise `0`. If the existing `level.reached` is higher,
  leave the whole `level` section unchanged, still write `tests`, and say why yours differs.

## 7. Report

Briefly: the stage reached and, if it stopped, why; the level; the counts; the tests left out and why; each test that
may reach an external system, confirmed or cleared; each call discovery missed; each flaky or order-dependent test by
name, grouped by the runs it failed in; each test failing every run and what the agent refused it; coverage; planted
bugs, with `sampled` and what was left out. Reports stay in `build/`, not committed.
