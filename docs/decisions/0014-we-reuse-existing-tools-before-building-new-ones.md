---
status: proposed
decision-makers: Technical Architect
group: How we work
---

# We reuse existing tools before building new ones

**Decided by:** Technical Architect · **Status:** proposed (agreed in discussion)

## Context and Problem Statement

Many needs (classification, secrets scanning, coverage, mutation testing, dependency maps) already have mature tools. Building our own costs time and needs maintaining.

## Considered Options

* **Look for existing tools first; build only what is missing, on top of them**  
  Faster and cheaper; we depend on outside projects and their licences
* **Build our own**  
  Full control; slow and costly

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. Every tool item records which existing tools were considered, and why one was chosen, in a decision record.

### Consequences

* Every piece of tool work starts with a search for existing tools.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [The toolkit provides reference build set-ups for Gradle, Maven and npm](0011-the-toolkit-provides-reference-build-set-ups-for-gradle-maven-and-npm.md), [Feature flags use the OpenFeature standard with the organisation's own flag product](0015-feature-flags-use-the-openfeature-standard-with-the-organisations-own-flag-product.md), [Each repos work is loaded into the issue tracker by one tool with an adapter per tracker](0038-each-repos-work-is-loaded-into-the-issue-tracker-by-one-tool-with-an-adapter-per-tracker.md), [The estate survey sits outside the toolkit which provides a repo classifier a survey tool can call](0040-the-estate-survey-sits-outside-the-toolkit-which-provides-a-repo-classifier-a-survey-tool-can-call.md), [Repos are classified by rules only, so results can be explained and repeated](0041-repos-are-classified-by-rules-only-so-results-can-be-explained-and-repeated.md), [Which existing tools the repo classifier combines](0042-which-existing-tools-the-repo-classifier-combines.md)
* Background: [repo-classification](../REFERENCES.md#repo-classification)
