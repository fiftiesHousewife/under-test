---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Testing guides and shared test kits belong to each organisation, and the toolkit provides templates for them

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[How this repository is organised](0001-how-this-repository-is-organised.md) gave the toolkit a `testing-guides/` folder
and a `shared-test-kits/` folder. Both stayed empty. A testing guide is worked out on one of the organisation's own
pilot applications (see the decision guide on one pilot application per common pair), and a shared test kit stands in
for one of the organisation's own shared systems. Both are organisation-specific, which
[Organisation-specific facts and decisions live in a private organisation repo](0003-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md)
keeps out of this repo, and the organisation's starting backlog already plans both as programme work.

## Considered Options

* **Templates only: the toolkit provides a template for a testing guide and one for a shared test kit; the guides and
  kits live in each organisation repo**
  Every organisation starts from the same shape; nothing organisation-specific in the toolkit
* **Remove both, with no template**
  Less to keep, but each organisation invents its own shape
* **Keep generic testing guides per technology stack in the toolkit, which organisations narrow**
  A head start, but defaults written before any pilot would be guesses

## Decision Outcome

Chosen: templates only. The empty `testing-guides/` and `shared-test-kits/` folders are removed;
[templates/testing-guide.md](../../templates/testing-guide.md) and
[templates/shared-test-kit.md](../../templates/shared-test-kit.md) are added.

### Consequences

* An organisation repo holds `testing-guides/technology-stacks/<id>.md`, `testing-guides/application-types/<id>.md`
  and `shared-test-kits/<system-id>/`, started from the templates.
* Testing guides refer to techniques by id and never copy their rules, as before.
* The toolkit's build no longer looks for shared test kits to build.

## More Information

* Builds on: [How this repository is organised](0001-how-this-repository-is-organised.md), [Organisation-specific facts and decisions live in a private organisation repo](0003-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md)
* Later decisions that build on this: none yet
* Background: none
