---
status: superseded
decision-makers: Toolkit maintainers
group: How we work
---

# Every skill and tool is also checked against real public repos, by a person's review of a sample

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [Discovery is checked on real repos against an airgap run, and the other skills by a review of a sample](0097-discovery-is-checked-on-real-repos-against-an-airgap-run-and-the-other-skills-by-a-review-of-a-sample.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Skills are evaluated against an example repo with known answers, five runs with and without them. That shows a skill
gives the same answer every time and saves effort, but only on code written to have known answers. Real old code
behaves differently: run read-only over one module of Openfire, three of the toolkit's anti-pattern rules misread
code the example repo never had, and a call graph's numbers only meant something once it ran on real code with its
real dependencies. The field trial of the whole journey happens once, before pilots; nothing checks each skill and
tool on real code as it changes.

## Considered Options

* **A fixed set of old public repos, checked for each skill and tool whenever its rules change, by a person reviewing a sample**
* **Real repos only in the one-off field trial**  
  Finds problems late, all at once
* **Known answers written for a real repo**  
  Thorough, but writing every answer for thousands of tests is too much work; a sample gives precision for far less

## Decision Outcome

Chosen in discussion: alongside the example-repo evals, every skill and tool is run, read-only, against a fixed set
of old releases of public repos ([the field trial's repos](0050-the-journey-is-field-trialled-on-old-releases-of-well-known-public-repos-before-any-organisation-pilot.md), Openfire first). A person marks right or wrong every finding,
or a random sample where there are many, and a random sample of what it passed over. That gives its precision (how many
findings are right) and an estimate of what it misses. It is repeated whenever a skill's rules or a tool change. A
pattern found wrong on a real repo is fixed, and a small case of it is added to the example repo, so the evals keep it
fixed.

### Consequences

* Each skill's evaluation page records precision and misses on each real repo, next to its eval results.
* Running on real repos follows the safety rule: until a repo's safety inventory is clean, only reading tools run, and
  build tools are never run on it; dependency jars are read from package repositories, not by running its build.
* A person's review takes time, so samples stay small: about 50 findings and 20 passed over per repo.

## More Information

* Builds on: [The toolkit's skills are evaluated with claude plugin eval, against known answers, five runs with and without them](0045-the-toolkits-skills-are-evaluated-with-claude-plugin-eval-against-known-answers-five-runs-with-and-without-them.md), [The journey is field-trialled on old releases of well-known public repos before any organisation pilot](0050-the-journey-is-field-trialled-on-old-releases-of-well-known-public-repos-before-any-organisation-pilot.md)
* Later decisions that build on this: [The external systems list is checked on real repos against a run of every test under the airgap agent](0088-the-external-systems-list-is-checked-on-real-repos-against-a-run-of-every-test-under-the-airgap-agent.md)
* Background: none
