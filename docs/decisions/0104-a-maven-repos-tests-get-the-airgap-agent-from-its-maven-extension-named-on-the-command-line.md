---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A Maven repo's tests get the airgap agent from its Maven extension, named on the command line

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line](0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md)
puts the airgap agent in `JAVA_TOOL_OPTIONS`, so every JVM Maven starts gets it: Maven itself and its plugins as well
as the forked test JVMs. Since then the [airgap agent's repo](https://github.com/fiftiesHousewife/under-test-airgap)
has built a Maven extension that adds the agent, and its JUnit listener, to every module's Surefire, Failsafe,
`spring-boot:run` and `exec:exec` runs without changing any pom, keeping any `argLine` a module already sets. It
works on Maven 3.6 to 4.

## Considered Options

* **The Maven extension, named in `-Dmaven.ext.class.path` for the run**  
  The agent is in exactly the JVMs that run the repo's code, as the Gradle init script does, and its report names
  each test; nothing in the repo changes
* **Keep `JAVA_TOOL_OPTIONS`**  
  No extension, but the agent also loads in Maven and its plugins, and the report says less about which test called

## Decision Outcome

Chosen in discussion: the Maven extension, named on the command line.

* **For every run of a Maven repo's code** (measurement and repair alike): the extension's jars named in
  `-Dmaven.ext.class.path`, the way the airgap repo's `airgap-mvn.sh` does, never in `.mvn/extensions.xml`, since that
  changes the repo. Its reports are read from `target/airgap/<plugin>-<execution>/calls.jsonl`.
* **A module whose tests run in Maven's own JVM** (`forkCount=0`) or through `exec:java` can't get the agent this way;
  the extension warns of each. For those only, Maven itself runs with the agent in `JAVA_TOOL_OPTIONS`, as decision
  0049 says.
* **JaCoCo and PIT** stay as decision 0049 says, except that JaCoCo's agent comes from its plugin's `prepare-agent`
  goal, run by its full name, which sets the `argLine` the extension keeps.
* Maven needs its dependencies first, so where the run can't reach the package repository, a person runs Maven where
  it can, and the skill reads what the run wrote.

This narrows [A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line](0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md).

### Consequences

* measure-a-repo's Maven route, and the repair skill's runs on Maven repos, use the extension.
* The airgap agent's reports from a Maven run are under `target/airgap/`, so the skills that read them look there as
  well as under `build/`.

## More Information

* Builds on: [A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line](0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md), [A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build](0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md)
* Later decisions that build on this: none yet
* Background: none
