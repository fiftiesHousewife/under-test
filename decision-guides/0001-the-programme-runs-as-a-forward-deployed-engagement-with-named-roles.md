---
status: proposed
decision-makers: Programme Sponsor
group: How we work
---

# The programme runs as a forward deployed engagement with named roles

**Decided by:** Programme Sponsor · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Decisions and work need named owners. Naming a client's internal bodies ties the toolkit to one organisation chart and makes it hard to reuse. Forward deployed engineering has common, recognisable roles, though no formal standard (see references).

## Considered Options

* **Roles from forward deployed engagements, with client-side governance from large-migration practice: Programme Sponsor, Engagement Lead, Forward Deployed Engineer, Technical Architect, Test Quality Lead, Security and Platform Owner, Application Owner, Toolkit Owner, and a Steering Group**  
  Recognisable to delivery teams; works for any client
* **Name the client's own bodies**  
  Familiar to one client; doesn't travel

## Decision Outcome

Proposed: the first option. What each role does and decides is in [GLOSSARY.md](../GLOSSARY.md), which has the full list of roles, including the Knowledge Curator, the Architecture Owner, the Data Protection Officer and the rest. Every decision record names the deciding role; every piece of work names an owner role.

### Consequences

* "Who decides" in every decision record uses these roles.
* Plan templates and issue labels use these roles.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Each application also has a knowledge curator and an architecture owner](0002-each-application-also-has-a-knowledge-curator-and-an-architecture-owner.md), [The programme moves through five phases, each ending with a sign-off](0003-the-programme-moves-through-five-phases-each-ending-with-a-sign-off.md), [The programme backlog lives in the organisation's issue tracker, not in a file](../docs/decisions/0009-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md), [Decision records follow MADR and are approved by pull request review](../docs/decisions/0010-decision-records-follow-madr-and-are-approved-by-pull-request-review.md)
* Background: [engagement-model](../docs/REFERENCES.md#engagement-model)
