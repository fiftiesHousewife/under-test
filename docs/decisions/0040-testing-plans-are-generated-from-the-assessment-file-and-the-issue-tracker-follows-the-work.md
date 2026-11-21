---
status: proposed
decision-makers: Engagement Lead
group: Recording results and owning plans
---

# Testing plans are generated from the assessment file, and the issue tracker follows the work

**Decided by:** Engagement Lead · **Status:** proposed

## Context and Problem Statement

Each repo needs a readable plan, a list of work, and a way to keep both in step across thousands of repos without hand edits drifting.

## Considered Options

* **The assessment file is the source; `testing/TESTING-PLAN.md` is generated from it and marked "do not edit"; the Application Owner approves both in one pull request. A tool then creates or updates one parent item per repo and one child item per piece of work in the organisation's issue tracker, each with a stable key so re-runs update instead of duplicating. Scope changes only through the plan pull request; the tracker shows who is doing what and what is finished**  
  Consistent at scale; owners approve scope; progress visible
* **Tracker items are the source and the plan is written by hand**  
  Hand edits across many repos drift and can't be checked

## Decision Outcome

Proposed: the first option. A repo's own departures from its testing guides are short decision records in that repo.

### Consequences

* Plan template and plan generator.
* A tracker reconciler built on the tracker's existing API.
* A programme-level view with progress charts in the tracker.

## More Information

* Builds on: [The assessment file: where it lives, who writes which fields, and its schema version](0039-the-assessment-file-where-it-lives-who-writes-which-fields-and-its-schema-version.md), [The programme backlog lives in the organisation's issue tracker, not in a file](0009-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md)
* Later decisions that build on this: [Each repo's work is loaded into the issue tracker by one tool, with an adapter per tracker](0044-each-repos-work-is-loaded-into-the-issue-tracker-by-one-tool-with-an-adapter-per-tracker.md)
* Background: none
