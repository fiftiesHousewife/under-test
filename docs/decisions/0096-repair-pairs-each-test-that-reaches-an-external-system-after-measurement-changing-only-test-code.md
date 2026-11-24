---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Repair pairs each test that reaches an external system, after measurement, changing only test code

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md)
gave repair every kind of problem discovery and measurement find, and had it sort each test that reaches an external
system into logic, connection or both. Later records changed most of that:
[discovery's three lists](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)
send the meaningless and unreliable tests to the testing plan,
[every test that reaches an external system becomes a pair](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)
with no sort, [tests that mock everything are fixed in the testing plan's work](0087-tests-that-mock-everything-are-fixed-in-the-testing-plans-work-each-mock-sorted-by-what-it-stands-for.md),
and [work orders](0095-repair-is-directed-by-a-work-order-per-external-system-that-under-test-tools-writes.md) direct
it. What repair does now has to be pieced together from five records.

## Considered Options

* **One record for repair as it now is**  
  Repair pairs the tests that reach external systems, and nothing else
* **Keep the earlier record, narrowed by the later ones**  
  No new record, but a reader still pieces repair together from several

## Decision Outcome

Chosen in discussion: repair is its own step after measurement, on the
[syntactic track](0092-the-journey-runs-two-tracks-syntactic-and-semantic-that-join-at-the-testing-plan.md), and
changes only test code.

* **Its job** is to pair each test that reaches an external system, as
  [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)
  says, with the recipes
  [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md)
  names, directed by
  [the work orders](0095-repair-is-directed-by-a-work-order-per-external-system-that-under-test-tools-writes.md),
  one external system at a time, each change a pull request a person reviews.
* **Meaningless and unreliable tests** are the testing plan's work, not repair's
  ([Discovery keeps three lists of tests apart](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md),
  [Tests that mock everything are fixed in the testing plan's work](0087-tests-that-mock-everything-are-fixed-in-the-testing-plans-work-each-mock-sorted-by-what-it-stands-for.md)).
* **Recorded against the test for the plan**, in its `repair` field in `testing/tests.yaml`: whatever needs
  production code changed, a test deleted (never before the approval-test baseline, by
  [the guide on meaningless and unreliable tests](../../decision-guides/0059-meaningless-and-unreliable-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)),
  or an Application Owner's decision, such as a disabled test, and any change a person turns down.

A repaired test is kept only if it passes
[the checks an AI-written test must pass](../../decision-guides/0047-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md).
Measurement then runs again on the same settings, so what repair changed shows as a change.

This replaces [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md).

### Consequences

* The [journey page](../JOURNEY.md)'s repair step describes only the pairing.
* The repair skill reads the work orders and writes the `repair` field; its eval case is a repo with tests that reach
  external systems.
* measure-a-repo runs again after repair, with the same settings.

## More Information

* Builds on: [The journey runs two tracks, syntactic and semantic, that join at the testing plan](0092-the-journey-runs-two-tracks-syntactic-and-semantic-that-join-at-the-testing-plan.md), [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md), [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md), [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md), [Repair is directed by a work order per external system that under-test-tools writes](0095-repair-is-directed-by-a-work-order-per-external-system-that-under-test-tools-writes.md)
* Later decisions that build on this: [What repair does where a test that reaches an external system has no place to inject a stand-in](0064-what-repair-does-where-a-test-that-reaches-an-external-system-has-no-place-to-inject-a-stand-in.md), [The journey runs two tracks, syntactic and semantic, that join at the testing plan](0092-the-journey-runs-two-tracks-syntactic-and-semantic-that-join-at-the-testing-plan.md)
* Background: [legacy-code](../REFERENCES.md#legacy-code), [test-doubles](../REFERENCES.md#test-doubles)
