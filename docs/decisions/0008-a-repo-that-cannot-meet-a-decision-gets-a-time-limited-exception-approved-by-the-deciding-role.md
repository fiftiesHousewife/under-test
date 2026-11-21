---
status: proposed
decision-makers: Steering Group
group: Using the toolkit in an organisation
---

# A repo that cannot meet a decision gets a time limited exception approved by the deciding role

**Decided by:** Steering Group · **Status:** proposed

## Context and Problem Statement

Some repos genuinely can't meet a decision yet, for example a coverage target on code about to be replaced. Silently ignoring the decision, or loosening it for everyone, are both worse than a visible, temporary exception.

## Considered Options

* **An exception recorded in the repo's assessment file: which decision, why, an expiry date, and approval by the role that owns the decision at the level that made it. Expired exceptions fail the build**  
  Visible, temporary, owned
* **Repos may override decisions freely**  
  Decisions stop meaning anything
* **No exceptions**  
  Repos that can't comply stall or work around the rules

## Decision Outcome

Proposed: the first option.

### Consequences

* `exceptions` in the assessment file schema.
* A build check for expired exceptions.

## More Information

* Builds on: [Decisions cascade from toolkit to organisation to organisation units to repos and lower levels only enrich](0007-decisions-cascade-from-toolkit-to-organisation-to-organisation-units-to-repos-and-lower-levels-only-enrich.md)
* Later decisions that build on this: none yet
* Background: none
