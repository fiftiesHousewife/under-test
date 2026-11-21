---
status: proposed
decision-makers: Technical Architect
group: Knowing what each system connects to
---

# Each application's connections are recorded as a CALM connection list

**Decided by:** Technical Architect · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Tests need to know everything a system talks to (interfaces, databases, queues, outside services) so they can stand in for each one, and so nothing reaches production. Today that knowledge is scattered across configuration, wiki pages and people's heads.

## Considered Options

* **A connection list per application, written as a FINOS CALM document (an open standard, Apache-2.0, JSON with a published schema): each database, queue, service and outside system, with its interfaces (hosts, ports, addresses, queue names, schemas) per environment. Drafted from the repo classifier's output and CALM's AI discovery skill; confirmed by the person who owns the architecture. Validated against the CALM schema by a Java check, so organisations don't need CALM's Node.js tools**  
  One readable, checkable list; an open standard rather than our own format
* **A list in the toolkit's own format inside the assessment file**  
  Simpler; not reusable by other architecture tools
* **No list; rely on the outbound-call check**  
  Only finds connections tests happen to make

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. The list lives in the application's main repo (`testing/connections.calm.json`), or in the organisation repo for applications without one.

### Consequences

* A connection-list template and Java schema check.
* The repo classifier's output feeds a draft connection list.

## More Information

* Builds on: [We reuse existing tools before building new ones](../docs/decisions/0021-we-reuse-existing-tools-before-building-new-ones.md), [Old code runs first only where production cannot be reached](0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [The connection list says what tests use for each connection, and which addresses tests must never reach](0031-the-connection-list-says-what-tests-use-for-each-connection-and-which-addresses-tests-must-never-reach.md), [Every repo starts with discovery: a draft connection list, an approval-test baseline and a source list](0032-every-repo-starts-with-discovery-a-draft-connection-list-an-approval-test-baseline-and-a-source-list.md)
* Background: [engagement-model](../docs/REFERENCES.md#engagement-model)
