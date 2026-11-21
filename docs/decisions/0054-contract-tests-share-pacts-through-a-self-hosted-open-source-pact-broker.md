---
status: proposed
decision-makers: Technical Architect, approved by the Security and Platform Owner
group: Standing in for real systems
---

# Contract tests share pacts through a self-hosted open-source Pact Broker

**Decided by:** Technical Architect, approved by the Security and Platform Owner · **Status:** proposed

## Context and Problem Statement

Contract tests between in-house services need somewhere to share contracts (pacts), record which versions are verified and deployed where, and answer 'can I deploy this version?' before a release.

## Considered Options

* **The open-source Pact Broker (MIT), self-hosted on the organisation's own platform with its official Helm chart and container image (pinned by digest) and the organisation's PostgreSQL; pipelines use the Rust broker client (`pact-broker-cli`, or the all-in-one `pact` image), not the older Ruby client. Pending pacts switched on so new consumers don't break provider builds**  
  Free; can-i-deploy, environments, deployment records, webhooks; only basic authentication (no single sign-on or per-team permissions)
* **PactFlow (commercial, SmartBear), hosted or on-premises**  
  Adds single sign-on, permissions, audit trail and bi-directional contracts from OpenAPI; licence cost
* **No broker: share pact files through the package repository or Git**  
  Nothing to run; loses can-i-deploy, deployment tracking and pending pacts. Suitable for a pilot only
* **Spring Cloud Contract, Specmatic or Microcks instead of Pact**  
  Each fits a narrower case (JVM-only stubs; OpenAPI-led tests; mocking and conformance) and none offers a can-i-deploy matrix

## Decision Outcome

Proposed: the first option, starting brokerless for the first pilot pair if the broker isn't ready. Organisations record where they host it in their organisation repo. Consider PactFlow only if single sign-on, per-team permissions or bi-directional contracts become hard requirements.

### Consequences

* A broker deployment guide and CI templates using the Rust client.
* The contract testing lesson and technique rules name the broker and its limits.

## More Information

* Builds on: [Order of preference for test stand-in approaches](0053-order-of-preference-for-test-stand-in-approaches.md), [We reuse existing tools before building new ones](0020-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: none yet
* Background: [test-doubles](../REFERENCES.md#test-doubles)
