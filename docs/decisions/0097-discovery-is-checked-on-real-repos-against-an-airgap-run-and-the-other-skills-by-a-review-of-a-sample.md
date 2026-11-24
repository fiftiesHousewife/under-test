---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# Discovery is checked on real repos against an airgap run, and the other skills by a review of a sample

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Every skill and tool is also checked against real public repos, by a person's review of a sample](0071-every-skill-and-tool-is-also-checked-against-real-public-repos-by-a-persons-review-of-a-sample.md),
alongside the evals on an example repo with known answers, which show only how a skill does on code written to have
known answers. Three later records changed how that check runs:
[the external systems list is checked against a run of every test under the airgap agent](0088-the-external-systems-list-is-checked-on-real-repos-against-a-run-of-every-test-under-the-airgap-agent.md),
not a sample; [the field trial's public repos run their tests under the airgap agent without a safety inventory first](0089-the-field-trials-public-repos-run-their-tests-under-the-airgap-agent-without-a-safety-inventory-first.md);
and [a repo may be built, without running its tests, before the safety gate](0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md),
where the earlier record had only reading tools run.

## Considered Options

* **One record for the check as it now is**  
  An airgap run for discovery, a person's review of a sample for the rest
* **Keep the earlier record, narrowed by the later ones**  
  No new record, but its safety rule and its method for discovery no longer hold

## Decision Outcome

Chosen in discussion: alongside the example-repo evals, every skill and tool is also checked against a fixed set of
old releases of public repos
([the field trial's repos](0050-the-journey-is-field-trialled-on-old-releases-of-well-known-public-repos-before-any-organisation-pilot.md)),
whenever its rules change.

* **For the external systems list,** the check is a run of every test under the airgap agent, compared test by test,
  as [The external systems list is checked on real repos against a run of every test under the airgap agent](0088-the-external-systems-list-is-checked-on-real-repos-against-a-run-of-every-test-under-the-airgap-agent.md)
  says. The field trial's public repos run without a safety inventory first, always under the agent with every call
  to another machine refused. A repo may be built first.
* **For the other skills,** a person marks right or wrong a random sample of about 50 findings and 20 of what the
  skill passed over, per repo, giving its precision and an estimate of what it misses.

A pattern found wrong on a real repo is fixed, and a small case of it is added to the example repo, so the evals keep
it fixed.

This replaces [Every skill and tool is also checked against real public repos, by a person's review of a sample](0071-every-skill-and-tool-is-also-checked-against-real-public-repos-by-a-persons-review-of-a-sample.md).

### Consequences

* Each skill's evaluation page records its precision and misses on each real repo, next to its eval results.
* How to run the check for discovery is in
  [Checking discovery against a run under the airgap agent](../design/checking-discovery-against-a-run-under-the-airgap-agent.md).

## More Information

* Builds on: [Skill evals run on a clean copy of the whole toolkit, which is the plugin, so skills can read its files](0047-skill-evals-run-on-a-clean-copy-of-the-whole-toolkit-which-is-the-plugin-so-skills-can-read-its-files.md), [The journey is field-trialled on old releases of well-known public repos before any organisation pilot](0050-the-journey-is-field-trialled-on-old-releases-of-well-known-public-repos-before-any-organisation-pilot.md), [A repo may be built, without running its tests, before the safety gate](0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md), [The external systems list is checked on real repos against a run of every test under the airgap agent](0088-the-external-systems-list-is-checked-on-real-repos-against-a-run-of-every-test-under-the-airgap-agent.md), [The field trial's public repos run their tests under the airgap agent without a safety inventory first](0089-the-field-trials-public-repos-run-their-tests-under-the-airgap-agent-without-a-safety-inventory-first.md)
* Later decisions that build on this: none yet
* Background: none
