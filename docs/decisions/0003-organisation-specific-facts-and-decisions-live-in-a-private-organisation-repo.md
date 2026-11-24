---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# Organisation-specific facts and decisions live in a private organisation repo

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion) (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

This toolkit is meant to be reusable and may be public. Every organisation that uses it has facts it can't choose (its CI platform, issue tracker, package repository, approved AI assistants) and decisions of its own. Putting those here would publish them and tie the toolkit to one organisation.

## Considered Options

* **A private organisation repo per organisation, holding an organisation profile (facts, checked against a schema published here) and the organisation's own decision records, each naming the toolkit decision it adopts, narrows or replaces. Tools here read the profile. A skill writes organisation decisions into the organisation repo only**  
  The toolkit stays generic and safe to publish; each organisation keeps its own details private
* **An untracked folder in this repo**  
  Easy to commit by mistake; not shared with the team
* **Organisation decisions numbered after the generic ones, in this repo**  
  Publishes organisation details

## Decision Outcome

Chosen in discussion: the first option. Facts with no choice go in the profile, not in decision records. Decision records here are written as guides: they give the options and say which fits which situation.

### Consequences

* `schema/organisation-profile.schema.json` and `examples/organisation-repo/`.
* The record-an-organisation-decision skill.
* A check in this repo's build that flags organisation-specific words.

## More Information

* Builds on: [How this repository is organised](0001-how-this-repository-is-organised.md)
* Later decisions that build on this: [The organisation repo refers to the toolkit by version through the organisation's package repository](0004-the-organisation-repo-refers-to-the-toolkit-by-version-through-the-organisations-package-repository.md), [The toolkit applies itself: this repo is its own first adopter](0006-the-toolkit-applies-itself-this-repo-is-its-own-first-adopter.md), [Decisions cascade from toolkit to organisation to organisation units to repos, and lower levels only enrich](0007-decisions-cascade-from-toolkit-to-organisation-to-organisation-units-to-repos-and-lower-levels-only-enrich.md), [Build settings come in three layers: environment, code-quality standards and testing evidence](0011-build-settings-come-in-three-layers-environment-code-quality-standards-and-testing-evidence.md), [Lesson videos ship as editable layers, so organisations can rebrand, trim and revoice them](0018-lesson-videos-ship-as-editable-layers-so-organisations-can-rebrand-trim-and-revoice-them.md), [Feature flags use the OpenFeature standard with the organisation's own flag product](../../decision-guides/0004-feature-flags-use-the-openfeature-standard-with-the-organisations-own-flag-product.md), [When the organisation requires it, every commit names its work item](../../decision-guides/0028-when-the-organisation-requires-it-every-commit-names-its-work-item.md)
* Background: none
