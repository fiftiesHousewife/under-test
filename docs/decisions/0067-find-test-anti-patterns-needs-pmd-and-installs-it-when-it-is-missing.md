---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# find-test-anti-patterns needs PMD, and installs it when it is missing

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[find-test-anti-patterns runs PMD with the toolkit's rules, and searches only what PMD cannot read](0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md)
kept text searches as a fallback where no `pmd` command was available. In the first eval round on PMD, runs fell back
without trying PMD at all: a weaker route that is always open gets taken quietly, and its results look the same as the
real ones.

## Considered Options

* **PMD is required: the skill checks for it, installs it with the toolkit's pmd-install when it is missing, and
  otherwise stops and writes nothing**
* **Keep the search fallback, saying in the report that PMD wasn't used**  
  Easy to take without need, and a reader of the results may not notice

## Decision Outcome

Chosen in discussion: PMD is required. The skill checks for `pmd` on the path or in `.pmd/`; when neither answers, it
installs PMD into `.pmd/` with [pmd-install](../../tools/meaningless-and-unreliable-tests/pmd-install/build.gradle), keeps that
folder out of git, and checks again; when PMD still doesn't answer, it stops, writes nothing, and tells the person how
to get it. This replaces the fallback in the decision above; the rest of it stands.

### Consequences

* The search fallback is removed from the skill.
* PMD and a JDK are part of what an organisation provides before running the skill; the adoption guide's list of
  what to mirror includes PMD.
* The skill's eval case fails at set-up if the PMD it installs doesn't answer.

## More Information

* Builds on: [find-test-anti-patterns runs PMD with the toolkit's rules, and searches only what PMD cannot read](0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md)
* Later decisions that build on this: none yet
* Background: none
