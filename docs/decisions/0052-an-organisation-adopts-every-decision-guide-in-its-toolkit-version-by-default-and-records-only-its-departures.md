---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# An organisation adopts every decision guide in its toolkit version by default, and records only its departures

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The adoption guide asks an organisation to read every decision guide and write a record for each one, even to adopt it
as written. There are dozens of guides, so adoption starts with a long piece of paperwork before any repo is helped,
and most of the records say nothing beyond "as written".

## Considered Options

* **Every guide adopted by default, with one record naming the toolkit version and the exceptions**  
  Only departures (a choice between a guide's options, a narrowing, a replacement) get their own record; a newer
  toolkit version lists the guides that changed, so the organisation reviews only those
* **One record per journey step, written when the organisation reaches that step**  
  Fewer records than now, but still a record for every group of guides
* **Guides with one proposed outcome apply automatically; only guides that leave a choice open are recorded**  
  Fewest records, but an organisation never states that it accepts the rest

## Decision Outcome

Chosen in discussion: every guide adopted by default. The organisation repo's first decision record says that the
organisation adopts every decision guide in toolkit version X as written, except the ones its other records choose
between, narrow or replace. Each of those names the guide it departs from. When the organisation moves to a newer
toolkit version, it updates that record and reviews only the guides the release says changed.

### Consequences

* The adoption guide's step for working through the decision guides becomes: write the one adopting record, then
  record departures as they come up, the production-safety and container decisions first.
* The record-an-organisation-decision skill drafts the adopting record, and each departure naming its guide.
* Each toolkit release lists the decision guides added or changed since the last one.
* The example organisation repo shows the adopting record and one departure.

## More Information

* Builds on: [Decisions cascade from toolkit to organisation to organisation units to repos, and lower levels only enrich](0007-decisions-cascade-from-toolkit-to-organisation-to-organisation-units-to-repos-and-lower-levels-only-enrich.md), [The toolkit reaches each repo through APM, pinned to a release tag, and nothing in it is copied](0051-the-toolkit-reaches-each-repo-through-apm-pinned-to-a-release-tag-and-nothing-in-it-is-copied.md)
* Later decisions that build on this: none yet
* Background: none
