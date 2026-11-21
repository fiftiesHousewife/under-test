---
status: proposed
decision-makers: Technical Architect
group: Keeping production safe
---

# A test profile with dummy secrets is the default, and production profiles only work in production

**Decided by:** Technical Architect · **Status:** proposed

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

* The "make it run on its own" workstream adds the test profile first.
* Lesson: running old code safely (the lesson on running old code safely).

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: none yet
* Background: none
