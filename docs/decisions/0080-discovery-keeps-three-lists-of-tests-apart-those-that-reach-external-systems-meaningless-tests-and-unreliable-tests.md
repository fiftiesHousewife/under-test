---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) counts nine kinds of problem in a
repo's existing tests, from tests that reach external systems to copied tests. The journey needs only a few of
them, for different reasons and at different steps: which tests reach a real external system (measurement leaves them
out, repair twins them), which tests mean nothing (they pass whatever the code does), and which can't be trusted to
give the same answer twice. Tests that reach external systems are also found twice: connection-paths records them on
the external systems list, and the anti-patterns skill can still search for hosts and Spring settings itself.

## Considered Options

* **Three lists, each with one owner and one kind of evidence**  
  No test is searched twice for the same question
* **One skill with three reports**  
  The same pass, but the external systems are still searched by a second skill
* **A skill per category**  
  Smaller skills, more of them to keep, and the same source read several times

## Decision Outcome

Chosen in discussion: three lists, each with one owner.

| List | Owner | Kinds | Confirmed by |
|---|---|---|---|
| Tests that reach external systems | The external systems list's skill alone, from connection-paths | each test's external systems, with its chain of calls | Measurement's one run, under the airgap agent |
| Meaningless tests | The existing-tests skill, from one pass of PMD by under-test-tools | never runs (`disabled`, `never-runs`); can't fail (`no-real-assertion`, `swallows-failures`); checks only its mocks (`mocks-everything`) | Measurement's planted bugs: a test whose target has bugs no test catches |
| Unreliable tests | The same skill, from the same pass | `sleeps`, `order-dependent` | Measurement's repeats in varied orders |

`reaches-external-system` stops being a kind of anti-pattern, and the existing-tests skill no longer searches for
hosts or reads Spring settings. `copy-pasted` is dropped: a copy means nothing about what a test checks.

### Consequences

* find-test-anti-patterns is renamed for what it now finds, writes the two lists from one pass, and loses its host
  search; the schemas for the list of tests and the assessment file change their kinds; under-test-tools'
  `anti-patterns` follows.
* Measurement reads the external systems list to leave tests out, and reports which suspects its evidence confirms.
* Repair's job is the tests that reach external systems: each becomes a pair, one injecting a stand-in, one tagged
  `external`. The meaningless and unreliable tests become work in the testing plan, not repair, which narrows
  [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md).

## More Information

* Builds on: [The tests something is recorded about are kept in one list, each step adding its own fields](0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md), [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md), [find-test-anti-patterns runs PMD with the toolkit's rules and searches only what PMD cannot read](0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md)
* Later decisions that build on this: [External system replaces the word connection](0081-external-system-replaces-the-word-connection.md)
* Background: [flaky-tests](../REFERENCES.md#flaky-tests), [mutation-testing](../REFERENCES.md#mutation-testing)
