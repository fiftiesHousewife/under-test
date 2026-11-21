---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# Old code runs first only where production cannot be reached

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

## Context and Problem Statement

Any old app's configuration may point at production. A developer machine on the corporate network may be able to reach it. Safety must not depend on the app being set up correctly.

## Considered Options

* **Dedicated CI runners whose outbound traffic is blocked except to the organisation's package repository**  
  Strongest; needs the platform and network teams
* **Developer machines, with care**  
  Fastest; depends on each person getting it right

## Decision Outcome

Proposed: separation by network, not by configuration. The first run of any repo happens on the dedicated runners. Developer machines come after the repo is known to be safe.

### Consequences

* runners that cannot reach production.
* The outbound-call check never runs with the network open.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Independent AI agents working unattended are a future direction only](0017-independent-ai-agents-working-unattended-are-a-future-direction-only.md), [Tests stop at once if any configured address is a production address](0020-tests-stop-at-once-if-any-configured-address-is-a-production-address.md), [How CI runs container tests for each kind of CI platform](0030-how-ci-runs-container-tests-for-each-kind-of-ci-platform.md), [Container tests on developer machines that have no container runtime](0031-container-tests-on-developer-machines-that-have-no-container-runtime.md), [The estate survey sits outside the toolkit which provides a repo classifier a survey tool can call](0040-the-estate-survey-sits-outside-the-toolkit-which-provides-a-repo-classifier-a-survey-tool-can-call.md), [Which existing tools the repo classifier combines](0042-which-existing-tools-the-repo-classifier-combines.md), [Tests that reach real shared systems are tagged and left out of normal runs](0049-tests-that-reach-real-shared-systems-are-tagged-and-left-out-of-normal-runs.md)
* Background: [production-safety](../REFERENCES.md#production-safety)
