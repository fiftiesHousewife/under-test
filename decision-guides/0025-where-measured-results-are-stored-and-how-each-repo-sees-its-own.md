---
status: proposed
decision-makers: Engagement Lead
group: Recording results and owning plans
---

# Where measured results are stored and how each repo sees its own

**Decided by:** Engagement Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Reading every repo through an API for every summary isn't workable at scale.

## Considered Options

* **A central store refreshed nightly, with a read-only copy in each repo's assessment file**  
  Workable summaries; owners see their own numbers; the store wins if they disagree
* **Repo files only**  
  Summaries need a read of every repo

## Decision Outcome

Proposed: the first option.

### Consequences

* The central results store is a shared service: it is deployed through the platform's control layers, like any
  other service, with a named owner who runs it (see [Using the toolkit inside a corporate network](../docs/CORPORATE-USE.md)). Until it exists, results stay in each repo's
  assessment file.
* Summaries by organisation unit.

## More Information

* Builds on: [The assessment file: where it lives, who writes which fields, and its schema version](0023-the-assessment-file-where-it-lives-who-writes-which-fields-and-its-schema-version.md)
* Later decisions that build on this: [How often repos are re-scanned and re-measured](0056-how-often-repos-are-re-scanned-and-re-measured.md)
* Background: none
