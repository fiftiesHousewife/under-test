---
status: proposed
decision-makers: Technical Architect
group: Standing in for real systems
---

# Recorded responses and fakes live in shared test kits, not in each repo

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

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

* Each shared test kit holds the cleaning rules for its system, so every repo that records it cleans the same way;
  its owner signs off changes to them (see [Captured data is cleaned inside the environment it was captured in, before it is copied anywhere](0062-captured-data-is-cleaned-inside-the-environment-it-was-captured-in-before-it-is-copied-anywhere.md)).
* `shared-test-kits/<system-id>/` in the organisation repo, each started from [the toolkit's template](../templates/shared-test-kit.md), and a catalogue of them.

## More Information

* Builds on: [Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md)
* Later decisions that build on this: [Who owns and maintains each shared test kit](0040-who-owns-and-maintains-each-shared-test-kit.md)
* Background: [test-doubles](../docs/REFERENCES.md#test-doubles)
