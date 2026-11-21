---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: What "well tested" means
---

# What counts as evidence for each test maturity level

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

## Context and Problem Statement

A level is only meaningful if everyone agrees what proves it.

## Considered Options

* **Level 4 evidence: a fixed mutation score per repo**  
  Easy to game; costly across many repos
* **Level 4 evidence: no surviving mutants in key-journey code changed by each pull request**  
  How Google does it; scales

## Decision Outcome

Proposed: evidence per level comes from CI results; level 4 uses the pull-request rule. Each technique's `technique.yaml` lists the levels it can provide evidence for.

### Consequences

* `evidence_for_maturity_levels` in `schema/technique.schema.json`.

## More Information

* Builds on: [What each test maturity level means](0017-what-each-test-maturity-level-means.md)
* Later decisions that build on this: [An in-memory database of a different product never counts as evidence](0039-an-in-memory-database-of-a-different-product-never-counts-as-evidence.md), [Whether a shared test environment can count as evidence for a limited time](0043-whether-a-shared-test-environment-can-count-as-evidence-for-a-limited-time.md), [The checks an AI-written test must pass before it is kept](0048-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md), [Mutation testing in pull requests reports only at first](0057-mutation-testing-in-pull-requests-reports-only-at-first.md)
* Background: [mutation-testing](../REFERENCES.md#mutation-testing)
