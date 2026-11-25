---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

> Narrowed by [A Maven repo's tests get the airgap agent from its Maven extension, named on the command line](0104-a-maven-repos-tests-get-the-airgap-agent-from-its-maven-extension-named-on-the-command-line.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build](0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md)
covers Gradle, and says Maven builds run the JaCoCo and PIT Maven plugins from the command line. Most of the repos the
toolkit is for build with Maven, on JDK 8 with JUnit 4. What that decision leaves open is how the airgap agent gets
into every JVM that runs a test without changing the `pom.xml`. No test may run without it
([Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)).

Maven passes JVM options to the test plugins (Surefire and Failsafe) through `argLine`. A pom can set its own
`argLine`, which then overrides one given on the command line, or run tests inside Maven's own JVM (`forkCount` 0),
where `argLine` isn't used at all.

## Considered Options

* **The agents in `JAVA_TOOL_OPTIONS`**  
  Every JVM started reads it: Maven's own, each forked test JVM, and PIT's workers, whatever the pom does with
  `argLine`, on any Maven 3. Maven itself is then blocked from the network too, so dependencies are downloaded first,
  without the agent, and every measured run is offline (`-o`). Downloading dependencies runs none of the repo's own code
* **`-DargLine` on the command line**  
  Maven's usual way, but a pom with its own `argLine`, or tests run in Maven's own JVM, drops it without a word, and
  the tests run with no agent
* **A Maven extension that adds the agents to every test plugin**  
  Precise, but new code, which goes in its own repo
  ([The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)),
  so Maven repos wait for it

## Decision Outcome

Chosen in discussion: the agents in `JAVA_TOOL_OPTIONS`. In order:

1. Without the agent, download what the build needs and nothing else: `mvn dependency:go-offline`, and the JaCoCo and
   PIT plugins by their full names.
2. Five runs of `mvn -o test` with `JAVA_TOOL_OPTIONS` holding the airgap agent and, for run 1, the JaCoCo agent
   writing to a file outside `target/`, so a later clean doesn't remove it.
3. Each run's Surefire reports (`target/surefire-reports/*.xml`) are copied aside before the next.
4. The coverage report comes from the JaCoCo plugin's `report` goal, run by its full name on run 1's data.
5. Planted bugs come from the PIT plugin's `mutationCoverage` goal, run by its full name with the same targets and
   left-out tests as on Gradle, with the airgap agent still in `JAVA_TOOL_OPTIONS`.

### Consequences

* The measure-a-repo skill gets a Maven route next to its Gradle one; the reports it reads come from `target/`
  instead of `build/`, and the `tests` and `level` sections it writes are the same.
* Each run checks that the airgap agent loaded in every JVM that ran a test, from the agent's own report; if it
  didn't, the skill stops and writes nothing.
* The airgap agent's reports go to `target/airgap/`, so the connection-list and anti-pattern skills read them there
  as well as in `build/airgap/`.
* A repo whose tests use JUnit 5 needs PIT's JUnit 5 plugin, which can't be added from the command line; the skill
  says so and stops until that is solved.
* An eval case with a small Maven repo, on an old JDK, checks the route.

## More Information

* Builds on: [A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build](0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md), [Risky calls on developer machines are refused and reported by the airgap agent, built in its own repo](0036-risky-calls-on-developer-machines-are-refused-and-reported-by-the-airgap-agent-built-in-its-own-repo.md)
* Later decisions that build on this: [A Maven repo's tests get the airgap agent from its Maven extension, named on the command line](0104-a-maven-repos-tests-get-the-airgap-agent-from-its-maven-extension-named-on-the-command-line.md)
* Background: none
