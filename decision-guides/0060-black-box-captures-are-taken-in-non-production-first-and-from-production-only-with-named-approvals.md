---
status: proposed
decision-makers: Security and Platform Owner (can veto), with the data owner
group: Capturing current behaviour
---

# Black-box captures are taken in non-production first, and from production only with named approvals

**Decided by:** Security and Platform Owner (can veto), with the data owner · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Recording what an application receives and sends is the quickest way to pin its current behaviour. Where the capture
happens decides who must approve it: non-production environments usually hold copied or synthetic data, production
holds real customers' data.

## Considered Options

* **Non-production first; production only with the data owner's and the Security and Platform Owner's approval, and a
  data protection impact assessment**  
  Most captures need no special approval; production stays possible where nothing else will do
* **Non-production only**  
  Simplest, but some behaviour only shows in production traffic
* **Each team chooses**  
  Inconsistent, and hard to audit

## Decision Outcome

Proposed: non-production first, production only with named approvals, the default the toolkit maintainers chose in
discussion, from [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md).
Capturing, cleaning and checking production data all happen inside production's boundary.

### Consequences

* Each capture is recorded in the assessment file with its environment and its approvals.
* A production capture needs a data protection impact assessment, which the Data Protection Officer reviews.

## More Information

* Builds on: [Old code runs first only where production cannot be reached](0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [Order of preference for where current behaviour is captured](0061-order-of-preference-for-where-current-behaviour-is-captured.md)
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md)
