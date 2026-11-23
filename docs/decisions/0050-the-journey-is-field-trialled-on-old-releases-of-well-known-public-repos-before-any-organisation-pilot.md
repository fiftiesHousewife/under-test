---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# The journey is field-trialled on old releases of well-known public repos before any organisation pilot

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Each journey skill has an eval case: a small repo written to hold known problems
([The toolkit's skills are evaluated with claude plugin eval, against known answers, five runs with and without them](0045-the-toolkits-skills-are-evaluated-with-claude-plugin-eval-against-known-answers-five-runs-with-and-without-them.md)).
The cases show that a skill follows its rules every time. They can't show what happens on a real repo: thousands of
tests, a build that half works on an old JDK, secrets deep in the history, tests that call real services. The repos
the toolkit is for are old: JDK 8, JUnit 4, mostly Maven.

The well-known public Java repos that look like them have since moved to newer JDKs and test frameworks; their old
releases haven't.

## Considered Options

* **Old releases of well-known public repos, pinned to a release tag**  
  The repos look like the ones the toolkit is for, the results can be published in this repo because nothing in
  them belongs to an organisation, and anyone can repeat a trial from the same tag
* **The current versions of public repos**  
  Easier to build, but modern JDKs and JUnit 5 test little of what the toolkit is for
* **Go straight to an organisation's pilot repos**  
  The real target, but every break is found on an organisation's time, and the results can't be shared

## Decision Outcome

Chosen in discussion: old releases of well-known public repos, pinned to a release tag. Two or three repos, at least one built with
Maven and at least one with an old Gradle, with JUnit 4, tests that reach outside the machine, and tests known to be
flaky or disabled. A first shortlist: Apache OFBiz (Gradle; a release whose Gradle is 5.6 or later, since `release18.12` uses a 5.0 pre-release), Openfire `v4.6.0` (Maven) and Jenkins core
`2.346.x` (Maven, thousands of tests), with OpenMRS core as the fallback. A repo whose tests need containers is left
out, because the machines the toolkit is for can't run them
([Container tests on developer machines that have no container runtime](../../decision-guides/0021-container-tests-on-developer-machines-that-have-no-container-runtime.md)).

### Consequences

* A person with an AI assistant runs every journey skill on each repo in order: the safety inventory first, and the
  code only under the airgap agent. Pinned releases still contain real host names, and some tests call real services;
  the agent refuses them.
* Every place a skill breaks, stops, or needs a person to step in is recorded, with tool calls and time for each step.
* Each break becomes a cut-down eval case, or a backlog item where the skill can't cover it yet.
* The Maven route for measuring a repo comes first
  ([A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line](0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md)),
  because two of the three repos build with Maven.

## More Information

* Builds on: [The toolkit's skills are evaluated with claude plugin eval, against known answers, five runs with and without them](0045-the-toolkits-skills-are-evaluated-with-claude-plugin-eval-against-known-answers-five-runs-with-and-without-them.md), [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: none yet
* Background: none
