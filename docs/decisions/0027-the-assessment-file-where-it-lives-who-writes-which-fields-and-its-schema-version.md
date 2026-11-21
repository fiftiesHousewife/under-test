---
status: proposed
decision-makers: Engagement Lead
group: Recording results and owning plans
---

# The assessment file: where it lives, who writes which fields, and its schema version

**Decided by:** Engagement Lead · **Status:** proposed

## Context and Problem Statement

Each repo needs one machine-readable record of what was measured and what people decided. 

## Considered Options

* **`testing/assessment.yaml` in each repo; tools write `measured:`; people write decision fields; schema version 1**  
  One place per repo; clear ownership of fields
* **Central store only**  
  Repo owners can't see or change their own decisions in a pull request

## Decision Outcome

Proposed: the first option, with plain field names (`measured:` not `probe:`).

### Consequences

* `schema/assessment.schema.json` and its validator (the assessment-file schema and validator).

## More Information

* Builds on: [What each test maturity level means](0017-what-each-test-maturity-level-means.md)
* Later decisions that build on this: [Testing plans are generated from the assessment file, and the issue tracker follows the work](0028-testing-plans-are-generated-from-the-assessment-file-and-the-issue-tracker-follows-the-work.md), [Where-measured results are stored and how each repo sees its own](0029-where-measured-results-are-stored-and-how-each-repo-sees-its-own.md), [The named list of obstacles to testing and how each is scored](0035-the-named-list-of-obstacles-to-testing-and-how-each-is-scored.md)
* Background: none
