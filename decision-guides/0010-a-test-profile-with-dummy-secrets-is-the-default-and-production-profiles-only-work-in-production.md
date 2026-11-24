---
status: proposed
decision-makers: Technical Architect
group: Keeping production safe
---

# A test profile with dummy secrets is the default, and production profiles only work in production

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Many apps read configuration from a vault or production settings at start-up, so starting them anywhere is risky.

## Considered Options

* **A `test` profile with dummy secrets and a test certificate authority is the default; production profiles must be chosen deliberately and only work in production**  
  Safe by default
* **Leave defaults as they are**  
  Every start is a risk

## Decision Outcome

Proposed: the first option.

### Consequences

* The test profile is added in the [safety inventory](../docs/JOURNEY.md#2-safety-inventory-the-gate-before-the-first-run), the first step of a
  repo's journey, where the inventory's findings are made harmless in it.
* A lesson on running old code safely on your own machine, planned in [the lessons catalogue](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/lessons/CATALOGUE.md).

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: none yet
* Background: none
