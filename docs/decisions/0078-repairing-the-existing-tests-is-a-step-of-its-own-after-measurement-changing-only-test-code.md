---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Repairing the existing tests is a step of its own, after measurement, changing only test code

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Discovery lists every test with a problem (tests that reach external systems, sleep, depend on the order they run
in, never run, swallow their own failures, have no real assertion, mock everything, or are copies), and measurement
adds the flaky and failing ones and shows which tests catch no planted bug. Until now each finding became a piece of
work in one of the testing plan's workstreams, spread from "make it run on its own" to "strengthen tests", after
current behaviour is captured and the plan approved. Capturing current behaviour then rests on tests that can't yet be
trusted, and the work of making the existing tests trustworthy has no place of its own in the journey.

## Considered Options

* **Its own step after measurement, changing only test code**  
  The existing tests are made trustworthy first, judged by measurement's planted bugs and measured again afterwards.
  Anything that needs production code changed, or a test deleted, waits for later steps, recorded as work
* **Its own step after capturing current behaviour, production code allowed**  
  Approval tests are the safety net, so repair could make dependencies replaceable; capture runs on tests no one has repaired
* **The first workstreams of the work**  
  The smallest change: the plan keeps all of it, but repair is still not a step anyone can point to

## Decision Outcome

Chosen in discussion: its own step after measurement, changing only test code. The journey becomes discovery, the
safety inventory, measurement, **repair**, capturing current behaviour, intended behaviour, the testing plan, the work,
and keeping it there.

Repair works one connection, then one kind of problem, at a time, each change a pull request a person reviews:

* **Tests that reach external systems** are sorted into logic, connection or both, and treated by their sort
  ([Tests that reach external systems are sorted into logic, connection or both, and treated accordingly](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md)).
  The stand-ins they need are test code: a fake, recorded responses or a container, from the shared test kit where
  there is one.
* **Flaky and failing tests, sleeps and order-dependent tests, tests that never run, tests that swallow their own
  failures, tests with no real assertion, tests that mock everything and copied tests** are fixed in the test code,
  as [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md)
  says.
* **Left as work for later**, recorded against the test in `testing/tests.yaml` with the reason: anything that needs
  production code changed (a dependency a test can't replace, an address written in the code that a stand-in
  needs in a setting), deleting a test (never before the approval-test baseline, by
  [the guide on anti-patterns in existing tests](../../decision-guides/0059-anti-patterns-in-existing-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)),
  disabled tests (the Application Owner decides), and any fix a person turns down. The testing plan turns each into a
  piece of work.

A repaired test is kept only if it passes [the checks an AI-written test must pass](../../decision-guides/0047-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md).
Measurement then runs again on the same settings, so what repair changed shows as a change.

Repair reads what discovery recorded rather than searching again. From connection-paths' facts: each test's chain to
a connection (its second step is the first method the test calls, or the set-up that leads there), whether it goes
through set-up (the double then goes in the set-up), each system's shared chain (the calls every test reaching it
goes through: where one stand-in covers them all), each connection's address source (a literal in the code
is work for later), and the tests that start a framework (their stand-in goes in the settings the test loads).

### Consequences

* The [journey page](../JOURNEY.md), its drawing, the README and the glossary gain the step; later steps are
  renumbered.
* A repair skill replaces the planned follow-up skill for tests that reach external systems, and takes in its
  sorting.
* The testing plan's rows for anti-patterns become rows for what repair left, and
  [the order of workstreams](../../decision-guides/0050-the-order-of-workstreams-for-a-repo.md) then orders only that
  work and the plan's own.
* measure-a-repo runs again after repair.

## More Information

* Builds on: [Tests that reach external systems are sorted into logic, connection or both, and treated accordingly](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md), [Measurement runs in stages, each gating the next: build, one run, repeats, then planted bugs](0070-measurement-runs-in-stages-each-gating-the-next-build-one-run-repeats-then-planted-bugs.md), [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)
* Later decisions that build on this: [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md)
* Background: [legacy-code](../REFERENCES.md#legacy-code), [test-doubles](../REFERENCES.md#test-doubles), [flaky-tests](../REFERENCES.md#flaky-tests)
