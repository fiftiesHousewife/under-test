---
status: proposed
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Each test is graded reaches, may reach or cannot reach, from the address its own settings give

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

connection-paths lists every test with a chain of calls to a reach point. On Openfire 4.6.0's server module that was
230 of 415 tests, and tracing them by hand found that none could reach a real external system from the repo's own
test settings: the database and LDAP had no address there, the calls went to mocks, the code ran only after a setting
no test set, or the test started its own embedded server. connection-paths' facts version 4 now records, for each
reach, the address as the test's settings give it (`address_for_tests`: host, local, none or run-time) and the first
call on a mock (`through_mock`), and for each test its embedded servers (`stand_ins`); it follows a call through an
interface only into classes the code creates. With those, all 230 come out as unable to reach. Measurement leaves out
the tests that reach external systems, and repair twins them, so the grade decides what both do.

## Considered Options

* **Three grades, from the facts**  
  Reaches: a reach not through a mock, whose address for tests names a host, in a test with no embedded server for
  that kind. May reach: the same, but the address is only known at run time. Cannot reach: every reach is through a
  mock, has no address for tests, stays local, or has an embedded server in place
* **Every chain counts as may reach**  
  Measurement runs every listed test under the airgap agent and sorts them; on Openfire that is most of the suite
* **Only literal hosts in the test's own code count**  
  Misses an address that comes from the settings a test loads

## Decision Outcome

Proposed: three grades, from the facts, recorded with each test's external systems in `testing/tests.yaml`, with the
reason for each. Measurement leaves out the tests that reach and runs the rest; under the airgap agent, a test that
may reach is confirmed or cleared by its one run, and a test graded cannot reach that does call out is a miss of
discovery, added to the list. Repair twins only the tests confirmed to reach.

### Consequences

* The external systems list's skill writes the grade and its reason; its eval case has a test of each grade.
* The schema for the list of tests gains the grade.
* Openfire 4.6.0's server module is the first real check: all 230 chains graded cannot reach, which measurement then
  confirms.

## More Information

* Builds on: [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md), [connection-paths does everything a program can decide, and the external systems list skill only what needs judgement](0074-connection-paths-does-everything-a-program-can-decide-and-the-connection-list-skill-only-what-needs-judgement.md), [Measurement runs in stages, each gating the next: build, one run, repeats, then planted bugs](0070-measurement-runs-in-stages-each-gating-the-next-build-one-run-repeats-then-planted-bugs.md)
* Later decisions that build on this: none yet
* Background: [test-doubles](../REFERENCES.md#test-doubles)
