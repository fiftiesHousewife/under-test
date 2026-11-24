---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: What "well tested" means
---

# Progress is measured by required tests met, alongside coverage and mutation results

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Line coverage alone rewards AI-written tests that run code without checking anything.

## Considered Options

* **Each repo reports required tests met (connections with a test of the right kind; specification rules with passing tests), open questions remaining, line coverage and mutation results. Summaries by organisation unit use all four**  
  Measures what matters; hard to game with empty tests
* **Coverage and mutation only**  
  Simpler; misses whether the right things are tested
* **Required tests met only**  
  Drops a well-understood measure

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option.

### Consequences

* Fields in the assessment file schema.
* Summaries by organisation unit show all four measures.

## More Information

* Builds on: [What counts as evidence for each test maturity level](0013-what-counts-as-evidence-for-each-test-maturity-level.md), [Current and intended behaviour are recorded side by side, and every difference is an open question](0033-current-and-intended-behaviour-are-recorded-side-by-side-and-every-difference-is-an-open-question.md)
* Later decisions that build on this: none yet
* Background: none
