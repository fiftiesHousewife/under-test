---
status: superseded
decision-makers: Toolkit maintainers
group: How we work
---

# The README describes the journey and links every decision guide, and the build checks it does

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [A short README summarises the journey, and a journey page links every decision guide, which the build checks](0042-a-short-readme-summarises-the-journey-and-a-journey-page-links-every-decision-guide-which-the-build-checks.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The README is where people learn what the toolkit is. It listed the toolkit's parts but not the journey a repo
takes, which is the point of the toolkit. The journey is settled in the decision guides, so a summary on the README
can drift from them: a new guide goes unmentioned, or one is renamed. The link check already catches renamed or
removed guides, but not new ones.

## Considered Options

* **The README's journey links every decision guide, and the repo checks fail the build if any guide isn't linked**
  A new guide can't be missed; wording is still kept in step by review
* **Each guide names its step in its front matter, and a tool writes the README's links**
  Links are always right, but the guides gain a field, and the prose still drifts
* **Review only, prompted by the decision-record skill**
  Nothing new to maintain; relies on people remembering

## Decision Outcome

Chosen: the first option. The README describes the seven steps of a repo's journey and the five phases across the
organisation; each step links the guides that settle it, and a section lists the rules that apply throughout.
`maintainer-tools/repo-checks` fails if any guide in `decision-guides/` isn't linked from the README.

### Consequences

* Adding a decision guide means placing it in the README's journey in the same pull request.
* When a guide's outcome changes, the step that summarises it is reviewed in the same pull request.
* The write-a-decision-record skill says both.

## More Information

* Builds on: [How this repository is organised](0001-how-this-repository-is-organised.md), [This repo's own upkeep is kept apart from what adopting organisations use](0034-this-repos-own-upkeep-is-kept-apart-from-what-adopting-organisations-use.md)
* Later decisions that build on this: [A short README summarises the journey, and a journey page links every decision guide, which the build checks](0042-a-short-readme-summarises-the-journey-and-a-journey-page-links-every-decision-guide-which-the-build-checks.md)
* Background: none
