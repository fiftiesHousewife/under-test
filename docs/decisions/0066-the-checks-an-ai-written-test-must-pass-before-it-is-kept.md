---
status: proposed
decision-makers: Test Quality Lead
group: AI-written tests
---

# The checks an AI-written test must pass before it is kept

**Decided by:** Test Quality Lead · **Status:** proposed

## Context and Problem Statement

AI-written tests can look plausible and test nothing. Checks catch that before a person spends time reviewing.

## Considered Options

* **Compiles; passes 5 runs in a row with outbound calls blocked; raises coverage of its target or catches a deliberately introduced bug nothing caught before; labelled `@Generated` with the tag `ai-written`; not only "is not null" assertions**  
  Every kept test does real work
* **Person's review only**  
  Doesn't scale; misses weak tests

## Decision Outcome

Proposed: the five checks, as an `acceptanceCheck` Gradle task (and an npm equivalent). The CI result counts. A person still reviews before merging (decision 0024).

### Consequences

* Convention plugin (the convention plugin every repo applies); AI assistant instructions tell it to run the check.

## More Information

* Builds on: [People do the work with AI coding assistance, and review everything it produces](0024-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md), [What counts as evidence for each test maturity level](0032-what-counts-as-evidence-for-each-test-maturity-level.md)
* Later decisions that build on this: [AI-written tests that expect different behaviour go to triage, not the bin](0067-ai-written-tests-that-expect-different-behaviour-go-to-triage-not-the-bin.md), [How strict the checks on AI-written tests are at the start](0068-how-strict-the-checks-on-ai-written-tests-are-at-the-start.md)
* Background: [ai-written-tests](../REFERENCES.md#ai-written-tests), [mutation-testing](../REFERENCES.md#mutation-testing)
