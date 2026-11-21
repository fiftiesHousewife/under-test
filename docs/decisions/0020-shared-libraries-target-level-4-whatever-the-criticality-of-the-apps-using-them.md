---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: What "well tested" means
---

# Shared libraries target level 4, whatever the criticality of the apps using them

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

## Context and Problem Statement

One fix in a widely used library protects every application that uses it.

## Considered Options

* **Level 4 for any library used by other repos**  
  High payback
* **Inherit the highest criticality of the apps using it**  
  Lower target for libraries used only by low-criticality apps

## Decision Outcome

Proposed: the first option. Libraries go into early batches, ordered by how many repos use them.

### Consequences

* Batch selection (decision 0054) puts widely used libraries early.

## More Information

* Builds on: [What each test maturity level means](0017-what-each-test-maturity-level-means.md), [Target test maturity level for each business criticality](0019-target-test-maturity-level-for-each-business-criticality.md)
* Later decisions that build on this: none yet
* Background: none
