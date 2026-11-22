---
status: proposed
decision-makers: Technical Architect
group: Rolling out
---

# Feature flags are used to change legacy code safely and to release gradually

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Changing untested code is risky. Running the old and new code side by side behind a flag (branch by abstraction) lets a team compare them and switch back without a release. Releasing to a few users first, behind a flag, supports checking in production.

## Considered Options

* **Use flags for risky changes to code with key user journeys, for comparing old and new code, and for gradual release of high-criticality applications; not for long-lived configuration**  
  Safer change and release; each flag is a cost until removed
* **No flags**  
  Simpler code; every change is all-or-nothing

## Decision Outcome

Proposed: the first option. Comparing old and new code behind a flag is a form of differential testing.

### Consequences

* The make-code-testable and check-in-production workstreams use flags where this applies.
* The [feature flags lesson](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/lessons/feature-flags/README.md).

## More Information

* Builds on: [Feature flags use the OpenFeature standard with the organisation's own flag product](0004-feature-flags-use-the-openfeature-standard-with-the-organisations-own-flag-product.md), [What each test maturity level means](0012-what-each-test-maturity-level-means.md)
* Later decisions that build on this: [Every feature flag state in use is tested and old flags are removed](0045-every-feature-flag-state-in-use-is-tested-and-old-flags-are-removed.md)
* Background: [feature-flags](../docs/REFERENCES.md#feature-flags)
