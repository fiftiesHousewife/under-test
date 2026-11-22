---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Each lesson names the toolkit techniques it teaches, and only the lessons repo records which lessons exist

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Technique rules live here, in `techniques/<id>/technique.yaml`; the lessons that teach them live in
[under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons). Which lesson teaches which technique was
written down four times by hand: an `example` status in each technique file, this repo's techniques table, the lessons
catalogue and the lessons index. They disagreed: twelve built lessons were still marked "to do" here, six TypeScript
lessons were promised although the lessons are Java only, and five technique ids differed from their lessons' names.

## Considered Options

* **Each lesson declares the techniques it teaches, in a `lesson.yaml` with a schema in the lessons repo; the lessons
  repo's build checks its catalogue, its index and its links against a checkout of this repo. This repo records
  nothing about lessons.**
  One record of the link, and the dependency runs one way only (the lessons repo already depends on this one)
* **Each technique file lists its lessons, and the lessons repo is checked against those files**
  This repo would have to follow the progress of another repo's work
* **One file per technique holding both its rules and its lessons, copied between the repos**
  Simplest to read, but one repo always holds a copy of the other's files

## Decision Outcome

Chosen: the first option. The `example` field is removed from the technique schema and from every technique file, and
[techniques/README.md](../../techniques/README.md) links to the lessons catalogue instead of listing lesson status. The
lessons repo records the same decision as
[Each lesson names the toolkit techniques it teaches, and the build checks both repos agree](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/docs/decisions/0007-each-lesson-names-the-toolkit-techniques-it-teaches-and-the-build-checks-both-repos-agree.md).

### Consequences

* Renaming, adding or removing a technique here needs the same change in the lessons repo, whose CI fails until it is
  made (it checks out this repo's main branch). Push the toolkit change first.
* A technique with no lesson yet is fine here; the lessons catalogue says when its lesson is planned.

## More Information

* Builds on: [Lessons live in their own repo, with a copy of the build conventions](0017-lessons-live-in-their-own-repo-with-a-copy-of-the-build-conventions.md)
* Later decisions that build on this: [Technique ids match the names of the lessons that teach them, where one lesson teaches one technique](0031-technique-ids-match-the-names-of-the-lessons-that-teach-them-where-one-lesson-teaches-one-technique.md)
* Background: none
