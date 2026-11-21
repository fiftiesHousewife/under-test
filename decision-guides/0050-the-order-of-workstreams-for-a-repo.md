---
status: proposed
decision-makers: Engagement Lead
group: Rolling out
---

# The order of workstreams for a repo

**Decided by:** Engagement Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Some work must come before other work: you can't strengthen tests that don't run.

## Considered Options

* **Make it run on its own; fix flaky tests; record current behaviour; make code testable; test against requirements; strengthen tests; check in production. Within each, key-journey code and high-risk files first. Some overlap allowed**  
  Matches the maturity levels
* **Teams choose their own order**  
  Work that depends on earlier work stalls

## Decision Outcome

Proposed: the first option.

### Consequences

* Work-ordering tool (the work-ordering tool).

## More Information

* Builds on: [What each test maturity level means](0012-what-each-test-maturity-level-means.md)
* Later decisions that build on this: none yet
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code)
