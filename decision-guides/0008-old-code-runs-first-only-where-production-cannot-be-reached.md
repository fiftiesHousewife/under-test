---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# Old code runs first only where production cannot be reached

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Any old app's configuration may point at production. A developer machine on the corporate network may be able to reach it. Safety must not depend on the app being set up correctly. Developer machines are usually Windows laptops with no administrator rights and no container runtime, so the usual ways of cutting a machine off (containers, operating-system sandboxes, firewall rules) aren't available there.

The risk being guarded against is accidental calls from old business code, through the JDK's ordinary APIs, because its configuration says so; not code written to get past a guard.

## Considered Options

* **The first run in CI, on runners whose outbound traffic is blocked except to the organisation's package repository; every run on a developer machine under the airgap agent, which refuses and reports every risky call inside the JVM**  
  Real separation for the first run; a safety net on every machine afterwards that needs no administrator rights; the agent's report is the first draft of the repo's connection list
* **CI runners only, and developer machines once the repo is known to be safe**  
  Strongest separation, but nothing guards a developer machine if "known to be safe" was wrong, and every first look waits for CI
* **Developer machines, with care**  
  Fastest; depends on each person getting the configuration right
* **Operating-system sandboxes or containers on developer machines**  
  Real separation, but not available without administrator rights or a container runtime

## Decision Outcome

Proposed: the first option. The first run of any repo happens on the dedicated runners, separated by network. On developer machines, every build, test run and application start runs under the [airgap agent](https://github.com/fiftiesHousewife/under-test-airgap), which the convention plugin adds: it refuses every risky call (network connections, host lookups, JNDI and LDAP lookups, starting programs, loading native code, `System.exit`) as an unplugged machine would, and reports each one with the test and code that made it. The report feeds the draft connection list in discovery. Because the agent works inside the JVM, it is a safety net against accidental calls, not separation; the first run in CI stays the separation.

### Consequences

* Dedicated runners that cannot reach production, for every repo's first run.
* The airgap agent in every JVM the convention plugin starts on a developer machine, and in the build itself.
* The outbound-call check never runs with the network open.
* Repos move onto the JUnit Platform early in discovery, so the agent's report names the test behind each call (JUnit 4 tests run unchanged on its Vintage engine).

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Independent AI agents working unattended are a future direction only](0006-independent-ai-agents-working-unattended-are-a-future-direction-only.md), [Tests stop at once if any configured address is a production address](0009-tests-stop-at-once-if-any-configured-address-is-a-production-address.md), [How CI runs container tests for each kind of CI platform](0020-how-ci-runs-container-tests-for-each-kind-of-ci-platform.md), [Container tests on developer machines that have no container runtime](0021-container-tests-on-developer-machines-that-have-no-container-runtime.md), [The estate survey sits outside the toolkit, which provides a repo classifier a survey tool can call](../docs/decisions/0024-the-estate-survey-sits-outside-the-toolkit-which-provides-a-repo-classifier-a-survey-tool-can-call.md), [Which existing tools the repo classifier combines](../docs/decisions/0026-which-existing-tools-the-repo-classifier-combines.md), [Each application's connections are recorded as a CALM connection list](0030-each-applications-connections-are-recorded-as-a-calm-connection-list.md), [Tests that reach real shared systems are tagged and left out of normal runs](0041-tests-that-reach-real-shared-systems-are-tagged-and-left-out-of-normal-runs.md)
* Background: [production-safety](../docs/REFERENCES.md#production-safety); [the airgap agent's design, with every option considered for corporate machines](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/docs/design.md#options-considered); [Risky calls on developer machines are refused and reported by the airgap agent, built in its own repo](../docs/decisions/0036-risky-calls-on-developer-machines-are-refused-and-reported-by-the-airgap-agent-built-in-its-own-repo.md)
