---
status: proposed
decision-makers: Steering Group
group: Standing in for real systems
---

# Who owns and maintains each shared test kit

**Decided by:** Steering Group · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A shared test kit must stay true to the real system, and serve teams across the organisation.

## Considered Options

* **The programme team owns kits by default; the system's own team can take one on; that team is a required reviewer either way**  
  Scales across boundaries; stays true to the system
* **The system's own team always owns it**  
  Knows the system; may not prioritise other teams

## Decision Outcome

Proposed: the first option.

### Consequences

* Owner field in each kit's `kit.yaml`.

## More Information

* Builds on: [Recorded responses and fakes live in shared test kits, not in each repo](0039-recorded-responses-and-fakes-live-in-shared-test-kits-not-in-each-repo.md)
* Later decisions that build on this: none yet
* Background: none
