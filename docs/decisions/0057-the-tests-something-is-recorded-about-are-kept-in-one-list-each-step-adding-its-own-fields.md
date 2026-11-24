---
status: accepted
decision-makers: Toolkit maintainers
group: Recording results and owning plans
---

# The tests something is recorded about are kept in one list, each step adding its own fields

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

> Narrowed by [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md), [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md), [External system replaces the word connection](0081-external-system-replaces-the-word-connection.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Steps of the journey each learn things about individual tests: discovery finds their anti-patterns and the external
systems they reach, measurement finds which are flaky, failing or left out, the connection list knows which connection
each uses, and the work sorts and treats them. Each step kept its own counts and examples, so the next one had to
search or run again to find the tests by name. Repos hold many modules of tens of thousands of lines each.

## Considered Options

* **One list, `testing/tests.yaml`, keyed by class and name, holding only tests something is recorded about, each
  skill owning its own fields**  
  Every step reads what earlier steps learned and adds its own, in any order and again, without undoing the others
* **A list per skill**  
  Each simple, but a reader has to join them to see one test, and the same tests are found several times
* **Every test in the repo, keyed by `path:line`**  
  Complete, but tens of thousands of entries saying nothing, and lines move with every edit

## Decision Outcome

Chosen in discussion: one list. `testing/tests.yaml` holds each test some step has recorded something about. A test is
identified by its fully qualified class and method, or its feature file and scenario title (and row, for an examples
row), as JUnit's and Surefire's reports name it; `path:line` is a field each step refreshes. Each skill owns its own
fields and replaces only those: find-test-anti-patterns its kinds and the hosts reached, measure-a-repo its runs,
the connection list the connection, the work its treatment. Totals stay in the assessment file. It replaces
[find-test-anti-patterns lists every test it finds, so later steps don't search again](0055-find-test-anti-patterns-lists-every-test-it-finds-so-later-steps-dont-search-again.md),
which named a file for that skill alone.

### Consequences

* `schema/anti-pattern-tests.schema.json` becomes `schema/tests.schema.json`; find-test-anti-patterns writes there.
* measure-a-repo, draft-the-connection-list and the follow-up skill for external tests add their fields.
* The testing plan names tests from it, instead of counts.

## More Information

* Builds on: [A skill finds what to read by searching, and reads only what the searches find](0054-a-skill-finds-what-to-read-by-searching-and-reads-only-what-the-searches-find.md)
* Later decisions that build on this: [Measurement leaves out external tests, varies the test order, and sorts connection errors by where they were going](0059-measurement-leaves-out-external-tests-varies-the-test-order-and-sorts-connection-errors-by-where-they-were-going.md), [Tests that reach external systems are sorted into logic, connection or both, and treated accordingly](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md), [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md), [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)
* Background: [the research on prior art](../PRIOR-ART.md)
