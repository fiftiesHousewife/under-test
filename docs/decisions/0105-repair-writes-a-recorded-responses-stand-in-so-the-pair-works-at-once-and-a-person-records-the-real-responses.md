---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Repair writes a recorded-responses stand-in so the pair works at once, and a person records the real responses

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

A recorded-responses stand-in replays what the real system answered. But repair runs every test under the airgap
agent, which refuses every call to another machine ([Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)), so nothing can be recorded during repair. On its trial on
jsonld-java the AI wrote each response from what the test asserts and what the real document is known to hold: the
pairs worked, but two tests passed on almost any response, and a written response may drift from the real system
unnoticed.

## Considered Options

* **Repair writes the responses, marked as written; a person records the real ones and replaces them**  
  The pair works at once, and the stand-in ends up faithful
* **Written responses are the stand-in, with no recording step**  
  Simpler, but nothing checks them against the real system
* **A recording mode: the airgap agent allows the named hosts only, and a proxy saves what they return**  
  Exact, but it opens the sealed run to the outside

## Decision Outcome

Chosen in discussion: repair writes them, and a person records the real ones.

* **Repair writes each response** from what the test asserts and what the real system is known to return. Each file
  says it was written, not recorded, and the test's `repair` field records `responses: written`.
* **A person records the real responses** once, by running the pair's external half where reaching the system is
  allowed (a public server, or the system's test instance, never production), and replaces the written files in the
  same pull request. The test's `repair` field then says `responses: recorded`.
* **The testing plan** keeps a piece of work for each system whose paired tests still have written responses.

### Consequences

* `testing/tests.yaml`'s `repair` field gains `responses`.
* The repair skill and the testing plan skill follow it.

## More Information

* Builds on: [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md), [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md), [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: none yet
* Background: none
