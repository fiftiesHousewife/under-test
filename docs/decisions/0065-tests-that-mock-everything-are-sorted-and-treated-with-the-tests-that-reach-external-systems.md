---
status: superseded
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Tests that mock everything are sorted and treated with the tests that reach external systems

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [Tests that mock everything are fixed in the testing plan's work, each mock sorted by what it stands for](0087-tests-that-mock-everything-are-fixed-in-the-testing-plans-work-each-mock-sorted-by-what-it-stands-for.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

A test whose class mocks most of what it touches mostly checks that certain calls happened: the code's wiring, not
its results. It breaks when the internals change without the behaviour changing, and passes when the behaviour changes
behind the same calls. Google ranks real objects first, then fakes, then stubs, and avoids checking interactions when
it can. The toolkit only said such tests were fixed in the strengthen-tests workstream, not how. Many of the mocks
stand in for the same external systems the tests that reach external systems need stand-ins for.

## Considered Options

* **Sort each mock, then treat it, in the same skill and with the same stand-ins as the tests that reach external
  systems**  
  A mock of something cheap the team owns becomes the real object; a mock of an external system or slow boundary
  becomes the fake chosen for that connection; a mock whose calls are the behaviour stays, with what was sent checked
* **Leave it to the strengthen-tests workstream, case by case**  
  No shared method, and the fakes built for external tests aren't reused
* **Replace every mock with a fake**  
  Fakes for things a real object would serve better, and more fakes to keep honest

## Decision Outcome

Chosen in discussion: the first option, in the skill that sorts and treats the tests that reach external systems
([Tests that reach external systems are sorted into logic, connection or both, and treated accordingly](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md)).
Each mock in a `mocks-everything` test is sorted, drafted by the AI and confirmed by a person:

* **something cheap and predictable the team owns** (a value object, an entity, a small service with no outside
  calls): the real object;
* **an external system or a slow boundary** (a repository over a database, an HTTP client, a mailer, the clock): the
  fake chosen for that connection in the connection list;
* **a call that is the behaviour** (sends one email, publishes an event): kept, checking what was sent rather than only
  that the call happened.

A check made only with `verify(...)` becomes a check on a result wherever there is one. A test that still needs many
mocks after the sort points at a production class doing too much: splitting it is recorded as refactoring work, as for
a missing seam. No test is rewritten before the approval-test baseline covers its behaviour, and tests over code whose
planted bugs survive come first.

### Consequences

* The skill for tests that reach external systems also treats `mocks-everything` tests, and the decision
  find-test-anti-patterns proposes for them, and the assessment report's choices, say so when it is built.
* The fakes built for each connection serve both kinds of test.

## More Information

* Builds on: [Tests that reach external systems are sorted into logic, connection or both, and treated accordingly](0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md), [Meaningless and unreliable tests are recorded and triaged, and no existing test is deleted before the approval-test baseline exists](../../decision-guides/0059-meaningless-and-unreliable-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)
* Later decisions that build on this: none yet
* Background: [the prior art](../PRIOR-ART.md#tests-that-reach-external-systems)
