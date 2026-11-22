---
status: proposed
decision-makers: Technical Architect
group: Standing in for real systems
---

# Contract tests share pacts as versioned artifacts through the package repository, without a broker

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Contract tests between in-house services need somewhere to share contracts (pacts): the consumer writes them, and the
provider's build checks it still meets them. In a locked-down organisation, a new service is deployed only through
the platform's control layers, which build its image and generate its Helm and Kubernetes files; its image and its
database still need approval, and someone has to own and run it afterwards. Deployment goes through an internal
release tool with its own records, and most of the repos being brought under test run on JDK 8.

## Considered Options

* **Pacts published as versioned artifacts to the organisation's package repository; provider builds fetch them by
  version and verify them in CI**  
  Uses a route every build already has, with nothing new to host or approve. The consumer's build publishes its pact
  files as an artifact versioned with the consumer; the provider's build depends on the consumer versions it must
  support (the latest on the main branch, and each version the release tool shows as deployed) and verifies them
  from a folder. Loses the broker's can-i-deploy matrix, its deployment records and pending pacts, so a new consumer's
  pact can fail a provider build until the teams agree it
* **The open-source Pact Broker (MIT), deployed through the platform's control layers**  
  Adds can-i-deploy, environments, deployment records and pending pacts. A new service to deploy and own: its image and
  its PostgreSQL database approved, someone to run and upgrade it, and the release tool changed to record each
  deployment in the broker; only basic authentication
* **PactFlow (commercial, SmartBear), hosted or on-premises**  
  The broker's features plus single sign-on, per-team permissions and contracts checked against OpenAPI; a licence, and
  a hosted service outside the network or another service to host inside it
* **Spring Cloud Contract, Specmatic or Microcks instead of Pact**  
  Each fits a narrower case (JVM-only stubs; OpenAPI-led tests; mocking and conformance), and the hosted ones raise
  the same hosting question

## Decision Outcome

Proposed: the first option. Pacts travel as versioned artifacts through the package repository, and each provider
verifies the consumer versions it supports in its own CI. A broker is worth it once enough service pairs verify
contracts for can-i-deploy to matter, and a team agrees to own it; organisations record that in their organisation repo. (The toolkit maintainers chose this
default in discussion, because a broker is a service someone must own and wire into the release tool before it pays
off; an organisation may still narrow or replace it.)

### Consequences

* CI templates for publishing pacts as artifacts and verifying them by version, with no broker.
* The provider's list of consumer versions to verify is kept in its repo and updated by pull request, from the release
  tool's records.
* Services on JDK 8 use the Pact JVM 4.5 line; current Pact JVM needs JDK 17 or newer.
* If a broker is added later, the same pacts move to it; the tests don't change.

## More Information

* Builds on: [Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md), [We reuse existing tools before building new ones](../docs/decisions/0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: none yet
* Background: [test-doubles](../docs/REFERENCES.md#test-doubles); the restrictions in [Using the toolkit inside a corporate network](../docs/CORPORATE-USE.md)
