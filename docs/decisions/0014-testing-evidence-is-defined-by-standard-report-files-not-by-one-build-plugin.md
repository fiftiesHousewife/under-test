---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Using the toolkit in an organisation
---

# Testing evidence is defined by standard report files, not by one build plugin

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

## Context and Problem Statement

Repos use Gradle, Maven and npm. Evidence must be comparable whichever build tool produced it.

## Considered Options

* **The programme's tools read only standard report files (JaCoCo XML, PIT XML, JUnit XML, SARIF) and the assessment file. Any build that produces them, configured as the toolkit describes, provides valid evidence**  
  Works across build tools; tools stay simple
* **Evidence only from the toolkit's Gradle plugin**  
  Maven and npm repos can't take part

## Decision Outcome

Proposed: the first option.

### Consequences

* The assessment-file tools read report files, not build internals.

## More Information

* Builds on: [Build settings come in three layers: environment, code-quality standards and testing evidence](0011-build-settings-come-in-three-layers-environment-code-quality-standards-and-testing-evidence.md), [What counts as evidence for each test maturity level](0030-what-counts-as-evidence-for-each-test-maturity-level.md)
* Later decisions that build on this: [The toolkit provides reference build set-ups for Gradle, Maven and npm](0015-the-toolkit-provides-reference-build-set-ups-for-gradle-maven-and-npm.md)
* Background: none
