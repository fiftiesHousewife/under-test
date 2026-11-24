---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Tests that mock everything are fixed in the testing plan's work, each mock sorted by what it stands for

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

A test whose class mocks most of what it touches mostly checks that certain calls happened: the code's wiring, not
its results. It breaks when the internals change without the behaviour changing, and passes when the behaviour
changes behind the same calls. Google ranks real objects first, then fakes, then stubs, and avoids checking
interactions when it can.

Such a test is on discovery's list of
[meaningless tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md),
whose fixes are the testing plan's work, while repair only
[makes each test that reaches an external system a pair](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md).
How such a test is fixed was settled for a repair that no longer does it.

## Considered Options

* **In the strengthen-tests work, each mock sorted by what it stands for, reusing repair's stand-ins**  
  The fix keeps its method; the stand-ins built for external systems serve these tests too
* **Case by case in the strengthen-tests work**  
  No shared method, and the stand-ins built for repair aren't reused
* **Replace every mock with a fake**  
  Fakes for things a real object would serve better, and more fakes to keep honest

## Decision Outcome

Chosen in discussion: in the strengthen-tests work, each mock sorted by what it stands for, drafted by the AI and
confirmed by a person:

* **something cheap and predictable the team owns** (a value object, an entity, a small service with no outside
  calls): the real object;
* **an external system or a slow boundary** (a repository over a database, an HTTP client, a mailer, the clock): the
  stand-in chosen for that system in the external systems list, as repair injects it;
* **a call that is the behaviour** (sends one email, publishes an event): kept, checking what was sent rather than only
  that the call happened.

A check made only with `verify(...)` becomes a check on a result wherever there is one. A test that still needs many
mocks after the sort points at a production class doing too much: splitting it is recorded as refactoring work. No
test is rewritten before the approval-test baseline covers its behaviour, and tests over code whose planted bugs
survive come first.

This replaces [Tests that mock everything are sorted and treated with the tests that reach external systems](0065-tests-that-mock-everything-are-sorted-and-treated-with-the-tests-that-reach-external-systems.md).

### Consequences

* The testing plan's row for `mocks-everything` findings is in the strengthen-tests workstream, after repair and the
  approval-test baseline.
* The stand-ins repair builds for each external system serve both kinds of test.

## More Information

* Builds on: [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md), [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md), [Anti-patterns in existing tests are recorded and triaged, and no existing test is deleted before the approval-test baseline exists](../../decision-guides/0059-anti-patterns-in-existing-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)
* Later decisions that build on this: none yet
* Background: [the prior art](../PRIOR-ART.md#tests-that-reach-external-systems)
