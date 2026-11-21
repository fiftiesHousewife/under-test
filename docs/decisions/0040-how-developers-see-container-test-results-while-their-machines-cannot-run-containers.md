---
status: proposed
decision-makers: Technical Architect
group: Where tests run
---

# How developers see container test results while their machines cannot run containers

**Decided by:** Technical Architect · **Status:** proposed (open)

## Context and Problem Statement

Until developer machines can run containers, container test results come only from CI.

## Considered Options

* **A fast, on-demand CI run on the developer's branch**  
  Simple; slower feedback
* **Bring results into the editor or terminal**  
  Faster to read; needs integration work

## Decision Outcome

Not yet chosen. The options are below. Open.

### Consequences

* CI workflow templates.

## More Information

* Builds on: [How CI runs container tests for each kind of CI platform](0038-how-ci-runs-container-tests-for-each-kind-of-ci-platform.md), [Container tests on developer machines that have no container runtime](0039-container-tests-on-developer-machines-that-have-no-container-runtime.md)
* Later decisions that build on this: none yet
* Background: none
