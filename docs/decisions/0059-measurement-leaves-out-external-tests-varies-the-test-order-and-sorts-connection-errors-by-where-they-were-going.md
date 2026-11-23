---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Measurement leaves out external tests, varies the test order, and sorts connection errors by where they were going

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Run with everything else, a test that reaches an external system fails or flips every time its call is refused, and
pollutes the flaky and failing counts measurement exists for. Five runs in one fixed order cannot show tests that
depend on order, half the flaky tests in one large study, and catch a test that fails one time in ten only about 41%
of the time.

## Considered Options

* **Leave the external tests out by filters until they are tagged; vary the order; confirm failures; sort connection
  errors by destination; record results by name**
* **Leave out whole classes; one fixed order; count only**  
  Simpler, but drops runnable tests, misses order-dependent ones, and throws away the names

## Decision Outcome

Chosen in discussion:

* **Leaving out:** the tests the list marks external are left out method by method with filters on the command line
  (Gradle's test filter; a Surefire excludes file), changing nothing in the repo. Once the work has tagged them,
  measurement excludes the tag.
* **Order:** run 1 in the original order, run 2 reversed, runs 3 to 5 shuffled with a recorded seed. Each test that
  failed is rerun about five more times, alone and in the same order, to tell flaky, order-dependent and always-failing
  tests apart. The result is "flaky tests found in five runs", never "no flaky tests".
* **Connection errors:** a test failing with an unknown host, refused connection, connection timeout or the airgap
  agent's refusal is sorted by destination. Off the machine: external, found in measurement, not failing. `localhost`:
  needs a local service, set-up work in the plan. Either way it is recorded as something discovery's searches missed.
* **By name:** flaky, failing and left-out tests go into the list of tests with why; totals stay in the assessment file.

### Consequences

* measure-a-repo's Gradle and Maven routes, and its eval case, gain an external test, a localhost test and an
  order-dependent pair.
* Surefire runs every test when no exclude is set, so a run whose external filter is missing stops.

## More Information

* Builds on: [A repo's code first runs in measurement, which comes before capturing current behaviour and again after it](0058-a-repos-code-first-runs-in-measurement-which-comes-before-capturing-current-behaviour-and-again-after-it.md), [The tests something is recorded about are kept in one list, each step adding its own fields](0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md)
* Later decisions that build on this: none yet
* Background: [the research on prior art](../PRIOR-ART.md)
