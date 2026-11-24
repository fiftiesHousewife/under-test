---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# An accepted record that later records narrow gets a narrowed-by line, and back-links are generated

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

An accepted record is never edited: a change of mind is a new record that replaces it
([Decision records follow MADR and are approved by pull request review](0010-decision-records-follow-madr-and-are-approved-by-pull-request-review.md)).
Many later records narrow an earlier one without contradicting all of it: a repo may now be built before the safety
gate, which the record making the gate didn't allow; discovery's three lists took the meaningless and unreliable
tests out of repair. A reader of the earlier record can't see that it no longer holds in full. Each record's "Later
decisions that build on this" line, written by hand, has the same problem: keeping it current means editing an
accepted record, so it goes stale.

## Considered Options

* **A narrowed-by line, and back-links generated from the "Builds on" lines**  
  Two small, marked additions to an accepted record; the rest of it stays as accepted
* **Replace every record a later one narrows**  
  No accepted record is ever touched, but each narrowing restates a whole record, and the chain of replacements grows
* **Leave accepted records as they are**  
  Readers search for later records themselves, and the back-links stay stale

## Decision Outcome

Chosen in discussion: an accepted record is still never edited, except for two things:

* **a narrowed-by line** under its Status line, a quoted line starting "Narrowed by" and linking each record by its
  title, added when a later accepted record narrows it without replacing it;
* **its "Later decisions that build on this" line**, which `buildDecisionIndexes` writes from the other records'
  "Builds on" lines.

A link's target may also be repaired when the file it points at is renamed. A record that a later one contradicts in
full still gets a replacing record, and is marked superseded with a `> Replaced by` line.

### Consequences

* `buildDecisionIndexes` in [`maintainer-tools/repo-checks`](../../maintainer-tools/repo-checks/build.gradle.kts)
  gains the step that writes each record's back-links.
* The records already narrowed get their lines in the same change.
* The [write-a-decision-record](../../.github/skills/write-a-decision-record/SKILL.md) skill and the
  [template](template.md) say when to add a narrowed-by line.

## More Information

* Builds on: [Decision records follow MADR and are approved by pull request review](0010-decision-records-follow-madr-and-are-approved-by-pull-request-review.md)
* Later decisions that build on this: none yet
* Background: none
