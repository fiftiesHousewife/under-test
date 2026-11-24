---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Sorting each test into logic, connection or both](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md)
asks someone to judge, test by test, what it really checks, before anything changes. The judgement is the slow part:
the AI drafts it from reading each test, a person confirms every one, and a test judged as logic loses its only run
against the real system. [Repair](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md)
needs a change it can make the same way for every such test, from what discovery already recorded.

## Considered Options

* **Every such test becomes a pair from one set of test bodies**  
  One run injects the external system's stand-in and joins the normal runs; the other is tagged `external` and runs
  against the real system on a schedule. Nothing to judge per test, and no test loses its real run
* **Sort each test into logic, connection or both, then treat it by its sort**  
  A smaller external suite, at the cost of a judgement per test confirmed by a person
* **A stand-in for every test, no external suite**  
  Nothing then checks that the stand-ins still behave like the real systems

## Decision Outcome

Chosen in discussion: every such test becomes a pair from one set of test bodies.

* **Which tests:** those the external systems list grades as reaching an external system, and those measurement's
  one run found calling one under the airgap agent
  ([Each test is graded reaches, may reach or cannot reach, from the address its own settings give](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md)).
* **The pair:** with JUnit 5 or 6, a test interface holding the bodies and two classes, one injecting the stand-in,
  the other with `@Tag("external")`, converting only the classes repair twins (JUnit 6 where the JDK is 17 or later,
  JUnit 5 below). Where the repo must stay on JUnit 4, a parameterised class whose real run is switched on by a system
  property.
* **The stand-in** is the one the external systems list chose for that system, from the shared test kit where there
  is one. It goes where connection-paths' record says: the first method each test calls, in set-up when the test gets
  there through set-up, at the calls every test reaching the system shares where one stand-in covers them all, and in
  the settings the test loads when the test starts a framework.
* **The `external` half** runs on a schedule (daily by default), where the system's test instance can be reached,
  with a named owner; a failure opens a work item and never breaks a normal build.
* **Waits, recorded as work for the testing plan:** a system whose stand-in is not yet chosen, and a test with no
  place to inject one (an address written in the code, a dependency the test can't replace), as
  [What the follow-up skill does where an external test has no seam](0064-what-repair-does-where-a-test-that-reaches-an-external-system-has-no-place-to-inject-a-stand-in.md)
  settles.

This replaces [Tests that reach external systems are sorted into logic, connection or both, and treated accordingly](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md).

### Consequences

* The external suite is as large as the repo's tests that reach external systems today; it runs on a schedule, so
  normal builds don't pay for it.
* Repair records no sort; each test's treatment in `testing/tests.yaml` is the pair it became, or what it waits for.
* A test that only checks logic still has a real run; whether to drop that half later is a choice for the testing
  plan, after the approval-test baseline exists.

## More Information

* Builds on: [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md), [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md), [Tests that reach external systems are tagged and left out of normal runs](../../decision-guides/0041-tests-that-reach-external-systems-are-tagged-and-left-out-of-normal-runs.md)
* Later decisions that build on this: [What repair does where a test that reaches an external system has no place to inject a stand-in](0064-what-repair-does-where-a-test-that-reaches-an-external-system-has-no-place-to-inject-a-stand-in.md), [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md), [Tests that mock everything are fixed in the testing plan's work, each mock sorted by what it stands for](0087-tests-that-mock-everything-are-fixed-in-the-testing-plans-work-each-mock-sorted-by-what-it-stands-for.md), [Only a system on another machine reaches out, and a test needing a service on its own machine is found by failing](0090-only-a-system-on-another-machine-reaches-out-and-a-test-needing-a-service-on-its-own-machine-is-found-by-failing.md), [Repair is directed by a work order per external system that under-test-tools writes](0095-repair-is-directed-by-a-work-order-per-external-system-that-under-test-tools-writes.md), [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md)
* Background: [the research on prior art](../PRIOR-ART.md), [test-doubles](../REFERENCES.md#test-doubles)
