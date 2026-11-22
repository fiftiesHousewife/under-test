---
status: proposed
decision-makers: Technical Architect
group: Test hygiene
---

# Flaky tests can be quarantined only with an expiry date

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Quarantine without an end date becomes permanent deletion by another name.

## Considered Options

* **Quarantine only with an expiry date; the workstream is finished when the suite passes 5 runs in a row**  
  Keeps pressure to fix
* **Quarantine freely**  
  Tests silently disappear

## Decision Outcome

Proposed: the first option.

### Consequences

* A task in the convention plugin, in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)), that fails on expired quarantines. Until then, each
  quarantine's expiry is kept as a time-limited exception (see [A repo that cannot meet a decision gets a time-limited exception approved by the deciding role](../docs/decisions/0008-a-repo-that-cannot-meet-a-decision-gets-a-time-limited-exception-approved-by-the-deciding-role.md)).

## More Information

* Builds on: [How flaky tests are found](0043-how-flaky-tests-are-found.md)
* Later decisions that build on this: none yet
* Background: [flaky-tests](../docs/REFERENCES.md#flaky-tests)
