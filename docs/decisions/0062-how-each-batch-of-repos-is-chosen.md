---
status: proposed
decision-makers: Engagement Lead, with the Programme Sponsor
group: Rolling out
---

# How each batch of repos is chosen

**Decided by:** Engagement Lead, with the Programme Sponsor · **Status:** proposed

## Context and Problem Statement

Work is cheapest when it reuses testing guides and shared test kits, and most valuable on important applications.

## Considered Options

* **Each batch sits within one part of the organisation, and covers: high-criticality applications first; the most common technology stack and application type pairs; the most widely shared systems; widely used libraries whatever their place in the organisation**  
  Balances value and reuse
* **By request**  
  Uneven; misses reuse

## Decision Outcome

Proposed: the first option.

### Consequences

* `plan/batches.yaml`.

## More Information

* Builds on: [Target test maturity level for each business criticality](0025-target-test-maturity-level-for-each-business-criticality.md), [How an application's test maturity level is worked out from its repos](0027-how-an-applications-test-maturity-level-is-worked-out-from-its-repos.md), [One pilot application per common technology stack and application type pair](0061-one-pilot-application-per-common-technology-stack-and-application-type-pair.md)
* Later decisions that build on this: none yet
* Background: [engagement-model](../REFERENCES.md#engagement-model)
