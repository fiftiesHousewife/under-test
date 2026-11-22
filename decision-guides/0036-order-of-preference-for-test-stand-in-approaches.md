---
status: proposed
decision-makers: Technical Architect
group: Standing in for real systems
---

# Order of preference for test stand-in approaches

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

For each external system, someone picks how tests stand in for it.

## Considered Options

* **Take the first that fits: run it in a container; use recorded responses; agree a contract with the other team; put a fake behind an interface; use a shared test environment for now; accept the risk**  
  Consistent choices across repos
* **Choose freely per repo**  
  Inconsistent, and shared test kits can't be reused

## Decision Outcome

Proposed: the first option.

### Consequences

* `test_stand_in_approach` in technique files and assessment files.

## More Information

* Builds on: [Tests are split by what they need: local tests and container tests](0019-tests-are-split-by-what-they-need-local-tests-and-container-tests.md)
* Later decisions that build on this: [Contract tests share pacts as versioned artifacts through the package repository, without a broker](0037-contract-tests-share-pacts-as-versioned-artifacts-through-the-package-repository-without-a-broker.md), [Recorded responses and fakes live in shared test kits, not in each repo](0039-recorded-responses-and-fakes-live-in-shared-test-kits-not-in-each-repo.md)
* Background: [test-doubles](../docs/REFERENCES.md#test-doubles)
