---
status: superseded
decision-makers: Toolkit maintainers
group: How we work
---

# The quality plugin may pull Gradle plugins from the Gradle Plugin Portal

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [All our Java applies the java-conventions plugin, which holds our code-quality standards](0100-all-our-java-applies-the-java-conventions-plugin-which-holds-our-code-quality-standards.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md)
publishes the plugin to Maven Central. Three Gradle plugins our conventions apply are not there: SpotBugs' Gradle
plugin (`com.github.spotbugs.snom`), the dependency-versions report (`io.github.ben-manes`), and PIT's Gradle plugin
after 1.15.0 (`info.solidsoft.gradle.pitest`); they are on the Gradle Plugin Portal only. The forbidden-APIs, nmcp
and CycloneDX plugins are on Maven Central.

## Considered Options

* **Allow the Gradle Plugin Portal for the plugin's own dependencies**  
  The three stay as they are; a repo applying the plugin resolves plugins from the Portal as well as Maven Central
* **Maven Central only**  
  SpotBugs through its command line, PIT out of the plugin, the versions report replaced
* **Maven Central only, PIT pinned to its last version there**

## Decision Outcome

Chosen in discussion: allow the Gradle Plugin Portal. The plugin is still published to Maven Central; a repo applying
it lists `gradlePluginPortal()` and `mavenCentral()` in `pluginManagement`. Organisations already proxy both, as
[CORPORATE-USE.md](../CORPORATE-USE.md) and [ADOPTION.md](../../ADOPTION.md) say. This narrows the decision it builds
on, which otherwise stands.

### Consequences

* The java-conventions plugin keeps SpotBugs', the versions report's and PIT's Gradle plugins at their current
  versions, and the external artifact list names the Portal for them.

## More Information

* Builds on: [All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md)
* Later decisions that build on this: none yet
* Background: nothing
