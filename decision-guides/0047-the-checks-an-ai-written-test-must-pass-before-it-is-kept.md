---
status: proposed
decision-makers: Test Quality Lead
group: AI-written tests
---

# The checks an AI-written test must pass before it is kept

**Decided by:** Test Quality Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

AI-written tests can look plausible and test nothing. Checks catch that before a person spends time reviewing.

## Considered Options

* **Compiles; passes 5 runs in a row with outbound calls blocked; catches a deliberately introduced bug nothing caught before, or, only for a test recording current behaviour, raises coverage of its target; labelled `@Generated` with the tag `ai-written` and with what it records, current or intended behaviour; not only "is not null" assertions**  
  Every kept test does real work, and nobody mistakes a record of today's behaviour, bugs included, for a statement of what the system should do
* **The same, accepting raised coverage for every test**  
  More tests kept, but coverage barely predicts whether a test finds bugs, the gap Meta named in its own pipeline
* **Person's review only**  
  Doesn't scale; misses weak tests

## Decision Outcome

Proposed: the five checks. Until the convention plugin exists, in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)), they run through the
[measurement init script](../tools/measurement/measure.init.gradle) (five runs under the airgap agent, JaCoCo for coverage, PIT for planted bugs), started by a
skill or a prompt such as [strengthen-tests-until-pit-catches-the-planted-bugs](../.github/prompts/strengthen-tests-until-pit-catches-the-planted-bugs.prompt.md),
which also checks the labels and the assertions. A test checking intended behaviour is kept only if it catches a planted
bug; a characterisation or approval test, which records current behaviour, may be kept on raised coverage, labelled as such
([why](../docs/PRIOR-ART.md#tests-written-by-ai)). The CI result counts. A person still reviews before merging ([People do the work with AI coding assistance, and review everything it produces](0005-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md)).

### Consequences

* The checks become part of the convention plugin, in its own repo, later; until then they run through the
  measurement init script. AI assistant instructions tell it to run them.

## More Information

* Builds on: [People do the work with AI coding assistance, and review everything it produces](0005-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md), [What counts as evidence for each test maturity level](0013-what-counts-as-evidence-for-each-test-maturity-level.md)
* Later decisions that build on this: [AI-written tests that expect different behaviour go to triage, not the bin](0048-ai-written-tests-that-expect-different-behaviour-go-to-triage-not-the-bin.md), [How strict the checks on AI-written tests are at the start](0049-how-strict-the-checks-on-ai-written-tests-are-at-the-start.md)
* Background: [ai-written-tests](../docs/REFERENCES.md#ai-written-tests), [mutation-testing](../docs/REFERENCES.md#mutation-testing)
