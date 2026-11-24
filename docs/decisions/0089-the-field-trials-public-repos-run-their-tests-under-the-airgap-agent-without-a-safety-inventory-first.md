---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# The field trial's public repos run their tests under the airgap agent without a safety inventory first

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[The safety inventory is a gate before the first run](0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)
of a repo's tests, and [checking skills on real repos](0071-every-skill-and-tool-is-also-checked-against-real-public-repos-by-a-persons-review-of-a-sample.md)
allowed only reading tools until a repo's inventory was clean. The gate protects an organisation's production
systems and secrets. The field trial's repos are old releases of well-known public projects, used to build and check
the toolkit's tools, not to test those projects; their history is public, and no organisation's system is named in
them.

## Considered Options

* **Run their tests without the inventory, always under the airgap agent refusing every outside call**
* **Run the safety inventory first, as for any repo**  
  Needs gitleaks on every maintainer's machine before any check, for repos whose secrets are already public

## Decision Outcome

Chosen in discussion: the field trial's public repos run their tests without a safety inventory first, and only ever
under the airgap agent with every call to another machine refused (`mode=refuse`). This holds for checking the
toolkit's own tools; running the journey itself on them, the safety inventory included, still follows the journey.
Every other repo keeps the gate.

### Consequences

* A test that would have reached a public website, as jsoup's `UrlConnectTest` would, is refused and recorded
  instead.
* The field trial's run sheet still records the safety inventory's own findings when that skill is checked.

## More Information

* Builds on: [The journey is field-trialled on old releases of well-known public repos before any organisation pilot](0050-the-journey-is-field-trialled-on-old-releases-of-well-known-public-repos-before-any-organisation-pilot.md), [The external systems list is checked on real repos against a run of every test under the airgap agent](0088-the-external-systems-list-is-checked-on-real-repos-against-a-run-of-every-test-under-the-airgap-agent.md)
* Later decisions that build on this: none yet
* Background: none
