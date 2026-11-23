---
status: superseded
decision-makers: Toolkit maintainers
group: Recording results and owning plans
---

# find-test-anti-patterns lists every test it finds, so later steps don't search again

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [The tests something is recorded about are kept in one list, each step adding its own fields](0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The find-test-anti-patterns skill reads a repo's tests before anyone trusts them enough to run them. It finds every
test that shows an anti-pattern, but kept only a count and three examples of each kind. The steps after it need the
whole list: building a stand-in for each system the tests reach, fixing the tests that sleep or depend on order, and
the Application Owner's decisions on disabled tests and tests that never run. Each would have to search the code
again, which on a large suite is the expensive part
([A skill finds what to read by searching, and reads only what the searches find](0054-a-skill-finds-what-to-read-by-searching-and-reads-only-what-the-searches-find.md)).
Grouping the tests that reach shared systems by the kind of system is what building stand-ins needs, and the
connection list already holds one entry per system, with its kind and proposed stand-in.

## Considered Options

* **List every test found in its own file, and let the connection list name the tests for each connection**  
  The assessment file stays a short summary; one grouping of systems, in the connection list
* **Group the tests by kind of dependency in the anti-pattern skill's own output**  
  A second list of the same systems, which could disagree with the connection list
* **Keep counts and examples only**  
  Every later step searches again

## Decision Outcome

Chosen in discussion: the first option. The skill writes `testing/anti-pattern-tests.yaml`
([schema](../../schema/anti-pattern-tests.schema.json)): one entry per test found, with its kinds, and for a test
reaching a shared system each host and where it is named (the test's code, a properties or YAML file, a Spring XML
context, or the airgap agent's reports). The assessment file's `anti_patterns` section summarises it. The connection
list's entry for each connection names the tests that use it, instead of counting them, from this file and the
airgap agent's reports.

Only what can be found without running the tests is in the file. Flaky and failing tests come from measuring the
repo, and calls the code makes without naming the host come from the airgap agent's reports.

### Consequences

* The find-test-anti-patterns skill and its eval case write and check the new file; the skill evals check it against
  its schema.
* The draft-the-connection-list skill reads it, and lists each connection's tests.
* The testing plan's work for each connection, and for flaky tests, can name its tests.

## More Information

* Builds on: [A skill finds what to read by searching, and reads only what the searches find](0054-a-skill-finds-what-to-read-by-searching-and-reads-only-what-the-searches-find.md), [Each application's connections are recorded as a CALM connection list](../../decision-guides/0030-each-applications-connections-are-recorded-as-a-calm-connection-list.md)
* Later decisions that build on this: none yet
* Background: none
