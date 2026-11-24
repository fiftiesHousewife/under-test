---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# Getting the classpath is under-test-external-calls' job, and the toolkit carries no copy of its steps

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

under-test-external-calls needs the jars a module's tests compile against. Its repo documents how to get them from
the build and ships a Gradle init script for it, and the external systems list skill carried its own copy of the
script and the Maven command. The two copies drifted, and old builds need their own workarounds (a target Java
version the JDK no longer compiles for, a check plugin with nothing to check against, an old plugin version that
isn't downloaded), which then belong in one place.

## Considered Options

* **The tool's repo owns the classpath step; the skill follows its instructions**
* **The skill keeps its own copy**  
  Usable without reading another repo, but two copies to keep the same

## Decision Outcome

Chosen in discussion: getting the classpath is under-test-external-calls' job. Its repo documents the step for Maven
and Gradle, ships the Gradle init script, and records the workarounds old builds need. The external systems list
skill and the check of discovery follow those instructions and carry no copy.

### Consequences

* The skill's own Gradle init script is removed; the skill links to the tool's instructions.
* When the tool takes over the step itself, the skill only runs the tool.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)
* Later decisions that build on this: none yet
* Background: none
