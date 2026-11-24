---
status: proposed
decision-makers: Technical Architect
group: Knowing what each system connects to
---

# Each application's external systems are recorded as a CALM list

**Decided by:** Technical Architect · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Tests need to know everything a system talks to (interfaces, databases, queues, outside services) so they can stand in for each one, and so nothing reaches production. Today that knowledge is scattered across configuration, wiki pages and people's heads.

## Considered Options

* **An external systems list per application, written as a FINOS CALM document (an open standard, Apache-2.0, JSON with a published schema): each database, queue, service and outside system, with its interfaces (hosts, ports, addresses, queue names, schemas) per environment. Drafted by the [draft-the-external-systems-list](../.github/skills/draft-the-external-systems-list/SKILL.md) skill from the code, read by [under-test-external-calls](https://github.com/fiftiesHousewife/under-test-external-calls), and from the settings, before anything runs; the airgap agent's reports add what it missed once tests run. Confirmed by the Architecture Owner. Checked against the toolkit's [`schema/external-systems-list.schema.json`](../schema/external-systems-list.schema.json), so organisations don't need CALM's Node.js tools**  
  One readable, checkable list; an open standard rather than our own format
* **A list in the toolkit's own format inside the assessment file**  
  Simpler; not reusable by other architecture tools
* **No list; rely on the outbound-call check**  
  Only finds connections tests happen to make

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option. The list lives in the application's main repo (`testing/external-systems.calm.json`), or in the organisation repo for applications without one. Discovery reads the application's own settings and the
inputs the platform generates its deployment files from, not the generated Helm or Kubernetes files, which show the
platform's template more than the application.

### Consequences

* [`schema/external-systems-list.schema.json`](../schema/external-systems-list.schema.json), which every external systems list is
  checked against.
* The draft-the-external-systems-list skill drafts the list from the code with under-test-external-calls, and from
  the settings, before anything runs; it later merges in what the airgap agent's reports add. The Architecture Owner
  confirms it.

## More Information

* Builds on: [We reuse existing tools before building new ones](../docs/decisions/0021-we-reuse-existing-tools-before-building-new-ones.md), [Old code runs first only where production cannot be reached](0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: [The external systems list says what tests use for each system, and which addresses tests must never reach](0031-the-external-systems-list-says-what-tests-use-for-each-system-and-which-addresses-tests-must-never-reach.md), [Every repo starts with discovery: a draft external systems list, a source list and a check of its existing tests, and a first approval-test baseline follows](0032-every-repo-starts-with-discovery-a-draft-external-systems-list-a-source-list-and-a-check-of-its-existing-tests-and-a-first-approval-test-baseline-follows.md), [A repo with several applications keeps each application's testing files in their own folder under testing/](../docs/decisions/0053-a-repo-with-several-applications-keeps-each-applications-testing-files-in-their-own-folder-under-testing.md), [find-test-anti-patterns lists every test it finds, so later steps don't search again](../docs/decisions/0055-find-test-anti-patterns-lists-every-test-it-finds-so-later-steps-dont-search-again.md)
* Background: [engagement-model](../docs/REFERENCES.md#engagement-model)
