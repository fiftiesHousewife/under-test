---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# connection-paths does everything a program can decide, and the connection-list skill only what needs judgement

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

> Narrowed by [Getting the classpath is under-test-external-calls' job, and the toolkit carries no copy of its steps](0091-getting-the-classpath-is-under-test-external-calls-job-and-the-toolkit-carries-no-copy-of-its-steps.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Following the connection-list skill by hand on Openfire 4.6.0 showed that most of its steps are mechanical: getting
the classpath from whichever build the repo has, reading a sibling module's source, telling local resources from
external systems, tracing an address to a literal, a constant, an environment variable or a setting key, looking the
setting up, and grouping connection points into systems. Written as instructions, each is slow for an AI assistant
and can come out differently each time.

## Considered Options

* **The tool does everything a program can decide; the skill keeps the person's choices, the hard cases, and the
  toolkit's own files**
* **The skill does it all from instructions**: what the trial did, slowly
* **The tool writes the toolkit's files too**: possible later, if evals show the skill's writing varies

## Decision Outcome

Chosen in discussion. connection-paths gains:

* a classpath step: the repo's wrapper if it has one, else the Maven or Gradle the organisation profile names;
  `-am -DskipTests compile` for a module with sibling modules; and sibling modules read as source;
* for each connection point, an address hint: a literal, a constant, an environment variable, a system property, a
  JNDI name, or a setting key passed to a settings method, followed within its class, and the setting's value looked
  up in the repo's properties, YAML and XML files, with values that look like placeholders flagged;
* rules that mark a point local, not a system: file and in-memory databases, classpath resources, `file:` and `jar:`
  URLs, DNS lookups through JNDI, and methods nothing calls;
* proposed systems: by host, else by setting, else by opening class, with implementations of one interface marked as
  alternatives.

The skill asks which modules to cover, reads only the methods whose address the tool could not trace, asks a person
about alternatives and placeholders, writes the connection list and `testing/tests.yaml`, proposes stand-ins, keeps
what people decided before, and reports.

### Consequences

* Each new rule in the tool gets a case in its example repo; the Openfire trial is the check: the tool alone should
  give the same systems and tests the hand trial did.
* The skill shrinks to about a page.

## More Information

* Builds on: [Connections and the test paths to them are found by connection-paths, a JavaParser tool in its own repo](0072-connections-and-the-test-paths-to-them-are-found-by-connection-paths-a-javaparser-tool-in-its-own-repo.md), [A repo may be built, without running its tests, before the safety gate](0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md)
* Later decisions that build on this: [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md), [A connection whose address isn't known is a system of its own per class that opens it](0076-a-connection-whose-address-is-not-known-is-a-system-of-its-own-per-class-that-opens-it.md), [Each test is graded reaches, may reach or cannot reach, from the address its own settings give](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md), [under-test-external-calls grades each reach, and the external systems list skill reads the grade](0094-under-test-external-calls-grades-each-reach-and-the-external-systems-list-skill-reads-the-grade.md)
* Background: none
