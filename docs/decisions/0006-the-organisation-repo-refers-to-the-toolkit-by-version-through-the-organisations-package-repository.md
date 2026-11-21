---
status: proposed
decision-makers: Technical Architect
group: Using the toolkit in an organisation
---

# The organisation repo refers to the toolkit by version through the organisation's package repository

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

Inside a corporate network, nothing can be fetched from public code-hosting sites. The organisation repo still has to say which toolkit it builds on, and tools still have to read the toolkit's guides, schemas and skills.

## Considered Options

* **Each toolkit release is published as versioned artifacts on Maven Central: the convention plugin, the skills bundle, and a content bundle (decision guides, schemas, technique rules). The organisation's package repository already mirrors Maven Central. The organisation repo names one toolkit version in its profile; tools read that version's artifacts. An optional internal mirror of the toolkit's source lets people browse it**  
  Uses the route every library already takes; no new approvals; offline-friendly
* **The organisation repo refers to the toolkit's public Git address**  
  Blocked in most corporate networks
* **The organisation copies the toolkit's files into its own repo**  
  Copies drift; that's a fork in disguise

## Decision Outcome

Proposed: the first option. Upgrading the toolkit is a one-line change to the version in the organisation profile, made by pull request.

### Consequences

* `toolkit` in the organisation profile schema.
* A content bundle artifact published with each release.

## More Information

* Builds on: [Organisation-specific facts and decisions live in a private organisation repo](0005-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md), [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: none yet
* Background: none
