---
status: proposed
decision-makers: Technical Architect
group: Where tests run
---

# Tests are split by what they need: local tests and container tests

**Decided by:** Technical Architect · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Developer machines have no container runtime today, but may get one (WSL2 or a successor). Naming tests by where they run would need changing later.

## Considered Options

* **Local tests need no container runtime and run anywhere; container tests live in an `integrationTest` source set and skip themselves, with a clear message, where there's no runtime**  
  Works today and automatically on developer machines later
* **Container tests run only in CI**  
  Rules out local use even when it becomes possible

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option.

### Consequences

* The convention plugin, in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)), creates both test sets and the skip rule. Until then, adding
  them is an agreed change in the "make it run on its own" workstream.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [How CI runs container tests for each kind of CI platform](0020-how-ci-runs-container-tests-for-each-kind-of-ci-platform.md), [Container tests on developer machines that have no container runtime](0021-container-tests-on-developer-machines-that-have-no-container-runtime.md), [Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md)
* Background: none
