---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Understanding what a system should do
---

# Current and intended behaviour are recorded side by side, and every difference is an open question

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Legacy systems often behave differently from what people believe they should do, and other systems may rely on that behaviour, bugs included. Recording only one view either hides bugs or breaks things during change.

## Considered Options

* **Both, recorded side by side and compared: approval tests pin what the system does today; a specification records what it should do. Every difference becomes an open question, which the Application Owner settles as keep the current behaviour (recorded as a known issue), fix it (the test changes deliberately, with expert sign-off), or correct the specification**  
  Nothing changes silently; every disagreement gets an owner and a decision
* **Current behaviour only**  
  Safe for change, but never tests what the system should do
* **Intended behaviour only**  
  Legacy behaviour that others rely on can break unnoticed

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option. Current behaviour comes from the code
itself, through approval tests; intended behaviour comes from the sources people name and from experts' answers. Both
are steps of the [semantic track](../docs/decisions/0092-the-journey-runs-two-tracks-syntactic-and-semantic-that-join-at-the-testing-plan.md).

### Consequences

* The specification and the approval tests are compared when the specification is drafted (the
  [elicit intended behaviour](../docs/JOURNEY.md#3-elicit-intended-behaviour) step of the journey's semantic track), and the open questions are kept
  with the specification.
* Open questions are tracked as decision items in the issue tracker.

## More Information

* Builds on: [Every repo starts with discovery: a draft external systems list, a source list and a check of its existing tests, and a first approval-test baseline follows](0032-every-repo-starts-with-discovery-a-draft-external-systems-list-a-source-list-and-a-check-of-its-existing-tests-and-a-first-approval-test-baseline-follows.md)
* Later decisions that build on this: [Progress is measured by required tests met, alongside coverage and mutation results](0014-progress-is-measured-by-required-tests-met-alongside-coverage-and-mutation-results.md), [The format for intended behaviour is chosen by piloting Gherkin and Allium side by side](../docs/decisions/0028-the-format-for-intended-behaviour-is-chosen-by-piloting-gherkin-and-allium-side-by-side.md), [Expert time is booked as a budget of short question sessions](0035-expert-time-is-booked-as-a-budget-of-short-question-sessions.md)
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code)
