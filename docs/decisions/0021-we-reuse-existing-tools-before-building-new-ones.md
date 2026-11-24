---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# We reuse existing tools before building new ones

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion) (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Many needs (classification, secrets scanning, coverage, mutation testing, dependency maps) already have mature tools. Building our own costs time and needs maintaining.

## Considered Options

* **Look for existing tools first; build only what is missing, on top of them**  
  Faster and cheaper; we depend on outside projects and their licences
* **Build our own**  
  Full control; slow and costly

## Decision Outcome

Chosen in discussion: the first option. Every tool item records which existing tools were considered, and why one was chosen, in a decision record.

### Consequences

* Every piece of tool work starts with a search for existing tools.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [The organisation repo refers to the toolkit by version through the organisation's package repository](0004-the-organisation-repo-refers-to-the-toolkit-by-version-through-the-organisations-package-repository.md), [The toolkit is installed into organisation and target repos as managed files, with a lock file](0005-the-toolkit-is-installed-into-organisation-and-target-repos-as-managed-files-with-a-lock-file.md), [The toolkit provides reference build set-ups for Gradle, Maven and npm](0015-the-toolkit-provides-reference-build-set-ups-for-gradle-maven-and-npm.md), [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md), [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md), [Feature flags use the OpenFeature standard with the organisation's own flag product](../../decision-guides/0004-feature-flags-use-the-openfeature-standard-with-the-organisations-own-flag-product.md), [Each repo's work is loaded into the issue tracker by one tool, with an adapter per tracker](0023-each-repos-work-is-loaded-into-the-issue-tracker-by-one-tool-with-an-adapter-per-tracker.md), [The estate survey sits outside the toolkit, which provides a repo classifier a survey tool can call](0024-the-estate-survey-sits-outside-the-toolkit-which-provides-a-repo-classifier-a-survey-tool-can-call.md), [Repos are classified by rules only, so results can be explained and repeated](0025-repos-are-classified-by-rules-only-so-results-can-be-explained-and-repeated.md), [Which existing tools the repo classifier combines](0026-which-existing-tools-the-repo-classifier-combines.md), [Each application's connections are recorded as a CALM connection list](../../decision-guides/0030-each-applications-connections-are-recorded-as-a-calm-connection-list.md), [Knowledge sources are listed by the knowledge curator and read through Allium skills with a citation addendum](../../decision-guides/0034-knowledge-sources-are-listed-by-the-knowledge-curator-and-read-through-allium-skills-with-a-citation-addendum.md), [Contract tests share pacts as versioned artifacts through the package repository, without a broker](../../decision-guides/0037-contract-tests-share-pacts-as-versioned-artifacts-through-the-package-repository-without-a-broker.md)
* Background: [repo-classification](../REFERENCES.md#repo-classification)
