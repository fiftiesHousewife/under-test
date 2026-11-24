---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Understanding what a system should do
---

# Every repo starts with discovery: a draft external systems list, a source list and a check of its existing tests, and a first approval-test baseline follows

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Setting coverage targets before anyone knows what a repo connects to, what its tests already do, what it does today, or where knowledge about it lives leads to tests that pin the wrong things. Pinning current behaviour first is also the cheapest protection against change, especially before a migration.

## Considered Options

* **Every repo starts with a discovery step that produces a draft external systems list, a source list and a check of its existing tests. A first baseline of approval tests, pinning current behaviour at the code's edges, follows in the next step, before the testing plan, as a safety net; the "record current behaviour" workstream extends it across the code as the plan sets out. Coverage targets apply only once discovery is done; approval tests are the first tests added to every legacy repo**  
  Tests rest on what the system actually does and connects to
* **Discovery only for high-criticality repos**  
  Cheaper; lower-criticality repos get targets without that grounding
* **No separate step**  
  Simpler; targets set blind

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option.

Discovery follows the safety inventory, once its blocking findings are resolved. The draft external systems list starts
from the airgap agent's report of every call the repo's first run tried to make. Discovery also takes stock of the
tests the repo already has and the test assets outside it, with their anti-patterns. The first approval-test baseline is
recorded in the step after discovery, at the code's edges and before the testing plan, as a safety net. It is built
from captured and cleaned behaviour, as the capture guides set out, and the "record current behaviour" workstream
later extends it across the code as the plan sets out. See
[Order of preference for where current behaviour is captured](0061-order-of-preference-for-where-current-behaviour-is-captured.md)
and [Captured data is cleaned inside the environment it was captured in, before it is copied anywhere](0062-captured-data-is-cleaned-inside-the-environment-it-was-captured-in-before-it-is-copied-anywhere.md).

### Consequences

* Discovery comes before any workstream.
* The assessment file records whether discovery is complete.
* Existing tests and test assets: [Test assets outside the repo are mined for behaviour, and kept running until repo tests replace them](0058-test-assets-outside-the-repo-are-mined-for-behaviour-and-kept-running-until-repo-tests-replace-them.md)
  and [Anti-patterns in existing tests are recorded and triaged, and no existing test is deleted before the approval-test baseline exists](0059-anti-patterns-in-existing-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md).

## More Information

* Builds on: [Before any test or application runs, a safety inventory records what could reach production or real data, and some findings block the run](0057-before-any-test-or-application-runs-a-safety-inventory-records-what-could-reach-production-or-real-data-and-some-findings-block-the-run.md), [Each application's external systems are recorded as a CALM list](0030-each-applications-external-systems-are-recorded-as-a-calm-list.md), [Each application also has a knowledge curator and an architecture owner](0002-each-application-also-has-a-knowledge-curator-and-an-architecture-owner.md)
* Later decisions that build on this: [Behaviour is captured in two tracks, current and intended, and every difference is an open question](0033-behaviour-is-captured-in-two-tracks-current-and-intended-and-every-difference-is-an-open-question.md)
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code)
