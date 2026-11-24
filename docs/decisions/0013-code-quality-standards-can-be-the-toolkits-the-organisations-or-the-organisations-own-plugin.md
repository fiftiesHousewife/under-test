---
status: proposed
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

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

* Implemented in the java-conventions plugin of [All our Java applies the java-conventions plugin, which holds our code-quality standards](0100-all-our-java-applies-the-java-conventions-plugin-which-holds-our-code-quality-standards.md).

## More Information

* Builds on: [Build settings come in three layers: environment, code-quality standards and testing evidence](0011-build-settings-come-in-three-layers-environment-code-quality-standards-and-testing-evidence.md)
* Later decisions that build on this: [All our Java applies the java-conventions plugin, which holds our code-quality standards](0100-all-our-java-applies-the-java-conventions-plugin-which-holds-our-code-quality-standards.md)
* Background: none
