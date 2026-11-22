---
status: proposed
decision-makers: Technical Architect
group: Test hygiene
---

# How flaky tests are found

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Flaky tests make every other measurement unreliable, including mutation testing.

## Considered Options

* **Run the suite in five separate runs through the measurement init script, comparing each run's JUnit results, without changing the build; group tests that fail together**  
  Uses existing tools; finds shared causes
* **Wait for people to report them**  
  Slow and incomplete

## Decision Outcome

Proposed: the first option. Fix groups of tests that fail together before single tests.

### Consequences

* The [measure-a-repo](../.github/skills/measure-a-repo/SKILL.md) skill groups tests that failed in the same runs, and leaves flaky and
  failing tests out of the planted-bug run.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Flaky tests can be quarantined only with an expiry date](0044-flaky-tests-can-be-quarantined-only-with-an-expiry-date.md)
* Background: [flaky-tests](../docs/REFERENCES.md#flaky-tests)
