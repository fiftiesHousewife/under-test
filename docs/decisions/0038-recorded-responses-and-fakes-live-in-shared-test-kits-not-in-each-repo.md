---
status: proposed
decision-makers: Technical Architect
group: Standing in for real systems
---

# Recorded responses and fakes live in shared test kits, not in each repo

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

Many repos use the same systems. Recording and faking them once saves work and keeps them consistent.

## Considered Options

* **One shared test kit per widely shared system, with a part for local tests and a part for container tests, versioned and published**  
  Reuse across the organisation
* **Each repo keeps its own**  
  Duplicated effort; drift

## Decision Outcome

Proposed: the first option.

### Consequences

* `shared-test-kits/<system-id>/` and the catalogue (the shared test kits and their catalogue).

## More Information

* Builds on: [Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md)
* Later decisions that build on this: [Who owns and maintains each shared test kit](0039-who-owns-and-maintains-each-shared-test-kit.md)
* Background: [test-doubles](../REFERENCES.md#test-doubles)
