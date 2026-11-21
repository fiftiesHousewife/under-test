---
status: proposed
decision-makers: Technical Architect
group: How we work
---

# Organisation-specific facts and decisions live in a private overlay repo

**Decided by:** Technical Architect · **Status:** proposed (agreed in discussion)

## Context and Problem Statement

This toolkit is meant to be reusable and may be public. Every organisation that uses it has facts it can't choose (its CI platform, issue tracker, package repository, approved AI assistants) and decisions of its own. Putting those here would publish them and tie the toolkit to one organisation.

## Considered Options

* **A private overlay repo per organisation, holding an organisation profile (facts, checked against a schema published here) and the organisation's own decision records, each naming the toolkit decision it adopts, narrows or replaces. Tools here read the profile. A skill writes organisation decisions into the overlay repo only**  
  The toolkit stays generic and safe to publish; each organisation keeps its own details private
* **An untracked folder in this repo**  
  Easy to commit by mistake; not shared with the team
* **Organisation decisions numbered after the generic ones, in this repo**  
  Publishes organisation details

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. Facts with no choice go in the profile, not in decision records. Decision records here are written as guides: they give the options and say which fits which situation.

### Consequences

* `schema/organisation-profile.schema.json` and `examples/organisation-overlay/`.
* The record-an-organisation-decision skill.
* A check in this repo's build that flags organisation-specific words.

## More Information

* Builds on: [How this repository is organised](0003-how-this-repository-is-organised.md)
* Later decisions that build on this: [Feature flags use the openfeature standard with the organisation's own flag product](0009-feature-flags-use-the-openfeature-standard-with-the-organisations-own-flag-product.md)
* Background: none
