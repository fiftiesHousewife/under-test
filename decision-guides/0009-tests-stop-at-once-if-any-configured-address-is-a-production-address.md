---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# Tests stop at once if any configured address is a production address

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A second line of defence in case a machine can reach production after all.

## Considered Options

* **Central list of production host names (from DNS zones or the configuration database), plus name patterns as a backstop**  
  Accurate; needs an owner and a feed
* **Name patterns only (e.g. `*.prod.*`)**  
  Cheap; misses hosts that don't follow the naming rule

## Decision Outcome

Proposed: a production-address check refuses to run tests if any configured address is on the central list or matches a pattern, or a production profile is active. The check is part of the convention plugin, in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)). Until then, the airgap agent refuses every call off the machine, and the never-reach addresses in the external systems list say what must never be reached.

### Consequences

* The production-address check, part of the convention plugin, in its own repo, later; until then the airgap agent
  refuses calls off the machine, and the external systems list's never-reach addresses record what must never be reached.

## More Information

* Builds on: [Old code runs first only where production cannot be reached](0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [The external systems list says what tests use for each system, and which addresses tests must never reach](0031-the-external-systems-list-says-what-tests-use-for-each-system-and-which-addresses-tests-must-never-reach.md)
* Background: none
