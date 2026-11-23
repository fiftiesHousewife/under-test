---
status: superseded
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The toolkit is installed into organisation and target repos as managed files, with a lock file

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [The toolkit reaches each repo through APM, pinned to a release tag, and nothing in it is copied](0051-the-toolkit-reaches-each-repo-through-apm-pinned-to-a-release-tag-and-nothing-in-it-is-copied.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Decision guides, the glossary, references, templates and skills can't be used as a library: people and AI assistants need them as files in the repo, to read, link to and record decisions against. Copying them by hand drifts.

## Considered Options

* **An installer, delivered as tasks in the toolkit's Gradle plugin (Maven and npm versions later), unpacks the content bundle for the pinned toolkit version. In the organisation repo it installs decision guides, glossary, references, templates and schemas; in each target repo it installs AI assistant skills and instructions, the glossary and repo-level templates. A lock file records each managed file's version and checksum; upgrades change only managed files, report local edits instead of overwriting them, and arrive as one reviewable pull request. Organisation additions live in separate folders the installer never touches**  
  Same pattern as APM for skills and Copier for templates; uses an approved route
* **Copier or cruft templates**  
  Proven update mechanism; needs Python tools that may not be approved
* **APM for everything**  
  Handles skills well; not designed for documents and templates; often not approved
* **Git subtree from an internal mirror**  
  Only needs Git; awkward to update and to keep organisation additions separate

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. It replaces the separate installSkills task: installing skills becomes one part of the installer.

### Consequences

* `underTestInstall` (organisation repo and target repo modes) and its lock file format, with a schema.
* The content bundle carries everything the installer places.

## More Information

* Builds on: [The organisation repo refers to the toolkit by version through the organisation's package repository](0004-the-organisation-repo-refers-to-the-toolkit-by-version-through-the-organisations-package-repository.md), [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: [The toolkit applies itself: this repo is its own first adopter](0006-the-toolkit-applies-itself-this-repo-is-its-own-first-adopter.md)
* Background: none
