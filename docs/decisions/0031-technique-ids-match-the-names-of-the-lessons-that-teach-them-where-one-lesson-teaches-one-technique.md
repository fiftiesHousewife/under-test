---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Technique ids match the names of the lessons that teach them, where one lesson teaches one technique

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Five technique ids differed from the names of the lessons that teach them, so a reader moving between the repos met two
names for one thing. Once each lesson names its techniques in its own file, matching names are no longer needed for the
link, only for the reader.

## Considered Options

* **Rename technique ids to the lesson names where one lesson teaches the whole technique**
  One name in both repos; the lesson names are the plainer English
* **Rename the lesson folders to the technique ids**
  Breaks published deck addresses and video file names
* **Keep both names**
  Nothing to change, but two names for one thing

## Decision Outcome

Chosen: rename the technique ids. Renamed:

* `fake-behind-interface` to `fake-behind-an-interface`
* `batch-file-in-file-out-tests` to `batch-file-in-file-out`
* `snapshot-testing` to `structured-output-comparison` (its name says it is also known as snapshot, approval or
  golden-master testing)

Kept: `refactoring-for-testability`, which covers more than its one lesson (replacing hard-wired dependencies; an
OpenRewrite lesson is planned), and `testcontainers`, taught by two lessons.

### Consequences

* Folders under `techniques/`, the `id`, `fallback` and `test_stand_in_approach` values that name them, and the
  technique schema's list of test stand-in approaches change. The lessons repo's links change at the same time.
* Any organisation that has already used the old ids in `tt:technique/<id>` labels renames those labels.

## More Information

* Builds on: [Each lesson names the toolkit techniques it teaches, and only the lessons repo records which lessons exist](0030-each-lesson-names-the-toolkit-techniques-it-teaches-and-only-the-lessons-repo-records-which-lessons-exist.md), [We write in plain English using the agreed word list](0020-we-write-in-plain-english-using-the-agreed-word-list.md)
* Later decisions that build on this: none yet
* Background: none
