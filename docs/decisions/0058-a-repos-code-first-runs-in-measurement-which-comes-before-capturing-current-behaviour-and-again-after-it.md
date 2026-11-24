---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A repo's code first runs in measurement, which comes before capturing current behaviour and again after it

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

> Narrowed by [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md), [A repo may be built, without running its tests, before the safety gate](0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md), [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The journey ran the tests once at the end of the safety inventory, to feed discovery with the airgap agent's reports,
and captured current behaviour before measuring. Discovery can now work from code, settings and scan reports alone,
and measurement tools need a stable suite: PIT and flaky-test detection both start from tests that pass, and AI
assistants copy the flakiness of the tests they are shown.

## Considered Options

* **Nothing runs until measurement; measure, capture, measure again**  
  Discovery decides what is safe to run; the first run measures the existing suite; the captured tests are then
  measured on the same terms, so what they add shows as a change
* **A first run straight after the safety inventory**  
  Discovery starts from observed calls, but code runs before anyone has looked at it, and only where the agent is approved
* **Capture, then measure**  
  The baseline mixes old and new tests, and new flaky tests can spoil the planted-bug count

## Decision Outcome

Chosen in discussion: the safety inventory and discovery run no code. Measurement is the first run, of the tests
discovery didn't find reaching external systems. Capturing current behaviour follows, and its approval tests get the
same checks; then measurement runs again with the same settings. The airgap agent's reports from measurement add what
discovery missed to the list of tests and the connection list.

### Consequences

* The journey page and [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md) say so.
* The connection list is drafted before any run, from settings files and earlier findings.

## More Information

* Builds on: [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [Measurement leaves out external tests, varies the test order, and sorts connection errors by where they were going](0059-measurement-leaves-out-external-tests-varies-the-test-order-and-sorts-connection-errors-by-where-they-were-going.md), [The safety inventory is a gate before the first run, and no skill ever copies a secret](0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md), [The journey runs two tracks, syntactic and semantic, that join at the testing plan](0092-the-journey-runs-two-tracks-syntactic-and-semantic-that-join-at-the-testing-plan.md)
* Background: [the research on prior art](../PRIOR-ART.md)
