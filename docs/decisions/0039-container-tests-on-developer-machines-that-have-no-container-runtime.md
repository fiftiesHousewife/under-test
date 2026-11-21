---
status: proposed
decision-makers: Technical Architect, approved by the Security and Platform Owner
group: Where tests run
---

# Container tests on developer machines that have no container runtime

**Decided by:** Technical Architect, approved by the Security and Platform Owner · **Status:** proposed

## Context and Problem Statement

Some organisations' developer machines have no container runtime (for example Windows with WSL2 disabled), and that can change. The organisation profile records whether a runtime is available.

## Considered Options

* **Wait until a runtime is available; container tests skip themselves until then**  
  Nothing to do; feedback on container tests comes from CI
* **A remote container host developers connect to**  
  Container tests locally sooner; a security decision
* **Cloud development environments**  
  Container tests locally sooner; more cost and set-up

## Decision Outcome

Proposed: the skip rule covers this by default. An organisation that wants local container tests sooner records its choice in its own decision record.

### Consequences

* None now; the skip rule covers it.

## More Information

* Builds on: [Old code runs first only where production cannot be reached](0027-old-code-runs-first-only-where-production-cannot-be-reached.md), [Tests are split by what they need: local tests and container tests](0037-tests-are-split-by-what-they-need-local-tests-and-container-tests.md)
* Later decisions that build on this: [How developers see container test results while their machines cannot run containers](0040-how-developers-see-container-test-results-while-their-machines-cannot-run-containers.md)
* Background: none
