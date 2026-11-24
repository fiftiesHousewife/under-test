---
status: proposed
decision-makers: Engagement Lead
group: Recording results and owning plans
---

# The assessment file: where it lives, who writes which fields, and its schema version

**Decided by:** Engagement Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Each repo needs one machine-readable record of what was measured and what people decided. 

## Considered Options

* **`testing/assessment.yaml` in each repo: skills, and the tools they run, rewrite their own sections; people's answers kept apart in `decisions`**  
  Each tool section (the safety inventory, running offline, tests, meaningless tests, unreliable tests, obstacles, techniques, the level
  reached) says which tool wrote it and at which commit, and is rewritten in full on every run. Every finding has an
  id that stays the same between runs. People's answers live only in `decisions`, keyed by section and finding id
  (`safety/db-password`, `techniques/recorded-http-responses`, `level/target`), which tools never write, so a re-run
  can't overwrite them. A decision whose finding has gone is marked stale, not deleted
* **Fields kept inline, each marked by owner**  
  One place to read each finding, but every tool must merge carefully to keep people's fields, and one mistake loses
  a decision
* **Separate files for tools and for people**  
  Nothing to merge, but two places to look, and every reader has to join them
* **Central store only**  
  Repo owners can't see or change their own decisions in a pull request

## Decision Outcome

Proposed: the first option, at schema version `assessment/1`. The AI assistant may add decisions only as `proposed`,
marked `drafted_by: ai`; a person confirms one by setting `state: decided` and `by:` to their role. The file doesn't
repeat what has its own home: stand-ins are in the external systems list and test assets in the source list, and the repo
assessment report reads all three. (The toolkit maintainers chose this in discussion; an organisation may still
narrow or replace it.)

### Consequences

* [`schema/assessment.schema.json`](../schema/assessment.schema.json), with an
  [example](../examples/assessment/assessment.yaml) checked against it.
* Every skill that writes a section, and every tool it runs, keeps its finding ids the same between runs.
* The repo assessment report renders the file, and turns edits into changes to `decisions`.

## More Information

* Builds on: [What each test maturity level means](0012-what-each-test-maturity-level-means.md)
* Later decisions that build on this: [Testing plans are generated from the assessment file, and the issue tracker follows the work](0024-testing-plans-are-generated-from-the-assessment-file-and-the-issue-tracker-follows-the-work.md), [Where measured results are stored and how each repo sees its own](0025-where-measured-results-are-stored-and-how-each-repo-sees-its-own.md), [The named list of obstacles to testing and how each is scored](0029-the-named-list-of-obstacles-to-testing-and-how-each-is-scored.md), [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](../docs/decisions/0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md)
* Background: none
