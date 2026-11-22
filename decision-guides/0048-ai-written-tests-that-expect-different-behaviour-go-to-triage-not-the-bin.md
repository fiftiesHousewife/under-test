---
status: proposed
decision-makers: Test Quality Lead
group: AI-written tests
---

# AI-written tests that expect different behaviour go to triage, not the bin

**Decided by:** Test Quality Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A draft test that fails because it expects different behaviour may have found a real bug.

## Considered Options

* **Move it to a `triage/` folder with an issue for a person to look at**  
  Bugs aren't thrown away
* **Delete it**  
  Loses possible bug reports

## Decision Outcome

Proposed: the first option.

### Consequences

* Whatever runs the acceptance check (see [The checks an AI-written test must pass before it is kept](0047-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md)) moves such tests and opens an issue.

## More Information

* Builds on: [The checks an AI-written test must pass before it is kept](0047-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md)
* Later decisions that build on this: none yet
* Background: none
