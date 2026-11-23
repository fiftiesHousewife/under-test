---
status: proposed
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# What the follow-up skill does where an external test has no seam

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The run-twice treatment needs a seam: somewhere to give the test a double instead of the real system. Old tests often
open the connection inside the test or the code under test, with nothing to swap. Making a seam changes production
code. Feathers breaks dependencies before writing tests, using a short list of low-risk moves (parameterise
constructor, extract interface, sprout method, wrap method), and calls it risky work needing care.

## Considered Options

* **Stop for that test and record the refactoring as work**  
  The skill changes test code only; production code changes only in the refactoring workstream, after the
  approval-test baseline exists
* **Allow a named list of low-risk seams**  
  Feathers' moves only, each in its own commit for review, where a test can't otherwise get a double
* **Allow them only once approval tests cover the class**  
  As the second, but only with a safety net in place

## Decision Outcome

Not yet chosen. The field trial records each test the skill stops for, what seam it would need, and which of these
options would have handled it; the decision follows from that.

### Consequences

* Until decided, the skill stops and records the work (the first option), the most cautious.

## More Information

* Builds on: [Tests that reach external systems are sorted into logic, connection or both, and treated accordingly](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md)
* Later decisions that build on this: none yet
* Background: [the research on prior art](../PRIOR-ART.md)
