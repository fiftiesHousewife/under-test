---
status: proposed
decision-makers: Engagement Lead
group: How we work
---

# The programme backlog lives in the organisation's issue tracker, not in a file

**Decided by:** Engagement Lead · **Status:** proposed

## Context and Problem Statement

A backlog kept as a hand-written file has no owners, notifications, client visibility, view of what is blocked, or way to hand over. Forward deployed practice puts agreed outcomes first, with done criteria the client signs off. Organisations already have an issue tracker, and the toolkit must work with whichever one they use.

## Considered Options

* **Use the organisation's issue tracker, named in the organisation profile (for example GitHub Issues with Projects, Jira Cloud or Data Center, Azure Boards, GitLab issues). Four kinds of item: outcome (one per success criterion agreed with the Programme Sponsor), deliverable (part of an outcome), task (part of a deliverable), decision (a question for a named role). The tracker's own parent-child and blocked-by links. Fields: phase, Now / Next / Later, value, effort, owner role**  
  Works with what the organisation has; visible to the client; nothing to hand over
* **A file in this repo**  
  No owners, notifications or dependency view; needs custom tooling
* **Require one particular tracker**  
  Simpler for the toolkit; unusable by organisations on another tracker

## Decision Outcome

Proposed: the first option. The starting list of work is kept in this repo as a seed file with a schema, and an importer loads it into the organisation's tracker using that tracker's existing command-line tool or API (for example the GitHub CLI, or the Jira REST API). After import, the tracker is the only list.

### Consequences

* `plan/backlog-seed.yaml` and its schema.
* An importer per supported tracker, built on existing tools.

## More Information

* Builds on: [The programme runs as a forward deployed engagement with named roles](0001-the-programme-runs-as-a-forward-deployed-engagement-with-named-roles.md), [The programme moves through five phases, each ending with a sign-off](0002-the-programme-moves-through-five-phases-each-ending-with-a-sign-off.md)
* Later decisions that build on this: [Decision records follow MADR and are approved by pull request review](0006-decision-records-follow-madr-and-are-approved-by-pull-request-review.md), [Testing plans are generated from the assessment file, and the issue tracker follows the work](0034-testing-plans-are-generated-from-the-assessment-file-and-the-issue-tracker-follows-the-work.md), [When the organisation requires it every commit names its work item](0039-when-the-organisation-requires-it-every-commit-names-its-work-item.md)
* Background: none
