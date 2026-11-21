---
status: proposed
decision-makers: Technical Architect
group: How we work
---

# Feature flags use the OpenFeature standard with the organisation's own flag product

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

Feature flags let changed code be switched on and off without a release. Organisations already use different flag products, and the toolkit must not depend on any one of them.

## Considered Options

* **Code and lessons use the OpenFeature API, a vendor-neutral open standard; the organisation's flag product plugs in as an OpenFeature provider, named in its organisation profile**  
  Works with any product that has a provider; one way of writing flag checks everywhere
* **Use one flag product's own API directly**  
  Ties every repo to that product
* **Hand-written flags in configuration files**  
  No product needed; no gradual release, audit trail or remote switch-off

## Decision Outcome

Proposed: the first option.

### Consequences

* `feature_flags` in the organisation profile schema.
* The feature flags lesson uses OpenFeature with an in-memory provider.

## More Information

* Builds on: [We reuse existing tools before building new ones](0020-we-reuse-existing-tools-before-building-new-ones.md), [Organisation-specific facts and decisions live in a private organisation repo](0005-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md)
* Later decisions that build on this: [Feature flags are used to change legacy code safely and to release gradually](0068-feature-flags-are-used-to-change-legacy-code-safely-and-to-release-gradually.md)
* Background: [feature-flags](../REFERENCES.md#feature-flags)
