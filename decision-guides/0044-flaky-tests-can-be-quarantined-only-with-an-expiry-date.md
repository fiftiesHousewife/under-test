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

* Convention plugin task that fails on expired quarantines.

## More Information

* Builds on: [How flaky tests are found](0043-how-flaky-tests-are-found.md)
* Later decisions that build on this: none yet
* Background: [flaky-tests](../docs/REFERENCES.md#flaky-tests)
