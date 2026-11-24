---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The toolkit applies itself: this repo is its own first adopter

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion) (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

A toolkit that isn't used on itself drifts from reality: awkward steps, broken schemas and stale guides go unnoticed until an organisation hits them.

## Considered Options

* **This repo adopts the toolkit exactly as an organisation would: it has its own organisation profile (in `self/`), records which decision guides it accepts, narrows or replaces for its own code, and its CI runs the installer into a scratch organisation repo and a scratch target repo and runs the checks there. Lesson examples are assessed as target repos, with assessment files and connection lists**  
  Proves every adoption step works; anything awkward for us is fixed before organisations see it
* **Test the toolkit only with unit tests**  
  Misses problems in the documents, templates and adoption flow

## Decision Outcome

Chosen in discussion: the first option. The toolkit's own adoption records sit beside its other decisions, clearly marked as self-application.

### Consequences

* `self/organisation-profile.yaml`.
* A CI job that installs into scratch repos.
* Lesson examples, in [under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons), get assessment files and connection lists too; that repo plans it.

## More Information

* Builds on: [The toolkit is installed into organisation and target repos as managed files, with a lock file](0005-the-toolkit-is-installed-into-organisation-and-target-repos-as-managed-files-with-a-lock-file.md), [Organisation-specific facts and decisions live in a private organisation repo](0003-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md)
* Later decisions that build on this: none yet
* Background: none
