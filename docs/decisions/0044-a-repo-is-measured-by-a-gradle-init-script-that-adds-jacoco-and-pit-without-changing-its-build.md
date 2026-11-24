---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Measuring a repo needs coverage, results from five separate runs, and planted bugs. Old builds have none of these set
up, and the measurement comes before anyone has agreed to change the build. The convention plugin that would add them
belongs in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)).

## Considered Options

* **A small Gradle init script in the toolkit, run with the airgap agent's init script, and a skill that runs it**  
  Changes nothing in the repo; works on Gradle 5.6 to 9; JaCoCo is Gradle's own plugin, and PIT runs from its own
  command line, so no plugin version has to match the Gradle version
* **Wait for the convention plugin**  
  Nothing can be measured until it exists and each repo applies it
* **Change each repo's build file**  
  A change to the repo before its owners have agreed to one

## Decision Outcome

Chosen in discussion: the first option. Maven builds run the JaCoCo and PIT Maven plugins from the command line, once
running Maven's tests under the airgap agent has been tried.

### Consequences

* [`tools/measurement/measure.init.gradle`](../../tools/measurement/measure.init.gradle) and the measure-a-repo skill.
* The script refuses to run tests without the airgap agent, unless the CI runner is declared to have no route out.
* PIT leaves out the tests that were flaky or failing in the five runs, so the planted-bug count doesn't change
  from run to run.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [Risky calls on developer machines are refused and reported by the airgap agent, built in its own repo](0036-risky-calls-on-developer-machines-are-refused-and-reported-by-the-airgap-agent-built-in-its-own-repo.md)
* Later decisions that build on this: [A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line](0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md), [Planted bugs are counted per module, in key packages proposed from the change history](0061-planted-bugs-are-counted-per-module-in-key-packages-proposed-from-the-change-history.md)
* Background: none
