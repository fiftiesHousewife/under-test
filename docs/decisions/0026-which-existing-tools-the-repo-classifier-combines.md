---
status: proposed
decision-makers: Toolkit maintainers
group: Understanding our repos
---

# Which existing tools the repo classifier combines

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Thousands of repos must be classified by technology stack and application type, and the systems they use must be collected for the shared-systems map.

## Considered Options

* **Combine open-source tools: a file check plus go-enry for languages; OpenRewrite search recipes for libraries, Spring Boot version, javax or jakarta, Java version; Konveyor rulesets for J2EE and vendor descriptors; Semgrep or Opengrep rules for application-type signals and addresses**  
  Low cost; every result explainable; four tools to combine
* **As above, plus Moderne for running at scale**  
  Faster across many repos; licence cost
* **A commercial portfolio product (e.g. CAST Highlight)**  
  Least to build; results go to an outside service
* **Build our own scanner**  
  Rejected by [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)

## Decision Outcome

Proposed: the first option; decide on Moderne after measuring run time on the first batch. Still to check: Konveyor's speed across thousands of repos; whether the code-hosting platform's dependency graph is available to the organisation; Moderne's licence terms.

### Consequences

* `tools/repo-classifier/` holds the combined recipe, our Semgrep rules and the scoring table.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [No repo's tests or application run until its secrets scan is clean](../../decision-guides/0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md), [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md), [Repos are classified by rules only, so results can be explained and repeated](0025-repos-are-classified-by-rules-only-so-results-can-be-explained-and-repeated.md)
* Later decisions that build on this: none yet
* Background: [repo-classification](../REFERENCES.md#repo-classification)
