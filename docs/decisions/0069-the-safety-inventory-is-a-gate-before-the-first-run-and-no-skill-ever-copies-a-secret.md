---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The safety inventory is a gate before the first run, and no skill ever copies a secret

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

> Narrowed by [A repo may be built, without running its tests, before the safety gate](0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md), [The field trial's public repos run their tests under the airgap agent without a safety inventory first](0089-the-field-trials-public-repos-run-their-tests-under-the-airgap-agent-without-a-safety-inventory-first.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The journey began with the safety inventory, and nothing else started until it was done. Its job is to make the
first run of a repo's code safe: secrets resolved, jobs that start themselves switched off, a test profile in place.
Discovery reads code and settings and runs nothing, so nothing in it depends on the inventory; holding it back only
delays the work. Reading code does put whatever secrets are in it in front of the AI assistant doing the reading.

## Considered Options

* **A gate before the first run: discovery starts at once, and the inventory must be resolved before any code runs**
* **Run it alongside discovery, with the same gate**  
  The same, with a secret found early rotated while discovery goes on; an organisation can still choose this
* **Keep it first**  
  Safe, but discovery waits for nothing

## Decision Outcome

Chosen in discussion: a gate before the first run. Discovery (the connection list and the anti-patterns) starts
straight away; the safety inventory runs any time before measurement, and measurement doesn't start while a finding
that blocks the first run is undecided. Every skill follows one standing rule: **a secret's value is never copied
into any file it writes or any reply**; where it must point at one, it gives the file and line.

### Consequences

* The journey page, the drawing and the README show discovery first and the safety inventory as the gate before
  measurement.
* Every journey skill states the rule about secrets; measure-a-repo already refuses to run while a blocking finding
  is undecided.
* [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md) is unchanged: the first run is still measurement, on a runner with no route out or under the airgap agent.

## More Information

* Builds on: [A repo's code first runs in measurement, which comes before capturing current behaviour and again after it](0058-a-repos-code-first-runs-in-measurement-which-comes-before-capturing-current-behaviour-and-again-after-it.md)
* Later decisions that build on this: [A repo may be built, without running its tests, before the safety gate](0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md)
* Background: none
