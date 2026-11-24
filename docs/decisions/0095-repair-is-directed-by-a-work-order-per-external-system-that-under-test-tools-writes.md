---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Repair is directed by a work order per external system that under-test-tools writes

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Every test that reaches an external system becomes a pair](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md),
one external system at a time, by recipes and the AI
([Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md)).
What each pair needs is already recorded, but in three files: under-test-external-calls' facts
(`testing/external-calls.json`: each test's chain, where it reaches the system, calls through mocks, embedded
servers), the list of tests (`testing/tests.yaml`: each test's grade and what measurement saw), and the external
systems list (`testing/external-systems.calm.json`: each system's chosen stand-in). Joining them for every test is
mechanical, the same way every time.

## Considered Options

* **A work-order file, written by a tool**  
  One file per repo, an order per external system, which the repair skill reads one system at a time
* **The repair skill joins the three files itself**  
  Nothing new to build; the AI does a large mechanical join on every run, and can do it differently each time

## Decision Outcome

Chosen in discussion: a work-order file, `testing/repair-orders.json`, written by a new sub-command of
[under-test-tools](0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md),
`repair-orders`, which joins `testing/external-calls.json`, `testing/tests.yaml` and
`testing/external-systems.calm.json`. It holds one order per external system.

**For the system,** each order gives:

* its node in the external systems list, and its kind;
* the chosen stand-in: its approach, the shared test kit it comes from, and the state of that choice;
* the shared chain: the calls every test reaching the system goes through;
* where the system's address comes from.

**For each test,** each order gives:

* the test class and method, and `at`, its file and line;
* the test framework;
* where to inject the stand-in: in the test body, in set-up, in a field, on the shared chain, or in the framework's
  settings; the method, the file and line of the call, and the client's type;
* the chain of calls to the system, and `through_mock`, the first call on a mock;
* the embedded stand-ins the test already uses;
* for a test that starts a framework, its settings files and profiles;
* the evidence: the grade and its reason, whether measurement saw the test call out, and whether discovery missed it;
* what it waits for, if anything: a stand-in not yet chosen, an address written in the code, or no place to inject.

The repair skill reads the orders one system at a time, and records each test's result in a new `repair` field of
`testing/tests.yaml`, which it owns.

### Consequences

* A schema for the work-order file in [`schema/`](../../schema/), and the `repair` field in
  [the schema for the list of tests](../../schema/tests.schema.json).
* `repair-orders` gets its own example repo of known answers in under-test-tools.
* Until the sub-command exists, the repair skill does the join from its instructions.

## More Information

* Builds on: [The journey's mechanical steps are one command-line tool, with a sub-command per step, in its own repo](0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md), [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md), [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)
* Later decisions that build on this: [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md)
* Background: none
