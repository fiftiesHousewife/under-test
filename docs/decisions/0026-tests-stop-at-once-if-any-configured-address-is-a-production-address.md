---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# Tests stop at once if any configured address is a production address

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

## Context and Problem Statement

A second line of defence in case a machine can reach production after all.

## Considered Options

* **Central list of production host names (from DNS zones or the configuration database), plus name patterns as a backstop**  
  Accurate; needs an owner and a feed
* **Name patterns only (e.g. `*.prod.*`)**  
  Cheap; misses hosts that don't follow the naming rule

## Decision Outcome

Proposed: the convention plugin refuses to run tests if any configured address is on the central list or matches a pattern, or a production profile is active.

### Consequences

* the production-address check.

## More Information

* Builds on: [Old code runs first only where production cannot be reached](0025-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [The connection list says what tests use for each connection, and which addresses tests must never reach](0052-the-connection-list-says-what-tests-use-for-each-connection-and-which-addresses-tests-must-never-reach.md)
* Background: none
