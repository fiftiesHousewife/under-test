---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: What "well tested" means
---

# What each test maturity level means

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

## Context and Problem Statement

Every target, check and summary needs one shared answer to "how well tested is this repo?".

## Considered Options

* **Six levels: 0 builds reliably; 1 runs on its own (in CI, with outbound calls blocked); 2 current behaviour recorded; 3 checked against requirements; 4 tests proven to catch bugs; 5 checked in production**  
  Ordered by the evidence tests provide
* **Fewer levels**  
  Simpler, but hides real differences between repos

## Decision Outcome

Proposed: the six levels as listed. Level 1 is proved in CI, because developer machines may not be able to run containers.

### Consequences

* Level fields in the assessment file schema.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [What counts as evidence for each test maturity level](0030-what-counts-as-evidence-for-each-test-maturity-level.md), [Target test maturity level for each business criticality](0031-target-test-maturity-level-for-each-business-criticality.md), [Shared libraries target level 4, whatever the criticality of the apps using them](0032-shared-libraries-target-level-4-whatever-the-criticality-of-the-apps-using-them.md), [How an application's test maturity level is worked out from its repos](0033-how-an-applications-test-maturity-level-is-worked-out-from-its-repos.md), [Target test mix for each application type and the top-heavy phase at level 2](0034-target-test-mix-for-each-application-type-and-the-top-heavy-phase-at-level-2.md), [The assessment file: where it lives, who writes which fields, and its schema version](0039-the-assessment-file-where-it-lives-who-writes-which-fields-and-its-schema-version.md), [The order of workstreams for a repo](0064-the-order-of-workstreams-for-a-repo.md), [Feature flags are used to change legacy code safely and to release gradually](0065-feature-flags-are-used-to-change-legacy-code-safely-and-to-release-gradually.md)
* Background: [maturity-models](../REFERENCES.md#maturity-models), [legacy-code](../REFERENCES.md#legacy-code)
