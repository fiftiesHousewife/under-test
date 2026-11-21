---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Understanding what a system should do
---

# Behaviour is captured in two tracks, current and intended, and every difference is an open question

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Legacy systems often behave differently from what people believe they should do, and other systems may rely on that behaviour, bugs included. Recording only one view either hides bugs or breaks things during change.

## Considered Options

* **Two tracks, compared: approval tests pin what the system does today; a specification records what it should do. Every difference becomes an open question, which the Application Owner settles as keep the current behaviour (recorded as a known issue), fix it (the test changes deliberately, with expert sign-off), or correct the specification**  
  Nothing changes silently; every disagreement gets an owner and a decision
* **Current behaviour only**  
  Safe for change, but never tests what the system should do
* **Intended behaviour only**  
  Legacy behaviour that others rely on can break unnoticed

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option.

### Consequences

* Specification and approval-test results are compared in the testing plan.
* Open questions are tracked as decision items in the issue tracker.

## More Information

* Builds on: [Every repo starts with discovery: a draft connection list, an approval-test baseline and a source list](0032-every-repo-starts-with-discovery-a-draft-connection-list-an-approval-test-baseline-and-a-source-list.md)
* Later decisions that build on this: [Progress is measured by required tests met, alongside coverage and mutation results](0014-progress-is-measured-by-required-tests-met-alongside-coverage-and-mutation-results.md), [The format for intended behaviour is chosen by piloting Gherkin and Allium side by side](../docs/decisions/0028-the-format-for-intended-behaviour-is-chosen-by-piloting-gherkin-and-allium-side-by-side.md), [Expert time is booked as a budget of short question sessions](0035-expert-time-is-booked-as-a-budget-of-short-question-sessions.md)
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code)
