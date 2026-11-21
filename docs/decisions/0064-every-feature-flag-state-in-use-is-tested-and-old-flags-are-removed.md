---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Test hygiene
---

# Every feature flag state in use is tested and old flags are removed

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

## Context and Problem Statement

Each flag adds a path through the code. A flag tested in only one state hides untested behaviour, and flags that are never removed multiply the paths.

## Considered Options

* **Tests cover both states of every flag in use; each flag has an owner and a removal date; expired flags fail the build**  
  Paths stay tested and few
* **Test only the default state**  
  The other state ships untested

## Decision Outcome

Proposed: the first option. Mutation testing shows where only one state of a flag is tested.

### Consequences

* A check in the convention plugin for flags past their removal date.

## More Information

* Builds on: [Feature flags are used to change legacy code safely and to release gradually](0070-feature-flags-are-used-to-change-legacy-code-safely-and-to-release-gradually.md)
* Later decisions that build on this: none yet
* Background: [feature-flags](../REFERENCES.md#feature-flags)
