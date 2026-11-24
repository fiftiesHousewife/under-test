---
status: proposed
decision-makers: Programme Sponsor
group: How we work
---

# Each application also has a knowledge curator and an architecture owner

**Decided by:** Programme Sponsor · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A repo alone can't reveal what a system should do or everything it connects to. Someone has to decide which organisational knowledge counts, and someone has to confirm the system's connections. Without named owners, both are left to whoever happens to be available.

## Considered Options

* **Two roles per application: a Knowledge Curator (often a business analyst or domain lead) decides which regression packs, wiki pages, tracker queries and other repos count as sources, and how current each is; an Architecture Owner (often the application's solution architect) confirms its external systems list and owns its boundary contracts. The Application Owner settles disagreements between current and intended behaviour. The Technical Architect stays programme-wide**  
  Clear ownership of knowledge and connections; experts' time is protected
* **Give curation to the Application Owner and external systems lists to the Technical Architect**  
  Fewer roles; overloads two people and doesn't scale across applications

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option.

### Consequences

* The roles table in GLOSSARY.md.
* Source lists and external systems lists name their owner.

## More Information

* Builds on: [The programme runs as a forward deployed engagement with named roles](0001-the-programme-runs-as-a-forward-deployed-engagement-with-named-roles.md)
* Later decisions that build on this: [Every repo starts with discovery: a draft external systems list, a source list and a check of its existing tests, and a first approval-test baseline follows](0032-every-repo-starts-with-discovery-a-draft-external-systems-list-a-source-list-and-a-check-of-its-existing-tests-and-a-first-approval-test-baseline-follows.md), [Knowledge sources are listed by the knowledge curator and read through Allium skills with a citation addendum](0034-knowledge-sources-are-listed-by-the-knowledge-curator-and-read-through-allium-skills-with-a-citation-addendum.md)
* Background: none
