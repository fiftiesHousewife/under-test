---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Measurement runs in stages, each gating the next: build, one run, repeats, then planted bugs

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Measurement is the first time a repo's code runs. Five runs in varied orders, coverage and planted bugs, all at once,
assume the code builds and its tests start; with old repos they often don't, and the first failure is usually a build
problem or a shared start-up (a Spring context) needing something it can't reach.

## Considered Options

* **Stages, each gating the next, each recording what it learned**
* **Stages, with planted bugs moved out of measurement**  
  Cheaper measurement, but the baseline then lacks the measure of test strength
* **One step, as before**

## Decision Outcome

Chosen in discussion: stages, each gating the next, on a runner with no route out or under the airgap agent:

1. **Build:** compile the main and test code, no tests. If it fails, fix the build first.
2. **One run:** every test once, outside calls refused, the tests discovery found reaching external systems left out.
   It shows what passes and fails, confirms or clears each test that may reach an external system, and finds a shared
   start-up needing a stand-in, which is the only place measurement loops: add the stand-in, run once again.
3. **Repeats:** the tests that passed, four more times in varied orders, each failure rerun to confirm it, with
   coverage.
4. **Planted bugs:** PIT on the tests that passed every time, per module, in key packages where it is large.

Each stage writes what it learned into `testing/tests.yaml` and the assessment file before the next starts, so a repo
that stops after any stage still has a result.

### Consequences

* measure-a-repo runs and reports the stages separately, and can be asked to stop after any.
* The airgap agent is the better source from stage 2 on (it catches swallowed calls, processes and native code); a
  runner with no route out is enough to start.

## More Information

* Builds on: [Measurement leaves out external tests, varies the test order, and sorts connection errors by where they were going](0059-measurement-leaves-out-external-tests-varies-the-test-order-and-sorts-connection-errors-by-where-they-were-going.md), [Planted bugs are counted per module, in key packages proposed from the change history](0061-planted-bugs-are-counted-per-module-in-key-packages-proposed-from-the-change-history.md)
* Later decisions that build on this: [A repo may be built, without running its tests, before the safety gate](0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md), [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md), [Each test is graded reaches, may reach or cannot reach, from the address its own settings give](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md)
* Background: none
