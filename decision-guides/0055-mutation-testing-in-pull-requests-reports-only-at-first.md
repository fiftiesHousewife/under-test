---
status: proposed
decision-makers: Technical Architect
group: Rolling out
---

# Mutation testing in pull requests reports only at first

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Blocking pull requests on a new kind of check, before teams understand it, creates friction and workarounds.

## Considered Options

* **Report surviving mutants as a pull-request comment; don't block at first**  
  Teams learn first
* **Block from the start**  
  Faster change; more resistance

## Decision Outcome

Proposed: report only at first; revisit after a quarter.

### Consequences

* Convention plugin pull-request task.

## More Information

* Builds on: [What counts as evidence for each test maturity level](0013-what-counts-as-evidence-for-each-test-maturity-level.md)
* Later decisions that build on this: none yet
* Background: [mutation-testing](../docs/REFERENCES.md#mutation-testing)
