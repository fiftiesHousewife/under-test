---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# This repo's own upkeep is kept apart from what adopting organisations use

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

`tools/` held both tools an adopting organisation runs (the backlog importer, and later the secrets scan and the
measurement run) and tools that only keep this repo in order (its own file checks, the maintainers' push script and
the hook that refuses a plain push). The toolkit backlog mixed the two the same way, under one outcome. A reader,
or an organisation deciding what to mirror, couldn't tell them apart.

## Considered Options

* **Split folders and backlog: this repo's own tools move to `maintainer-tools/`, and the backlog gets its own outcome
  for this repo's upkeep**
  `tools/` holds only what adopters run; the backlog shows how much work is upkeep
* **Split the backlog only**
  Less churn, but `tools/` stays mixed
* **Split only the README's description**
  Nothing moves; the mix stays everywhere else

## Decision Outcome

Chosen: split folders and backlog. `maintainer-tools/` holds `repo-checks`, `sync` and `git-hooks`; the backlog
importer stays in `tools/`, since organisations use it for their own backlog. The backlog outcome "This repo keeps
itself in order" holds this repo's own checks, sync, CI, licence files, tool health checks, dependency vulnerability
check and self-application. The README's "What's in this repo" splits the same way.

### Consequences

* The push script is now `maintainer-tools/sync/sync.sh`, and a clone that switched on the push hook points
  `core.hooksPath` at `maintainer-tools/git-hooks`.
* Gradle project paths change from `:tools:repo-checks` to `:maintainer-tools:repo-checks`; the task names
  (`check`, `buildDecisionIndexes`, `fixDecisionLinks`) stay the same.
* Published artifacts never include `maintainer-tools/`.

## More Information

* Builds on: [How this repository is organised](0001-how-this-repository-is-organised.md)
* Later decisions that build on this: [The README describes the journey and links every decision guide, and the build checks it does](0035-the-readme-describes-the-journey-and-links-every-decision-guide-and-the-build-checks-it-does.md), [All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md), [All our Java applies the java-conventions plugin, which holds our code-quality standards](0100-all-our-java-applies-the-java-conventions-plugin-which-holds-our-code-quality-standards.md)
* Background: none
