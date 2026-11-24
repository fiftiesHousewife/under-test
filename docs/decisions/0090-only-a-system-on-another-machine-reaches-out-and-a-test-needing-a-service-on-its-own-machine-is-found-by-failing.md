---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Only a system on another machine reaches out, and a test needing a service on its own machine is found by failing

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Each test is graded reaches, may reach or cannot reach](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md),
and an address on the test's own machine (`localhost`, a loopback address) grades local, so cannot reach. The airgap
agent always allows calls to the machine itself. But a test whose settings say `jdbc:mysql://localhost:3306` can't
run without a database it doesn't start itself, and [the toolkit calls a system a test cannot run without an
external system](0062-the-toolkit-calls-a-system-a-test-cannot-run-without-an-external-system.md). Old open-source
repos often point their tests at a database or server on localhost.

## Considered Options

* **Only a system on another machine reaches out**  
  A service on the test's own machine is local; a test that needs one and finds none fails, and measurement records it
* **A service on the machine the test doesn't start counts as an external system**  
  Repair would pair such tests too; discovery would need to tell a service the test starts from one it doesn't, and
  the agent would need to report calls to the machine itself

## Decision Outcome

Chosen in discussion: only a system on another machine reaches out. The grades stay as they are: an address on the
test's own machine is local, so cannot reach, and the airgap agent keeps allowing it. A test that needs a service on
its own machine that isn't running fails in measurement's one run; measurement records it as failing in every run,
and the testing plan makes the work of [making the tests that fail in every run pass](../../.github/skills/write-the-testing-plan/SKILL.md)
with outbound calls blocked. Repair pairs only the tests that reach other machines.

### Consequences

* The check of discovery against a run under the airgap agent judges recall only for other machines, which is all the
  agent reports.
* A repo whose tests mostly need a local database shows many tests failing in every run, not many tests reaching
  external systems; the testing plan's first workstream gives them their stand-ins.

## More Information

* Builds on: [Each test is graded reaches, may reach or cannot reach, from the address its own settings give](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md), [The toolkit calls a system a test cannot run without an external system](0062-the-toolkit-calls-a-system-a-test-cannot-run-without-an-external-system.md), [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)
* Later decisions that build on this: [An external system is one on another machine that a test cannot run without](0098-an-external-system-is-one-on-another-machine-that-a-test-cannot-run-without.md)
* Background: none
