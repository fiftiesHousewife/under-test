---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Standing in for real systems
---

# Tests that reach external systems are tagged and left out of normal runs

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Tests that write to shared environments are a safety and data risk, not just a testing gap.

## Considered Options

* **Tag them `external` (`@Tag("external")` on JUnit 5 or 6, a JUnit 4 `@Category`), leave them out of the normal CI run, log a risk until replaced**  
  Contains the risk at once
* **Leave them running**  
  Ongoing risk

## Decision Outcome

Proposed: the first option.

### Consequences

* The convention plugin, in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)), leaves the tag out of normal runs by default. Until then, the
  [find-test-anti-patterns](../.github/skills/find-test-anti-patterns/SKILL.md) skill flags these tests as `reaches-external-system`, and
  tagging them is a change made by hand.
* Each connection's tagged tests have a schedule (daily by default), a place that can reach the system's test
  instance, and an owner, all named in the testing plan. A failure opens a work item for the owner; it never breaks a
  normal build ([why](../docs/PRIOR-ART.md#tests-that-reach-external-systems)).

## More Information

* Builds on: [Old code runs first only where production cannot be reached](0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [Whether a shared test environment can count as evidence for a limited time](0042-whether-a-shared-test-environment-can-count-as-evidence-for-a-limited-time.md)
* Background: none
