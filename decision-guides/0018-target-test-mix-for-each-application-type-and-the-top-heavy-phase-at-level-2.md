---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: What "well tested" means
---

# Target test mix for each application type and the top-heavy phase at level 2

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

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

* The [measure-a-repo](../.github/skills/measure-a-repo/SKILL.md) skill measures the actual mix, in the assessment file's `tests.mix`.
* A lesson on the test mix, planned in [the lessons catalogue](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/lessons/CATALOGUE.md).

## More Information

* Builds on: [What each test maturity level means](0012-what-each-test-maturity-level-means.md), [The lists of technology stacks and application types](../docs/decisions/0027-the-lists-of-technology-stacks-and-application-types.md)
* Later decisions that build on this: none yet
* Background: [test-mix](../docs/REFERENCES.md#test-mix)
