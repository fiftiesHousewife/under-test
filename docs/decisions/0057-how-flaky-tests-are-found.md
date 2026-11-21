---
status: proposed
decision-makers: Technical Architect
group: Test hygiene
---

# How flaky tests are found

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

Flaky tests make every other measurement unreliable, including mutation testing.

## Considered Options

* **Run the suite 5 times (Gradle test-retry plugin in detection mode, or comparing JUnit results); group tests that fail together**  
  Uses existing tools; finds shared causes
* **Wait for people to report them**  
  Slow and incomplete

## Decision Outcome

Proposed: the first option. Fix groups of tests that fail together before single tests.

### Consequences

* Measurement run (the flaky-test measurement).

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Flaky tests can be quarantined only with an expiry date](0058-flaky-tests-can-be-quarantined-only-with-an-expiry-date.md)
* Background: [flaky-tests](../REFERENCES.md#flaky-tests)
