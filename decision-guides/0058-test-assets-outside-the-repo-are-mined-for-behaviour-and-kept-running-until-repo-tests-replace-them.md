---
status: proposed
decision-makers: Test Quality Lead
group: Understanding what a system should do
---

# Test assets outside the repo are mined for behaviour, and kept running until repo tests replace them

**Decided by:** Test Quality Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Much of an old application's testing lives outside its repo: automation suites run against a shared test environment
(often Selenium or UFT, in a separate QA repo), manual test scripts, and regression packs in spreadsheets or a
test-management tool. They're the best record of what testers thought mattered, but they depend on a shared
environment and its data, and they don't run with the repo's build.

## Considered Options

* **Mine, keep, replace: list them on the source list, use them as a source of examples and intended behaviour, keep
  automation suites running where they are until repo tests cover the same journeys, then retire them**  
  Nothing testers knew is lost, and nothing is switched off before its replacement exists
* **Port them early: turn the automation into repo tests in discovery**  
  Quick coverage, but carries over their brittleness and their dependence on shared data
* **Leave them out**  
  Simplest, but loses the best record of what mattered

## Decision Outcome

Proposed: mine, keep, replace, the default the toolkit maintainers chose in discussion. Test assets are listed on the
application's source list by the Knowledge Curator. Manual scripts and regression packs become examples for the
specification of intended behaviour, each rule citing the script it came from. Automation suites keep running in their
environment, unchanged, until repo tests cover the same journeys; the Application Owner then retires them. They never
count as evidence for a test maturity level, since they depend on a shared environment.

### Consequences

* The source list schema gains a kind for test assets, and a field for the journeys each covers.
* Discovery records each test asset, what it covers, and where it runs.
* The testing plan names, for each automation suite, the repo tests that will replace it.

## More Information

* Builds on: [Knowledge sources are listed by the knowledge curator and read through Allium skills with a citation addendum](0034-knowledge-sources-are-listed-by-the-knowledge-curator-and-read-through-allium-skills-with-a-citation-addendum.md), [Whether a shared test environment can count as evidence for a limited time](0042-whether-a-shared-test-environment-can-count-as-evidence-for-a-limited-time.md)
* Later decisions that build on this: none yet
* Background: [legacy-code](../docs/REFERENCES.md#legacy-code)
