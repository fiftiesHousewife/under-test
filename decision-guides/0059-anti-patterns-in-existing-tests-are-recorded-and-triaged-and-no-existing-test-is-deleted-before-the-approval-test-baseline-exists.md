---
status: proposed
decision-makers: Test Quality Lead
group: Test hygiene
---

# Anti-patterns in existing tests are recorded and triaged, and no existing test is deleted before the approval-test baseline exists

**Decided by:** Test Quality Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

An old repo's tests often look better than they are: tests with no real assertions, tests switched off years ago,
tests that wait with fixed sleeps, tests that only pass in a certain order, tests that reach external systems, tests that
mock everything they touch, copy-pasted tests and whole copied classes, tests that swallow their own failures in a catch block, and methods that look like tests but never run
(an annotation missing or commented out, or a folder or class name the build doesn't pick up). Coverage figures count them all, so they overstate how far the tests
can be trusted. Some of them still pin behaviour nothing else records.

## Considered Options

* **Record each anti-pattern with the find-test-anti-patterns skill, triage it, and fix it in order; delete nothing
  before the approval-test baseline exists**  
  Measurement sees the tests as they really are, and no behaviour is lost before it's pinned elsewhere
* **Delete weak tests early**  
  Cleaner numbers, but loses whatever they did pin down
* **Leave them as they are**  
  Least effort; coverage keeps overstating how far the tests can be trusted

## Decision Outcome

Proposed: record, triage and fix in order, the default the toolkit maintainers chose in discussion. The [find-test-anti-patterns](../.github/skills/find-test-anti-patterns/SKILL.md) skill records each anti-pattern in the assessment file.
Disabled tests go to the Application Owner to re-enable or delete, and so do methods that look like tests but never
run, to make into real tests or delete. Tests that reach external systems are tagged and left
out of normal runs. The rest are fixed in the "strengthen tests" workstream. No existing test is deleted before the
approval-test baseline exists, since it may be the only record of some behaviour.

### Consequences

* The find-test-anti-patterns skill, writing into the assessment file.
* The obstacles to testing gain the anti-patterns as named obstacles, scored with the rest.
* Coverage and mutation results are reported with and without the tests marked as anti-patterns.

## More Information

* Builds on: [Tests that reach external systems are tagged and left out of normal runs](0041-tests-that-reach-external-systems-are-tagged-and-left-out-of-normal-runs.md), [Flaky tests can be quarantined only with an expiry date](0044-flaky-tests-can-be-quarantined-only-with-an-expiry-date.md), [The named list of obstacles to testing and how each is scored](0029-the-named-list-of-obstacles-to-testing-and-how-each-is-scored.md)
* Later decisions that build on this: none yet
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code)
