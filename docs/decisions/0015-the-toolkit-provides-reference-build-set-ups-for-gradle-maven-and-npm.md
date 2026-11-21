---
status: proposed
decision-makers: Technical Architect
group: Using the toolkit in an organisation
---

# The toolkit provides reference build set-ups for Gradle, Maven and npm

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

Teams need a ready-made way to produce the evidence and apply the standards in each build tool.

## Considered Options

* **A published Gradle convention plugin (the reference), a Maven parent POM, and an npm package, each producing the same report files and reading the same settings; published to public repositories and mirrored by organisations through their own package repository**  
  Every repo type covered; versioned and pinned
* **Gradle only**  
  Maven and TypeScript repos left out

## Decision Outcome

Proposed: the first option, starting with Gradle.

### Consequences

* Publish the convention plugin as a versioned artifact.
* Maven parent POM and npm package as later work.

## More Information

* Builds on: [Testing evidence is defined by standard report files, not by one build plugin](0014-testing-evidence-is-defined-by-standard-report-files-not-by-one-build-plugin.md), [We reuse existing tools before building new ones](0020-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: none yet
* Background: none
