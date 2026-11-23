---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The journey works module by module

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The repos the toolkit is for hold many modules, each of tens of thousands of lines. Searching, running five times and
planting bugs across a whole repo at once could take days, and a person often wants to start with one module.

## Considered Options

* **Module by module: each skill that reads or runs code asks which modules, and records which it covered**
* **The whole repo, sampled**  
  A whole picture sooner, but the sample has to be chosen and explained at every step
* **The whole repo always**

## Decision Outcome

Chosen in discussion: module by module. In a build with more than one module, each skill that reads or runs code asks
which modules (one, several or all), works only on those, and records them. Results build up module by module; the
assessment file's totals cover every module done so far, and the report says which modules each result covers.

### Consequences

* find-test-anti-patterns does this already; measure-a-repo and draft-the-connection-list follow.
* An eval case with a repo of two modules checks that a skill touches only the modules it was given.

## More Information

* Builds on: [A skill keeps each kind of repo in its own file, and reads only the ones that apply](0056-a-skill-keeps-each-kind-of-repo-in-its-own-file-and-reads-only-the-ones-that-apply.md)
* Later decisions that build on this: [Planted bugs are counted per module, in key packages proposed from the change history](0061-planted-bugs-are-counted-per-module-in-key-packages-proposed-from-the-change-history.md)
* Background: none
