---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Understanding what a system should do
---

# Knowledge sources are listed by the knowledge curator and read through Allium skills with a citation addendum

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A repo alone can't reveal its full functional footprint. Regression packs, wiki pages, tracker history and other repos hold the rest, but AI drafting from them invents rules unless every rule is tied to a source and checked.

## Considered Options

* **A source list per application, owned by the Knowledge Curator and checked against a schema, naming the sources that count and how current each is. Rules are drafted with Allium's own skills (elicit and distill), plus a short toolkit addendum: read only the listed sources, cite each rule's source (file and line, page and version, work item key), and record current and intended behaviour side by side. The same addendum guides drafting in Gherkin during the pilot. Drafts are checked against a sample of expert-written rules**  
  Reuses existing skills; every rule is traceable; nothing is read that a person didn't list
* **Build our own intake skill**  
  More control; duplicates what Allium already does
* **Use Allium's skills unchanged**  
  They don't name regression packs, wiki pages or tracker history as sources, and record behaviour only as intended

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option. The AI assistant never fetches sources on its own; people export them or make them reachable.

### Consequences

* `schema/source-list.schema.json`.
* The toolkit addendum to Allium's skills, as a skill in [`.github/skills/`](../.github/skills/) (planned).

## More Information

* Builds on: [Each application also has a knowledge curator and an architecture owner](0002-each-application-also-has-a-knowledge-curator-and-an-architecture-owner.md), [We reuse existing tools before building new ones](../docs/decisions/0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: [Test assets outside the repo are mined for behaviour, and kept running until repo tests replace them](0058-test-assets-outside-the-repo-are-mined-for-behaviour-and-kept-running-until-repo-tests-replace-them.md)
* Background: none
