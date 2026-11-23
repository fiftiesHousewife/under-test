---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Planted bugs are counted per module, in key packages proposed from the change history

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

PIT plants small bugs in the main code and counts how many the tests catch, a better guide to test strength than
coverage. On large modules it is slow. Its option to record every test that catches each bug is described by its
documentation as partially supported, with no stated cost. Code that changes often is a small share of a codebase but
takes most of the change, and the version history alone shows where it is.

## Considered Options

* **PIT's default settings, per module; all of a module's code at 200 classes or fewer, otherwise key packages proposed
  from a ranking of change frequency times size, confirmed by a person**
* **The same, with a random sample of about 1,000 planted bugs as a module-wide estimate**  
  A fuller picture, at more run time
* **The person names the key packages unaided**

## Decision Outcome

Chosen in discussion: the first option. Discovery ranks packages by how often they changed in the history times their
size, running no code; measurement proposes the top ones and the person confirms or changes them. The result says
whether it covers the whole module or key packages. PIT keeps its default of stopping at the first test that catches
each bug; the field trial tries the full record on one module of one repo, with its run time, before it is used.

### Consequences

* measure-a-repo proposes key packages from the ranking; discovery records the ranking.
* The field trial records PIT's run time per module, with and without the full record.

## More Information

* Builds on: [The journey works module by module](0060-the-journey-works-module-by-module.md), [A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build](0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md)
* Later decisions that build on this: none yet
* Background: [the research on prior art](../PRIOR-ART.md)
