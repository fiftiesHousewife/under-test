---
status: proposed
decision-makers: Technical Architect, approved by the Security and Platform Owner
group: Using the toolkit in an organisation
---

# The build environment (proxy and package repository) comes from the organisation's own build set-up

**Decided by:** Technical Architect, approved by the Security and Platform Owner · **Status:** proposed

## Context and Problem Statement

Builds must reach packages through the organisation's proxy and package repository. Writing those into the toolkit would tie it to one organisation and leak details.

## Considered Options

* **Use the build tool's own machine-level settings: a Gradle init script or `gradle.properties` in the Gradle user home, and Maven's `settings.xml`. Organisations usually provide these already; they apply before any repo's settings and can replace its repositories. The organisation repo holds the organisation's copy or points to it**  
  No toolkit change per organisation; standard practice
* **Settings in each repo**  
  Repeated everywhere; leaks organisation details

## Decision Outcome

Proposed: the first option. Public repositories in this toolkit's own build are defaults for building it outside any organisation.

### Consequences

* An example init script in `examples/organisation-repo/`.

## More Information

* Builds on: [Build settings come in three layers: environment, code-quality standards and testing evidence](0011-build-settings-come-in-three-layers-environment-code-quality-standards-and-testing-evidence.md)
* Later decisions that build on this: none yet
* Background: none
