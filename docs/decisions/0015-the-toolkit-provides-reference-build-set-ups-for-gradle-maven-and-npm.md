---
status: rejected
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The toolkit provides reference build set-ups for Gradle, Maven and npm

**Decided by:** Toolkit maintainers · **Status:** rejected

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Teams need a ready-made way to produce the evidence and apply the standards in each build tool.

## Considered Options

* **A published Gradle convention plugin (the reference), a Maven parent POM, and an npm package, each producing the same report files and reading the same settings; published to public repositories and mirrored by organisations through their own package repository**  
  Every repo type covered; versioned and pinned
* **Gradle only**  
  Maven and TypeScript repos left out

## Decision Outcome

Rejected: overtaken by [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), by [A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build](0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md) and [A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line](0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md), which measure a repo without changing its build, and by [All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md).

### Consequences

* None: nothing is built from this record.

## More Information

* Builds on: [Testing evidence is defined by standard report files, not by one build plugin](0014-testing-evidence-is-defined-by-standard-report-files-not-by-one-build-plugin.md), [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: none yet
* Background: none
