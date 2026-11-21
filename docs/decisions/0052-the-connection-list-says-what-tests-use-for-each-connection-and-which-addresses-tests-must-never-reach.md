---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Knowing what each system connects to
---

# The connection list says what tests use for each connection, and which addresses tests must never reach

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed (agreed in discussion)

## Context and Problem Statement

Knowing a connection exists isn't enough: tests also need to know what to use instead of it, and which of its addresses are production.

## Considered Options

* **Each connection carries two pieces of information, recorded with CALM's own extension points (decorators and controls): the test stand-in approach and the shared test kit that provides it, and the addresses tests must never reach (production). The production-address check reads these; the outbound-call check flags any connection not on the list; the testing-plan generator chooses the test type from each connection (contract tests between in-house services, recorded responses or contracts for outside services, container tests for databases and queues)**  
  Safety and test design driven from one confirmed list
* **Keep stand-ins and production addresses in separate files**  
  Two lists to keep in step

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. The toolkit publishes the schema for its CALM decorator.

### Consequences

* A CALM decorator schema for test stand-ins and never-reach addresses.
* The production-address check, outbound-call check and testing-plan generator read the connection list.

## More Information

* Builds on: [Each application's connections are recorded as a CALM connection list](0051-each-applications-connections-are-recorded-as-a-calm-connection-list.md), [Tests stop at once if any configured address is a production address](0026-tests-stop-at-once-if-any-configured-address-is-a-production-address.md)
* Later decisions that build on this: none yet
* Background: none
