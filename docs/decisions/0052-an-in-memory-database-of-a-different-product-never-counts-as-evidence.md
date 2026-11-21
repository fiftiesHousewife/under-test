---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Standing in for real systems
---

# An in-memory database of a different product never counts as evidence

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

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

* Evidence rules (decision 0030).

## More Information

* Builds on: [What counts as evidence for each test maturity level](0030-what-counts-as-evidence-for-each-test-maturity-level.md)
* Later decisions that build on this: none yet
* Background: [test-doubles](../REFERENCES.md#test-doubles)
