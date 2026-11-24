---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Risky calls on developer machines are refused and reported by the airgap agent, built in its own repo

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
needs a way to run old code safely on developer machines: Windows, no administrator rights, no container runtime, and
repos on JDK 8 and later. A search for an existing tool, as
[We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md) asks,
found none that works within those limits: the Security Manager is disabled from JDK 24, operating-system sandboxes
need administrator rights on Windows, and the test-only tools are betas or JUnit 4 only. Every option, with
references, is in [the airgap agent's design](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/docs/design.md#options-considered).

## Considered Options

* **Build the airgap agent, a Byte Buddy Java agent (JDK 8 and later) that refuses and reports risky calls, with a JUnit
  Platform listener and extension, in its own repo, used by the convention plugin by version**
  Fits every restriction; its own build can test five JDKs; useful beyond the toolkit
* **Build it here, under `tools/`**
  One repo fewer, but a five-JDK test matrix inside the toolkit's build, and harder for others to find
* **Adopt an existing tool (junit-airgap, Sniffy, a security agent)**
  None is maintained, complete and free of native code; see the design

## Decision Outcome

Chosen: build it, in its own repo, [under-test-airgap](https://github.com/fiftiesHousewife/under-test-airgap). Its own
decision records cover the threat model (accidental calls, not hostile code), how a refused call fails, its parts,
its report, and how it is tested.

### Consequences

* The convention plugin adds the agent to test runs, application starts and the build on developer machines, once the
  agent is released.
* Discovery moves each repo onto the JUnit Platform, and turns the agent's report into the draft connection list and
  the repo's test profile.
* Decision guides [Tests stop at once if any configured address is a production address](../../decision-guides/0009-tests-stop-at-once-if-any-configured-address-is-a-production-address.md)
  and [A test profile with dummy secrets is the default, and production profiles only work in production](../../decision-guides/0010-a-test-profile-with-dummy-secrets-is-the-default-and-production-profiles-only-work-in-production.md)
  lean on the agent's handling of Spring profiles.
* A lesson on running old code under the agent comes early in the lessons.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build](0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md), [A Maven repo is measured with the agents in JAVA_TOOL_OPTIONS, and JaCoCo and PIT run from the command line](0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md), [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md)
* Background: [the airgap agent's design](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/docs/design.md)
