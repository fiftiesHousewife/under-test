---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Lesson work and lesson decisions are planned and recorded in the lessons repo

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

After lessons moved to [under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons), this repo still
carried their plan: an outcome with about forty lesson and video items in its backlog, two proposed decisions about
lessons and videos, and a guide to rebranding lesson videos. The lessons repo had meanwhile built most of those lessons,
made its own decisions about videos, and kept its own plan, so the two plans disagreed.

## Considered Options

* **Move every lesson item, decision and guide that the lessons repo doesn't already cover into it, then remove them
  here, leaving links**
  One plan for lessons; nothing is lost, because each item is carried over before it is removed
* **Keep the lesson items here as the programme's view of lesson work**
  Two plans that drift, as they already had

## Decision Outcome

Chosen: move, then remove. The lessons repo records the same decision as
[Lesson work and decisions moved over from the toolkit are planned here](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/docs/decisions/0008-lesson-work-and-decisions-moved-over-from-the-toolkit-are-planned-here.md),
with what it took over.

### Consequences

* The outcome "People can learn every testing technique from a lesson and a runnable example" and its items leave
  [plan/toolkit-backlog.yaml](../../plan/toolkit-backlog.yaml); the next import closes their issues as not planned.
* [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md)
  and [Lesson videos ship as editable layers, so organisations can rebrand, trim and revoice them](0018-lesson-videos-ship-as-editable-layers-so-organisations-can-rebrand-trim-and-revoice-them.md)
  are replaced by this record and the lessons repo's own decisions.
* The guide to rebranding lesson videos moves from [docs/CORPORATE-USE.md](../CORPORATE-USE.md) to the lessons repo's
  guide to using the lessons inside a company.
* Decision guides that promise a lesson link to it, or to the lessons catalogue, by URL.

## More Information

* Builds on: [Lessons live in their own repo, with a copy of the build conventions](0017-lessons-live-in-their-own-repo-with-a-copy-of-the-build-conventions.md)
* Later decisions that build on this: none yet
* Background: none
