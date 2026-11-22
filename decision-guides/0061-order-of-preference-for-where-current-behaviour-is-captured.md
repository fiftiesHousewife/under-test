---
status: proposed
decision-makers: Technical Architect
group: Capturing current behaviour
---

# Order of preference for where current behaviour is captured

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Behaviour can be captured in many places: generated examples, a recording proxy, a filter inside the application,
copies from queues and files, database subsets, or production traffic. Each carries different risk, needs different
approval, and suits different connections. The airgap agent's report shows which connections a repo has, and so where
recording is worth doing.

## Considered Options

* **Take the first that fits: generated examples; a recording proxy in non-production; a filter inside the
  application in a test environment; read-only copies from queues and batch files; database subsets; production
  capture only with named approvals; Keploy only after its trial. Packet capture and proxies that intercept encrypted
  traffic are ruled out**  
  The least risky capture that gives the behaviour needed, every time
* **Each team chooses**  
  Inconsistent; the riskiest capture is often the easiest

## Decision Outcome

Proposed: the order, the default the toolkit maintainers chose in discussion, from
[capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md):

1. **Generated examples** (Datafaker), where invented data shows the behaviour.
2. **A recording proxy** in non-production (WireMock's record mode), placed using the airgap agent's report.
3. **A filter inside the application** in a test environment (Logbook, or a small filter for applications on JDK 8).
4. **Read-only copies from queues and files:** a separate Kafka consumer group, a JMS queue browser, copies of a batch
   run's input and output.
5. **Database subsets** taken with Jailer from a non-production copy.
6. **Production capture,** only with the approvals in
   [Black-box captures are taken in non-production first, and from production only with named approvals](0060-black-box-captures-are-taken-in-non-production-first-and-from-production-only-with-named-approvals.md).
7. **Keploy,** only once [its trial](../docs/decisions/0037-keploy-is-trialled-on-a-pilot-application-to-record-current-behaviour-from-real-traffic.md) passes.

Packet capture and proxies that intercept encrypted traffic (mitmproxy) are ruled out: they need a trusted root
certificate or elevated rights, and see other people's traffic.

### Consequences

* A skill (planned) that turns the airgap agent's report into a recording plan: which connections to record, where
  and how.
* A recording proxy or a filter inside the application in a test environment goes in only through the platform's
  control layers (see [Using the toolkit inside a corporate network](../docs/CORPORATE-USE.md)).
* Technique files for recorded responses, structured-output comparison and record and replay name their capture tools.

## More Information

* Builds on: [Black-box captures are taken in non-production first, and from production only with named approvals](0060-black-box-captures-are-taken-in-non-production-first-and-from-production-only-with-named-approvals.md), [Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md)
* Later decisions that build on this: [Captured data is cleaned inside the environment it was captured in, before it is copied anywhere](0062-captured-data-is-cleaned-inside-the-environment-it-was-captured-in-before-it-is-copied-anywhere.md)
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md); [the airgap agent's design](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/docs/design.md)
