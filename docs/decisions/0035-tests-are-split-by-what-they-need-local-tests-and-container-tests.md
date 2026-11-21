---
status: proposed
decision-makers: Technical Architect
group: Where tests run
---

# Tests are split by what they need: local tests and container tests

**Decided by:** Technical Architect · **Status:** proposed (agreed in discussion)

## Context and Problem Statement

Developer machines have no container runtime today, but may get one (WSL2 or a successor). Naming tests by where they run would need changing later.

## Considered Options

* **Local tests need no container runtime and run anywhere; container tests live in an `integrationTest` source set and skip themselves, with a clear message, where there's no runtime**  
  Works today and automatically on developer machines later
* **Container tests run only in CI**  
  Rules out local use even when it becomes possible

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option.

### Consequences

* The convention plugin creates both test sets and the skip rule.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [How CI runs container tests for each kind of CI platform](0036-how-ci-runs-container-tests-for-each-kind-of-ci-platform.md), [Container tests on developer machines that have no container runtime](0037-container-tests-on-developer-machines-that-have-no-container-runtime.md), [Order of preference for test stand-in approaches](0051-order-of-preference-for-test-stand-in-approaches.md)
* Background: none
