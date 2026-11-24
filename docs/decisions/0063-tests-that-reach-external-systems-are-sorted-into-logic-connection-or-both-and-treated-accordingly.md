---
status: superseded
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Tests that reach external systems are sorted into logic, connection or both, and treated accordingly

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Tagging tests that reach external systems and leaving them out of normal runs
([the guide](../../decision-guides/0041-tests-that-reach-external-systems-are-tagged-and-left-out-of-normal-runs.md))
keeps normal runs safe but stops testing the code they exercise. What a test is really checking decides what replaces
it. Google, Fowler and Rainsberger describe running one set of tests against both a fake and the real implementation
("contract tests"), and JUnit documents test interfaces for it. No published procedure sorts an existing suite.

## Considered Options

* **Sort each test, then treat it by its sort**  
  Logic that happens to touch a system: switch to the test double chosen for its connection. The connection itself
  (SQL, HTTP mapping, mail format): keep it real, tagged `external`. Both: one set of test bodies run twice, against
  the double in normal runs and the real system under the tag
* **Run every external test twice**  
  The external suite stays as large as today's external tests, mostly checking logic a double covers
* **A double for every test, no external suite**  
  Nothing then checks that the doubles still behave like the real systems

## Decision Outcome

Chosen in discussion: sort, then treat. The sorting is the first part of the follow-up skill, one connection at a
time, drafted by the AI from reading each test and confirmed by a person; it is recorded as the test's treatment in
the list of tests. The twin is a JUnit 5 or 6 test interface, with `@Tag("external")` on the class using the real
system, converting only the classes the skill touches (JUnit 6 where the JDK is 17 or later, JUnit 5 below); a JUnit 4
parameterised class, with the real run switched on by a system property, only where the repo must stay on JUnit 4.
Each connection's external tests run on a schedule (daily by default), where the system's test instance can be
reached, with a named owner; a failure opens a work item and never breaks a normal build.

### Consequences

* A new skill, after the connection list names each connection's tests.
* The testing plan names each connection's external tests, their schedule and owner.
* Where a test has no seam to swap, see [What repair does where a test that reaches an external system has no place to inject a stand-in](0064-what-repair-does-where-a-test-that-reaches-an-external-system-has-no-place-to-inject-a-stand-in.md), still open.

## More Information

* Builds on: [The tests something is recorded about are kept in one list, each step adding its own fields](0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md), [The toolkit calls a system a test cannot run without an external system](0062-the-toolkit-calls-a-system-a-test-cannot-run-without-an-external-system.md)
* Later decisions that build on this: [Tests that mock everything are sorted and treated with the tests that reach external systems](0065-tests-that-mock-everything-are-sorted-and-treated-with-the-tests-that-reach-external-systems.md), [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md)
* Background: [the research on prior art](../PRIOR-ART.md)
