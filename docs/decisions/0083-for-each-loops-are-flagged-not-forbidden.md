---
status: superseded
decision-makers: Toolkit maintainers
group: How we work
---

# For-each loops are flagged, not forbidden

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [All our Java applies the java-conventions plugin, which holds our code-quality standards](0100-all-our-java-applies-the-java-conventions-plugin-which-holds-our-code-quality-standards.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md)
prefers streams to for-each loops. As first written in connection-paths, the rule fails the build on any for-each
loop, with a suppression and a reason where the body throws a checked exception. Streams read well for transforming
a collection, and worse for a loop with side effects, an early exit or a checked exception.

## Considered Options

* **Flag it: the loop shows in the report, and the build still passes**
* **Fail the build, with a suppression and a reason where a loop is better**
* **No rule**

## Decision Outcome

Chosen in discussion: flag it. The rule reports every for-each loop and never fails the build; every other rule of
the plugin still fails it. This narrows the decision it builds on, which otherwise stands.

### Consequences

* connection-paths, and then the java-conventions plugin, run the rule where it only reports.

## More Information

* Builds on: [All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md)
* Later decisions that build on this: none yet
* Background: nothing
