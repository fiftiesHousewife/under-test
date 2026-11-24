---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Knowing what each system connects to
---

# The external systems list says what tests use for each system, and which addresses tests must never reach

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Knowing a connection exists isn't enough: tests also need to know what to use instead of it, and which of its addresses are production.

## Considered Options

* **Each connection carries two pieces of information, recorded with CALM's own extension points (decorators and controls): the test stand-in approach and the shared test kit that provides it, and the addresses tests must never reach (production). The [draft-the-external-systems-list](../.github/skills/draft-the-external-systems-list/SKILL.md) skill proposes a stand-in for each connection, which the Architecture Owner confirms; the airgap agent's report shows calls not on the list; the [write-the-testing-plan](../.github/skills/write-the-testing-plan/SKILL.md) skill turns each stand-in into work, choosing the test type from each connection (contract tests between in-house services, recorded responses or contracts for outside services, container tests for databases and queues); the production-address check comes later, in the convention plugin**  
  Safety and test design driven from one confirmed list
* **Keep stand-ins and production addresses in separate files**  
  Two lists to keep in step

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option. The toolkit publishes the schema for its CALM decorator.

### Consequences

* A schema for the toolkit's fields, kept in each connection's CALM `metadata` under `under-test`:
  [`schema/external-systems-list.schema.json`](../schema/external-systems-list.schema.json).
* The draft-the-external-systems-list skill writes the external systems list and the write-the-testing-plan skill reads it; the
  production-address check, in the convention plugin, in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)), will read its never-reach
  addresses.

## More Information

* Builds on: [Each application's external systems are recorded as a CALM list](0030-each-applications-external-systems-are-recorded-as-a-calm-list.md), [Tests stop at once if any configured address is a production address](0009-tests-stop-at-once-if-any-configured-address-is-a-production-address.md)
* Later decisions that build on this: none yet
* Background: none
