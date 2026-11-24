---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A lesson that teaches a step of the journey names that step's skill, not a technique

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Each lesson names the toolkit techniques it teaches. One lesson, running old code unplugged, teaches running an old
service's tests under the airgap agent until every outside call has a stand-in, and turning the agent's report into the
connection list. That is not a technique the
[choose-techniques](../../.github/skills/choose-techniques/SKILL.md) skill adopts or defers for a repo: every repo
does it, as a step of [its journey](../JOURNEY.md), with the
[draft-the-connection-list](../../.github/skills/draft-the-external-systems-list/SKILL.md) skill and then the
make-it-run-on-its-own workstream. The nearest technique, recorded HTTP responses, covers only one kind of stand-in.

## Considered Options

* **A lesson may name the skills of the journey steps it teaches, as well as or instead of techniques**  
  The lesson points at what a reader will actually run; the technique rules stay a list of choices that differ from
  repo to repo, and the choose-techniques eval case is unchanged
* **Add a technique for it, `running-old-code-unplugged`**  
  One kind of link only, but a rule that is always needed when a repo has connections decides nothing, and it would
  repeat the journey step in the technique list
* **Keep naming recorded HTTP responses**  
  Nothing to change, but the lesson teaches more than that technique, and readers are sent to the wrong rule

## Decision Outcome

Chosen: the first option. A lesson names the skill of each journey step it teaches by its folder name under
`.github/skills/` (running old code unplugged names `draft-the-connection-list`), and the lessons repo's build checks
those names against this repo's skills as it does technique ids. The lessons repo records how its `lesson.yaml` holds
them.

### Consequences

* Renaming or removing a journey skill here needs the same change in the lessons repo, as for techniques. Push the
  toolkit change first.
* No technique is added; the technique rules and the choose-techniques eval case stay as they are.

## More Information

* Builds on: [Each lesson names the toolkit techniques it teaches, and only the lessons repo records which lessons exist](0030-each-lesson-names-the-toolkit-techniques-it-teaches-and-only-the-lessons-repo-records-which-lessons-exist.md), [Technique ids match the names of the lessons that teach them, where one lesson teaches one technique](0031-technique-ids-match-the-names-of-the-lessons-that-teach-them-where-one-lesson-teaches-one-technique.md)
* Later decisions that build on this: none yet
* Background: none
