---
status: proposed
decision-makers: Engagement Lead
group: Rolling out
---

# How often repos are re-scanned and re-measured

**Decided by:** Engagement Lead · **Status:** proposed

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

* Nightly workflow (the nightly re-scan).

## More Information

* Builds on: [Where measured results are stored and how each repo sees its own](0041-where-measured-results-are-stored-and-how-each-repo-sees-its-own.md)
* Later decisions that build on this: none yet
* Background: none
