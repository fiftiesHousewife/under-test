---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# A short README summarises the journey, and a journey page links every decision guide, which the build checks

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The README linked every decision guide from its step of the journey, and the build checked it did. With more than
sixty guides, the links made the README hundreds of lines long, and the journey was lost in them: a newcomer needs the
steps on one screen, not an appendix of guides.

## Considered Options

* **The README has a one-table summary of the journey; a journey page, `docs/JOURNEY.md`, describes each step and
  links every guide, and the repo checks fail if any guide isn't linked from it**  
  The README stays short; a new guide still can't be missed
* **Keep the links in the README, in an appendix at the end**  
  One file, but still hundreds of lines
* **Drop the check, and rely on the decision guides' own index**  
  The index lists every guide, but by group, not by step, so a new guide's place in the journey is never decided

## Decision Outcome

Chosen in discussion: the first option. It replaces
[The README describes the journey and links every decision guide, and the build checks it does](0035-the-readme-describes-the-journey-and-links-every-decision-guide-and-the-build-checks-it-does.md).

### Consequences

* `maintainer-tools/repo-checks` checks `docs/JOURNEY.md` instead of the README.
* Adding a decision guide means placing it in its step on the journey page in the same pull request; when a guide's
  outcome changes, its step there is reviewed, and the README's one line for that step if it no longer holds.
* The write-a-decision-record skill says both.

## More Information

* Builds on: [The README describes the journey and links every decision guide, and the build checks it does](0035-the-readme-describes-the-journey-and-links-every-decision-guide-and-the-build-checks-it-does.md)
* Later decisions that build on this: none yet
* Background: none
