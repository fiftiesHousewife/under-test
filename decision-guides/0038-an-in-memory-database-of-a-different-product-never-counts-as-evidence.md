---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Standing in for real systems
---

# An in-memory database of a different product never counts as evidence

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

An in-memory database such as H2 in place of Oracle differs in SQL and locking. Tests can pass that would fail for real.

## Considered Options

* **Allowed for quick smoke tests; never counts as evidence for a maturity level**  
  Honest evidence
* **Allowed as evidence**  
  False confidence

## Decision Outcome

Proposed: the first option.

### Consequences

* Evidence rules ([What counts as evidence for each test maturity level](0013-what-counts-as-evidence-for-each-test-maturity-level.md)).

## More Information

* Builds on: [What counts as evidence for each test maturity level](0013-what-counts-as-evidence-for-each-test-maturity-level.md)
* Later decisions that build on this: none yet
* Background: [test-doubles](../docs/REFERENCES.md#test-doubles)
