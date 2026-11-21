---
status: proposed
decision-makers: Steering Group
group: Recording results and owning plans
---

# When the organisation requires it every commit names its work item

**Decided by:** Steering Group · **Status:** proposed

## Context and Problem Statement

Some organisations require every commit to name a work item in their tracker (for example a Jira key such as TEST-123), so every change can be traced. The toolkit must support that rule without imposing it on organisations that don't have it.

## Considered Options

* **The organisation profile says whether commits must name a work item, and the pattern a key follows. When required: AI assistant skills always include the key; a commit-message hook gives fast feedback locally; a CI check fails pull requests with commits that lack one; and, where the code-hosting platform supports it, a server-side rule blocks them**  
  Traceable where required; no burden elsewhere
* **Always require a work item in every commit**  
  Imposes one organisation's rule on everyone
* **Never check**  
  Organisations with the rule can't use the toolkit as it is

## Decision Outcome

Proposed: the first option. This toolkit only provides the switch and the checks; the rule itself is set in each organisation's overlay.

### Consequences

* `commit_messages` in the organisation profile schema.
* A commit-message check in the convention plugin and CI template, off unless the profile turns it on.
* Every skill that commits reads the profile.

## More Information

* Builds on: [The programme backlog lives in the organisation's issue tracker, not in a file](0005-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md), [Organisation-specific facts and decisions live in a private overlay repo](0004-organisation-specific-facts-and-decisions-live-in-a-private-overlay-repo.md)
* Later decisions that build on this: none yet
* Background: none
