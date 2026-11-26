---
status: proposed
decision-makers: Engagement Lead
group: Rolling out
---

# How often repos are re-scanned and re-measured

**Decided by:** Engagement Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Results go stale as code changes; measuring is expensive.

## Considered Options

* **Re-scan changed repos nightly; re-measure repos in the current batch monthly and when a workstream finishes**  
  Current where it matters; affordable
* **Re-measure everything nightly**  
  Very costly

## Decision Outcome

Proposed: the first option.

### Consequences

* A CI template re-runs the secrets scan and the inventory rules on changed repos. Re-measuring means a person runs
  the [measure-a-repo](../.github/skills/measure-a-repo/SKILL.md) skill, or CI runs the [measurement init script](../tools/measurement/measure.init.gradle) on a runner with no
  route out.

## More Information

* Builds on: [Where measured results are stored and how each repo sees its own](0025-where-measured-results-are-stored-and-how-each-repo-sees-its-own.md)
* Later decisions that build on this: [From the first piece of work, no change may lower a repo's measured results](0068-from-the-first-piece-of-work-no-change-may-lower-a-repos-measured-results.md)
* Background: none
