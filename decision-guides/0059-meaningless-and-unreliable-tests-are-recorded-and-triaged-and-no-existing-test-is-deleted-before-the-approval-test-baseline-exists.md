---
status: proposed
decision-makers: Test Quality Lead
group: Test hygiene
---

# Meaningless and unreliable tests are recorded and triaged, and no existing test is deleted before the approval-test baseline exists

**Decided by:** Test Quality Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

An old repo's tests often look better than they are. Some are meaningless: they pass whatever the code does, because
they never run (switched off years ago, an annotation missing or commented out, a folder or class name the build
doesn't pick up), can't fail (no real assertion, or a catch block that swallows the failure), or check only the mocks
they set up. Others are unreliable: they wait with fixed sleeps, or pass only in a certain order. Coverage figures
count them all, so they overstate how far the tests can be trusted. Some of them still pin behaviour nothing else
records.

Tests that reach external systems are a different matter, not a fault in the test: repair makes each of them a pair,
one half with a stand-in and one tagged `external`
([Every test that reaches an external system becomes a pair](../docs/decisions/0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md),
[Repair pairs each test that reaches an external system, after measurement, changing only test code](../docs/decisions/0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md)).

## Considered Options

* **Record each meaningless and unreliable test, triage it, and fix it in the testing plan's work; delete nothing
  before the approval-test baseline exists**  
  Measurement sees the tests as they really are, and no behaviour is lost before it's pinned elsewhere
* **Delete weak tests early**  
  Cleaner numbers, but loses whatever they did pin down
* **Leave them as they are**  
  Least effort; coverage keeps overstating how far the tests can be trusted

## Decision Outcome

Proposed: record, triage and fix in the testing plan's work, the default the toolkit maintainers chose in discussion.
The [find-meaningless-and-unreliable-tests](../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) skill
records each finding against its test in `testing/tests.yaml`, with the totals in the assessment file, keeping the
meaningless and the unreliable apart
([Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](../docs/decisions/0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)).
Measurement confirms them: its planted bugs show which meaningless tests catch nothing, and its repeats in varied
orders show which unreliable tests give different answers.

Disabled tests go to the Application Owner to re-enable or delete, and so do methods that look like tests but never
run, to make into real tests or delete. The rest are fixed in the testing plan's work, in the "strengthen tests" and
"make it run on its own" workstreams. No existing test is deleted before the approval-test baseline exists, since it
may be the only record of some behaviour.

### Consequences

* The find-meaningless-and-unreliable-tests skill, writing `testing/tests.yaml` and the totals in the assessment
  file.
* The obstacles to testing gain meaningless and unreliable tests as named obstacles, scored with the rest.
* Coverage and mutation results are reported with and without the meaningless tests.

## More Information

* Builds on: [Tests that reach external systems are tagged and left out of normal runs](0041-tests-that-reach-external-systems-are-tagged-and-left-out-of-normal-runs.md), [Flaky tests can be quarantined only with an expiry date](0044-flaky-tests-can-be-quarantined-only-with-an-expiry-date.md), [The named list of obstacles to testing and how each is scored](0029-the-named-list-of-obstacles-to-testing-and-how-each-is-scored.md), [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](../docs/decisions/0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)
* Later decisions that build on this: [Tests that mock everything are sorted and treated with the tests that reach external systems](../docs/decisions/0065-tests-that-mock-everything-are-sorted-and-treated-with-the-tests-that-reach-external-systems.md), [Tests that mock everything are fixed in the testing plan's work, each mock sorted by what it stands for](../docs/decisions/0087-tests-that-mock-everything-are-fixed-in-the-testing-plans-work-each-mock-sorted-by-what-it-stands-for.md)
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code), [flaky-tests](../docs/REFERENCES.md#flaky-tests), [mutation-testing](../docs/REFERENCES.md#mutation-testing)
