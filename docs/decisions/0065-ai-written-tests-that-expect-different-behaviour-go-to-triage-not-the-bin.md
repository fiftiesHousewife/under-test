---
status: proposed
decision-makers: Test Quality Lead
group: AI-written tests
---

# AI-written tests that expect different behaviour go to triage, not the bin

**Decided by:** Test Quality Lead · **Status:** proposed

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

* The acceptance check moves such tests and opens an issue.

## More Information

* Builds on: [The checks an AI-written test must pass before it is kept](0064-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md)
* Later decisions that build on this: none yet
* Background: none
