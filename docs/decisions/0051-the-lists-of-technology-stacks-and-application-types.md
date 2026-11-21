---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Understanding our repos
---

# The lists of technology stacks and application types

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

## Context and Problem Statement

Agreed in discussion: classification has two parts. The technology stack decides which test tools to use; the application type decides where the edges are, what to record, and the target test mix.

## Considered Options

* **Technology stacks: EJB on WebSphere or WebLogic; Spring with XML configuration; Spring Boot 2-3; Spring Boot 4; Angular; React; AngularJS; Node. Application types: web service; batch job; message consumer; web UI; back-end-for-front-end; shared library**  
  Covers the technology range in scope
* **Start smaller and add as the review list shows need**  
  Less up front; early repos fall into the review list

## Decision Outcome

Proposed: the first list, extended when a pattern recurs in the review list.

### Consequences

* `testing-guides/technology-stacks/` and `testing-guides/application-types/`.

## More Information

* Builds on: [Repos are classified by rules only, so results can be explained and repeated](0049-repos-are-classified-by-rules-only-so-results-can-be-explained-and-repeated.md)
* Later decisions that build on this: [Target test mix for each application type and the top-heavy phase at level 2](0036-target-test-mix-for-each-application-type-and-the-top-heavy-phase-at-level-2.md), [One pilot application per common technology stack and application type pair](0072-one-pilot-application-per-common-technology-stack-and-application-type-pair.md)
* Background: none
