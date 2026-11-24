---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Lessons live in their own repo, with a copy of the build conventions

**Decided by:** Toolkit maintainers · **Status:** accepted

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Lessons serve anyone learning testing; the toolkit serves organisations running a programme. Lessons and videos change faster and are heavier. But lessons build on the toolkit's convention plugin, which isn't published yet, and the technique rules belong to the toolkit because its tools read them.

## Considered Options

* **Separate repo now, with a copy of the toolkit's build conventions**
  Lessons build on their own straight away; the copy may drift from the toolkit's, but lessons only need the
  conventions to build and check their examples
* **Keep one repo until the convention plugin is published, then split**
  No copy to keep in step, but lessons and videos (heavier, changing faster) stay mixed with the toolkit until then
* **Keep lessons and rules together for good**
  Harder to split later, and organisations receive lesson media they may not want

## Decision Outcome

Chosen: separate repo now. Lessons, their videos and the video tools live in
[under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons), with a copy of the toolkit's build
conventions and quality rules. No plugin is published for this. Technique rules stay in this repo, in
`techniques/<id>/technique.yaml`. Links between the two repos are full URLs. The lessons bundle (each lesson's video
layers, captions and scripts) is published from the lessons repo.

### Consequences

* This repo holds no lesson material; `techniques/` holds rules only and links to each lesson by URL.
* The lessons repo keeps its own copy of the build conventions; changes worth sharing are copied across by hand.
* Each repo has its own build, checks and backlog.

## More Information

* Builds on: [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md), [How this repository is organised](0001-how-this-repository-is-organised.md)
* Later decisions that build on this: [Each lesson names the toolkit techniques it teaches, and only the lessons repo records which lessons exist](0030-each-lesson-names-the-toolkit-techniques-it-teaches-and-only-the-lessons-repo-records-which-lessons-exist.md), [Lesson work and lesson decisions are planned and recorded in the lessons repo](0032-lesson-work-and-lesson-decisions-are-planned-and-recorded-in-the-lessons-repo.md), [All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md)
* Background: none
