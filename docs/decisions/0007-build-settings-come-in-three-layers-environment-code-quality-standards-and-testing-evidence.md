---
status: proposed
decision-makers: Technical Architect
group: Using the toolkit in an organisation
---

# Build settings come in three layers: environment, code-quality standards and testing evidence

**Decided by:** Technical Architect · **Status:** proposed (agreed in discussion)

## Context and Problem Statement

Organisations that adopt the toolkit already have their own proxy, package repository, build systems and code-quality standards. Some of what the toolkit's builds do must be theirs; some must stay the same everywhere so maturity levels mean the same thing.

## Considered Options

* **Three layers. Environment (proxy, package repository, credentials) is always the organisation's own. Code-quality standards (style, complexity, copy-paste, bug and security-bug analysis, forbidden APIs) are the toolkit's defaults, which an organisation can replace or switch off. Testing evidence (coverage, flaky-test detection, mutation sampling, the acceptance check for AI-written tests, export to the assessment file) is required everywhere; only thresholds follow the organisation's decisions**  
  Fits existing standards; keeps maturity levels comparable
* **Everything can be overridden**  
  Most flexible; levels stop meaning the same thing
* **The toolkit's standards are mandatory**  
  Consistent; clashes with standards organisations already have

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option.

### Consequences

* The convention plugin's `underTest { }` settings block.
* The next four decision guides.

## More Information

* Builds on: [Organisation-specific facts and decisions live in a private overlay repo](0004-organisation-specific-facts-and-decisions-live-in-a-private-overlay-repo.md)
* Later decisions that build on this: [The build environment (proxy and package repository) comes from the organisation's own build set-up](0008-the-build-environment-proxy-and-package-repository-comes-from-the-organisations-own-build-set-up.md), [Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin](0009-code-quality-standards-can-be-the-toolkits-the-organisations-or-the-organisations-own-plugin.md), [Testing evidence is defined by standard report files, not by one build plugin](0010-testing-evidence-is-defined-by-standard-report-files-not-by-one-build-plugin.md)
* Background: none
