---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: What "well tested" means
---

# Target test mix for each application type and the top-heavy phase at level 2

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

## Context and Problem Statement

The testing pyramid (many unit tests, fewer integration tests, few end-to-end tests) is widely known. Legacy code starts top-heavy, and level 2 deliberately adds broad tests at the edges.

## Considered Options

* **Testing guides state a target mix; the measurement run records the actual mix; broad edge tests are expected at level 2; the mix moves toward the target from level 3; not a requirement for any level**  
  Explains the journey without a gameable rule
* **Make the mix a requirement for a level**  
  Counting tests by kind is easy to game

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option.

### Consequences

* Test mix measured in the measurement run (the coverage and test-mix measurement).
* Lesson: the testing pyramid.

## More Information

* Builds on: [What each test maturity level means](0029-what-each-test-maturity-level-means.md), [The lists of technology stacks and application types](0049-the-lists-of-technology-stacks-and-application-types.md)
* Later decisions that build on this: none yet
* Background: [test-mix](../REFERENCES.md#test-mix)
