---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Understanding what a system should do
---

# Every repo starts with discovery: a draft connection list, an approval-test baseline and a source list

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Setting coverage targets before anyone knows what a repo connects to, what it does today, or where knowledge about it lives leads to tests that pin the wrong things. Pinning current behaviour first is also the cheapest protection against change, especially before a migration.

## Considered Options

* **Every repo starts with a discovery step that produces a draft connection list, a baseline of approval tests pinning current behaviour at its edges, and a source list. Coverage targets apply only once discovery is done; approval tests are the first deliverable on every legacy repo**  
  Tests rest on what the system actually does and connects to
* **Discovery only for high-criticality repos**  
  Cheaper; lower-criticality repos get targets without that grounding
* **No separate step**  
  Simpler; targets set blind

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option.

### Consequences

* The order of workstreams starts with discovery.
* The assessment file records whether discovery is complete.

## More Information

* Builds on: [Each application's connections are recorded as a CALM connection list](0030-each-applications-connections-are-recorded-as-a-calm-connection-list.md), [Each application also has a knowledge curator and an architecture owner](0002-each-application-also-has-a-knowledge-curator-and-an-architecture-owner.md)
* Later decisions that build on this: [Behaviour is captured in two tracks, current and intended, and every difference is an open question](0033-behaviour-is-captured-in-two-tracks-current-and-intended-and-every-difference-is-an-open-question.md)
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code)
