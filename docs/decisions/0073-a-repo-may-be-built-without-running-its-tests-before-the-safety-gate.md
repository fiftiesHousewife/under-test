---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A repo may be built, without running its tests, before the safety gate

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Discovery ran none of a repo's code, so tools that need its classpath had to work it out from the build files.
That works well for Maven and only partly for Gradle, whose build files are programs. A build that compiles the
code, or only resolves its dependencies, without running any test or the application, gives the exact classpath and
shows early whether the repo builds at all.

## Considered Options

* **Allow a build without tests before the safety gate**
* **Nothing runs before the gate, not even the build**  
  Strict, but leaves tools guessing the classpath and finds a broken build late

## Decision Outcome

Chosen in discussion: a repo may be built, or have its dependencies resolved, without running its tests or the
application, at any point in discovery. Tests and the application still run first only in measurement, after the
safety gate, where production can't be reached
([why](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)).

### Consequences

* connection-paths takes the build's classpath when there is one (for Maven, `dependency:build-classpath`; for
  Gradle, an init script that prints the resolved classpaths), and reads the build files only when the build fails.
* Measurement's first stage, the build, may already be done in discovery.
* A build still runs build scripts, annotation processors and code generators; a generator that connects to a
  database or fetches a WSDL is one to notice in the build's output.

## More Information

* Builds on: [Measurement runs in stages, each gating the next: build, one run, repeats, then planted bugs](0070-measurement-runs-in-stages-each-gating-the-next-build-one-run-repeats-then-planted-bugs.md), [The safety inventory is a gate before the first run, and no skill ever copies a secret](0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)
* Later decisions that build on this: none yet
* Background: none
