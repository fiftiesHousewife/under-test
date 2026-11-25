---
name: pair-the-tests-that-reach-external-systems
description: Repair a repo's tests that reach external systems, one external system at a time, from the work orders in testing/repair-orders.json - each test becomes a pair from one set of test bodies, one run with the stand-in the external systems list chose and one tagged external - changing only test code, with each test's result recorded in its repair field in testing/tests.yaml. Use after measurement, or when asked to repair, pair or isolate a repo's tests that reach a database, service, mail server or other external system.
---

# Pairing the tests that reach external systems

**Where the toolkit's files are:** this skill's links work wherever it is: in the toolkit's own repo they are relative to it, and when APM installs the toolkit in a repo it rewrites them to the toolkit's folder under `apm_modules/`. Where a command names `<toolkit>`, that is the toolkit's root: the repo root in the toolkit itself, otherwise `"$(dirname "$(find apm_modules -path '*/.github/skills/pair-the-tests-that-reach-external-systems/SKILL.md' | head -1)")/../../.."`.

Every test that reaches an external system becomes a pair: the same test bodies run once against the stand-in the
external systems list chose, in every normal build, and once against the real system, tagged `external`, on a
schedule ([why](../../../docs/decisions/0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)).
Repair changes only test code, one external system at a time, each a branch a person reviews
([why](../../../docs/decisions/0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md)).
It reads what earlier steps wrote and searches nothing again.

## 1. Check it may start

| Check | If it fails |
|---|---|
| `testing/assessment.yaml`'s safety section has no finding with `effect: blocks` whose `safety/<id>` decision isn't `decided` | Stop: run-the-safety-inventory first. Repair runs the repo's tests |
| `testing/tests.yaml` has measurement results (some test has `measurement`) | Stop: measure-a-repo first, so what repair changes shows when it runs again |
| `testing/repair-orders.json` exists, matches [its schema](../../../schema/repair-orders.schema.json), and its `made_from` matches the facts file's `schema` and `tool_version` and tests.yaml's `found_by.draft-the-external-systems-list` | Make it again, in the repo root: `java -jar <under-test-tools.jar> repair-orders`, the jar from [under-test-tools](https://github.com/fiftiesHousewife/under-test-tools)' release (until it is published, the one its `./gradlew allInOneJar` puts in `build/libs/`). It writes only the orders, and logs `<n> orders holding <n> tests; <n> left out of any order.`; any other exit than 0 prints why: stop and say so ([why](../../../docs/decisions/0095-repair-is-directed-by-a-work-order-per-external-system-that-under-test-tools-writes.md)) |
| Every run of the repo's tests is under the airgap agent, refusing every call to another machine: `--init-script <airgap.init.gradle>` for Gradle, the agent's Maven core extension for Maven ([its repo](https://github.com/fiftiesHousewife/under-test-airgap)) | Stop |

## 2. One order at a time

Take the orders in file order. For each, make a branch `repair/<node>` from the repo's main branch, and do steps 3 to
6 on it. A person reviews the branch and opens the pull request; don't push it or open one yourself.

An order whose every test has `waits_for` gets no branch: record each test as step 6 says, and go to the next.

## 3. Convert a JUnit 3 class first

For each test class in the order whose `framework` is `junit3` (or, when it is `unknown`, that extends `TestCase`),
convert the whole class to JUnit 4 before pairing it, as its own commit
([why](../../../docs/decisions/0102-repair-converts-a-junit-3-test-class-to-junit-4-before-pairing-it.md)):
`@Test`, `@Before` and `@After` for the names and overrides, `org.junit.Assert`, no `extends TestCase`; a `suite()`
that adds each test once per value becomes `@RunWith(Parameterized.class)` with those values. Run the class's tests
before and after, under the airgap agent: the same tests must run, and the same ones pass. If they don't, undo the
commit and record every test of the class as waiting, `waits_for: no-place-to-inject`, with why in its `note`. Where
the tests fail under the airgap agent both before and after, this check shows little: also check that the same test
methods exist, with the same bodies.

## 4. Make each test class a pair

The pair's shape follows the test's framework and the repo's Java level:

| Framework (after step 3) | Java level the tests compile to | The pair |
|---|---|---|
| JUnit 5 or 6, or JUnit 4 on Java 8 or later | 8 or later | A test interface `<Class>Cases` holding the bodies and one method, `<system>()`, that gives the bodies the client or address for the system; `<Class>`, which implements it with the stand-in; `<Class>External`, `@Tag("external")`, which implements it with the real system. A JUnit 4 class is converted to JUnit 5 (JUnit 6 on Java 17 or later) only where the build already runs JUnit 5 beside 4; otherwise it takes the next row |
| JUnit 4 | below 8, or the build runs no JUnit 5 | `<Class>` becomes `@RunWith(Parameterized.class)` over a `target`: `stand-in` always, `external` only when `System.getProperty("under-test.external")` is `true` |

Keep `<Class>`'s name for the stand-in half, so the build's existing runs and reports keep it.

**Where the stand-in goes** is the test's `inject` in the order:

| `inject.where` | Put the stand-in |
|---|---|
| `field` | On the client in the field `inject.field`: where the client takes its address when it is made, the stand-in half makes it pointed at the stand-in; where it takes its address when it connects (most protocol clients), at `inject.call_at` |
| `set-up` | In the set-up method on the chain, where it makes the client |
| `test-body` | At `inject.call_at` (`inject.method` on a `inject.client_type`); with no `call_at`, where the test body makes its first call to `inject.client_type` |
| `framework-settings` | In the settings the test loads (`inject.settings`): a test-only settings file or profile pointing the framework at the stand-in |
| `not-known` | Read the test to find where it makes its client. If there is nowhere to give it one without changing production code, record it as waiting, `waits_for: no-place-to-inject` ([why](../../../docs/decisions/0064-what-repair-does-where-a-test-that-reaches-an-external-system-has-no-place-to-inject-a-stand-in.md)) |

Where the order has a `shared_chain`, one stand-in at its first call may serve every test in the order: use it when
each test reaches that call with a client the test class makes.

**The stand-in** is the order's `stand_in.approach`, from its `kit` where it names one:

| Approach | The stand-in half |
|---|---|
| `in-process-server` | Starts a server in the test's JVM on a free port of this machine before each test (or the class) and stops it after: the protocol's well-used library where one exists (an in-memory LDAP directory, GreenMail, MockFtpServer), else a small fake in the test sources. The client connects to `localhost` and that port |
| `run-in-container` | Starts the system in Testcontainers; where developers' machines can't run containers, the class is tagged `container` too |
| `recorded-responses` | Replays recorded responses for each server in `evidence.named_hosts`, from files in the test resources |
| `fake-behind-an-interface` | Implements the client's interface with a fake in the test sources |
| `contract`, `shared-test-environment`, `accept-risk` | Is the test as it is, pointed at the agreed test system; `accept-risk` needs a person's decision recorded in the list, so record the test as waiting if there is none |

What the stand-in returns for each test (the server's replies, a fake's data, a container's start-up data) is yours to
write, from what the test asserts; a person reviews it. The external half is the test as it was: same client, same
address, nothing stubbed.

## 5. Check the pair

* The stand-in half passes, every test in it, under the airgap agent, and the agent refuses no call for it.
* It passes [the checks an AI-written test must pass](../../../decision-guides/0047-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md);
  above all, it fails when the behaviour it checks is broken: change what the stand-in returns, and the test fails.
* Don't run the external half; it runs on its schedule where the real system's test instance can be reached.

A pair that fails these is undone; a JUnit 3 conversion that passed its own check stays. Its tests are recorded as
waiting: `waits_for: test-fails-on-its-own` when the stand-in works but the test body fails whatever it returns (it
would fail against the real system too), else `no-place-to-inject`; with why in each test's `note`.

**The build may leave the stand-in half out.** Where the build's test task excludes the class by name (a Surefire or
Gradle `exclude` such as `**/*FunctionalTest.java`), the pair is still made, but don't change the build: say so in each
test's `note`, for the testing plan.

## 6. Record each test

In `testing/tests.yaml`, set each ordered test's `repair` ([schema](../../../schema/tests.schema.json)): `state: paired`,
`pair` (`"<bodies>; stand-in: <classes>; external: <class or external target>"`), a `note` where step 5 asks for one,
and, once a person opens it, `pull_request`; or `state: waiting` with its `waits_for` and `note`. Write nothing else in the file. Commit it on the branch.

## 7. Report

For each order: its branch, the tests paired and those waiting, with why; and the **mechanical changes** it made, for
the toolkit's recipes ([why](../../../docs/decisions/0103-until-the-toolkits-recipes-exist-the-ai-makes-repairs-mechanical-changes-and-each-repair-says-which-a-recipe-should-make.md)):
for each, the class, which change it was (convert from JUnit 3, move the bodies into a test interface or parameterised
class, add the stand-in class, add the external class), and anything a recipe would have needed that the order didn't
say. Put the same list in each branch's last commit message, for its pull request.

Then the orders' `not_ordered` tests, by why: `may-reach` for the Architecture Owner to confirm; `missed-by-discovery`
for the airgap agent's reports to be merged into the list; `disabled` for the testing plan.

End with: "Measurement runs again on the same settings, so what repair changed shows."
