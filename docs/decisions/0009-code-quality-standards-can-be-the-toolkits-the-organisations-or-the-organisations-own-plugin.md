---
status: proposed
decision-makers: Technical Architect
group: Using the toolkit in an organisation
---

# Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

Organisations have their own style and static-analysis rules, or their own build plugins and quality gates.

## Considered Options

* **`underTest.codeStyle`: TOOLKIT (the toolkit's rules), ORGANISATION (the toolkit's tools with the organisation's rule files), or NONE (the organisation's own plugin does it). Settable as a Gradle property, so an organisation can set it for every build from its init script**  
  Organisations keep their standards without forking
* **Fork the toolkit to change rules**  
  Forks drift from the toolkit

## Decision Outcome

Proposed: the first option.

### Consequences

* Implemented in the convention plugin.

## More Information

* Builds on: [Build settings come in three layers: environment, code-quality standards and testing evidence](0007-build-settings-come-in-three-layers-environment-code-quality-standards-and-testing-evidence.md)
* Later decisions that build on this: none yet
* Background: none
