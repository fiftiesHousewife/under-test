---
status: proposed
decision-makers: Toolkit maintainers
group: Recording results and owning plans
---

# Each repo's work is loaded into the issue tracker by one tool, with an adapter per tracker

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Every repo's approved testing plan becomes work items. Organisations use different trackers (for example GitHub Issues, Jira Cloud), and people want both a repeatable way to load work and help from their AI assistant while doing it.

## Considered Options

* **One tracker-neutral tool reads the plan and creates or updates items by stable key, through an adapter per tracker built on that tracker's existing API or command-line tool (for example the GitHub CLI; Jira Cloud's REST API or Atlassian's own command-line tool). An AI assistant skill wraps it: shows a dry run, asks the person, runs it, and writes the item keys back into the plan. Where the AI assistant can reach the tracker through an MCP server, the skill may use that for reading, but loading always goes through the tool**  
  Repeatable and reviewable; the AI helps but doesn't decide what is created
* **The AI assistant creates items directly through the tracker's MCP server**  
  Quick to start; not repeatable, and easy to create duplicates
* **A separate script per tracker**  
  Simple each time; logic drifts between trackers

## Decision Outcome

Proposed: the first option. The organisation profile names the tracker, its address and project; credentials come from the person's environment, never from files.

### Consequences

* The tracker-neutral loader, with GitHub and Jira Cloud adapters, is a sub-command of under-test-tools, as
  [The journey's mechanical steps are one command-line tool, with a sub-command per step, in its own repo](0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md) says.
* The load-repo-work-into-the-issue-tracker skill.

## More Information

* Builds on: [Testing plans are generated from the assessment file, and the issue tracker follows the work](../../decision-guides/0024-testing-plans-are-generated-from-the-assessment-file-and-the-issue-tracker-follows-the-work.md), [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: none yet
* Background: none
