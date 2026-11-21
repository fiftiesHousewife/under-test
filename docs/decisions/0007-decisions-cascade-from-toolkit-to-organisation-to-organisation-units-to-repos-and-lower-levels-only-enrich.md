---
status: proposed
decision-makers: Steering Group
group: Using the toolkit in an organisation
---

# Decisions cascade from toolkit to organisation to organisation units to repos, and lower levels only enrich

**Decided by:** Steering Group · **Status:** proposed (agreed in discussion)

## Context and Problem Statement

Large organisations have several levels (for example division, department, team), each with its own concerns, and then the repos themselves. Each level needs to add its own decisions without undermining the levels above, or maturity levels and safety rules stop meaning the same thing across the organisation.

## Considered Options

* **Four layers: toolkit, organisation, organisation units (nested, any depth), repo. A lower level may adopt a decision, narrow it (choose an option left open, tighten a threshold) or add a decision on something not covered above. Only the organisation may replace a toolkit guide. Units keep their decision records and settings in the organisation's organisation repo under `units/<path>/`, with code-owner rules per folder. A repo records only what is specific to it. The settings that apply to a repo are worked out top-down: thresholds take the strictest value, and choices must be within what the parent allows. A tool checks that no level contradicts the one above**  
  Each level can add what it needs; nothing below can weaken what's above; one place to check
* **Each unit has its own organisation repo**  
  More autonomy; harder to check that levels agree; more repositories to request
* **Only the organisation level makes decisions**  
  Simple; units can't record their own concerns

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option.

### Consequences

* `units/<path>/` in the example organisation repo.
* A tool that works out the settings for a repo and checks that no level contradicts the one above.
* ADOPTION.md explains the levels.

## More Information

* Builds on: [Organisation-specific facts and decisions live in a private organisation repo](0005-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md)
* Later decisions that build on this: [A repo that cannot meet a decision gets a time-limited exception approved by the deciding role](0008-a-repo-that-cannot-meet-a-decision-gets-a-time-limited-exception-approved-by-the-deciding-role.md)
* Background: none
