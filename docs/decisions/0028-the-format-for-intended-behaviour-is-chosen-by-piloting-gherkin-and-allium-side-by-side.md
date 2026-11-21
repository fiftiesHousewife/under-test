---
status: proposed
decision-makers: Toolkit maintainers
group: Understanding what a system should do
---

# The format for intended behaviour is chosen by piloting Gherkin and Allium side by side

**Decided by:** Toolkit maintainers · **Status:** proposed (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Two strong candidates suit intended behaviour, with different strengths. Gherkin (Cucumber, MIT) is mature, easy to mirror, and its scenarios run as tests, but business people find writing it hard. Allium (JUXT, MIT) is built for AI assistants and lists required tests deterministically, but is young (three major language versions in 2026) and its command-line tool is a pre-release Rust binary.

## Considered Options

* **Pilot both on one pilot application, with the same sources, expert sessions and acceptance check, then decide on evidence: expert effort, test quality, stability, and how easily organisations can approve the tools**  
  A decision based on our own results
* **Choose Gherkin now**  
  Mature and safe; may miss Allium's deterministic list of required tests
* **Choose Allium now**  
  Most AI-ready; maturity and approval risk

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. Until the pilot decides, business rule tests (table-driven JUnit tests confirmed by experts) remain available as a fallback.

### Consequences

* A pilot work item with comparison criteria.
* A decision record for the chosen format after the pilot.

## More Information

* Builds on: [Behaviour is captured in two tracks, current and intended, and every difference is an open question](../../decision-guides/0033-behaviour-is-captured-in-two-tracks-current-and-intended-and-every-difference-is-an-open-question.md), [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md)
* Later decisions that build on this: none yet
* Background: none
