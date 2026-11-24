---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# What repair does where a test that reaches an external system has no place to inject a stand-in

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Repair](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md)
makes [every test that reaches an external system a pair](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md),
one half injecting a stand-in, and changes only test code. That needs a place to inject the stand-in: a replaceable
dependency, a setting, or a call the test can intercept. Old tests often reach a system through code that opens the
connection itself, with an address written in it, so nothing in the test code can swap it. Making such a place
changes production code. Feathers breaks dependencies before writing tests, with a short list of low-risk moves
(parameterise constructor, extract interface, sprout method, wrap method), and calls it risky work needing care.

## Considered Options

* **Record the work for the testing plan**  
  Repair leaves the test as it is and records the change it needs; production code changes only in the plan's work
  on making code testable, after the approval-test baseline exists
* **Allow a named list of low-risk changes**  
  Feathers' moves only, each in its own commit for review, where a test can't otherwise get a stand-in
* **Allow them only once approval tests cover the class**  
  As the second, but only with a safety net in place

## Decision Outcome

Chosen in discussion: record the work for the testing plan. Repair leaves such a test unpaired, and records in its
`repair` field in `testing/tests.yaml` that it waits for a place to inject a stand-in, with the change it would need.
The testing plan turns each into a piece of work.

### Consequences

* The work orders mark such a test as waiting for no place to inject
  ([Repair is directed by a work order per external system that under-test-tools writes](0095-repair-is-directed-by-a-work-order-per-external-system-that-under-test-tools-writes.md)).
* The field trial records each test repair stops for, the change it would need, and which of these options would have
  handled it; the decision is revisited from that.

## More Information

* Builds on: [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md), [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)
* Later decisions that build on this: none yet
* Background: [the research on prior art](../PRIOR-ART.md), [legacy-code](../REFERENCES.md#legacy-code)
