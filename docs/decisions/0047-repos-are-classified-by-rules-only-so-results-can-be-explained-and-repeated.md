---
status: proposed
decision-makers: Technical Architect
group: Understanding our repos
---

# Repos are classified by rules only, so results can be explained and repeated

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

A repo owner who disputes their plan needs to see why their repo was classified as it was.

## Considered Options

* **Rules only**  
  Same answer every time; easy to explain
* **Rules plus similarity clustering to suggest new categories**  
  Finds categories nobody named; needs a person to confirm
* **AI classification**  
  Not repeatable; ruled out by decision 0022

## Decision Outcome

Proposed: rules only. Repos that match no rule go to a review list; a recurring pattern becomes a new rule.

### Consequences

* Classification rules file (the classification rules).

## More Information

* Builds on: [We reuse existing tools before building new ones](0020-we-reuse-existing-tools-before-building-new-ones.md), [People do the work with AI coding assistance, and review everything it produces](0022-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md)
* Later decisions that build on this: [Which existing tools the repo classifier combines](0048-which-existing-tools-the-repo-classifier-combines.md), [The lists of technology stacks and application types](0049-the-lists-of-technology-stacks-and-application-types.md)
* Background: [repo-classification](../REFERENCES.md#repo-classification)
