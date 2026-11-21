---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Standing in for real systems
---

# Tests that reach real shared systems are tagged and left out of normal runs

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

## Context and Problem Statement

Tests that write to shared environments are a safety and data risk, not just a testing gap.

## Considered Options

* **Tag them `@RealDependency`, leave them out of the normal CI run, log a risk until replaced**  
  Contains the risk at once
* **Leave them running**  
  Ongoing risk

## Decision Outcome

Proposed: the first option.

### Consequences

* The convention plugin excludes the tag by default.

## More Information

* Builds on: [Old code runs first only where production cannot be reached](0025-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [Whether a shared test environment can count as evidence for a limited time](0059-whether-a-shared-test-environment-can-count-as-evidence-for-a-limited-time.md)
* Background: none
