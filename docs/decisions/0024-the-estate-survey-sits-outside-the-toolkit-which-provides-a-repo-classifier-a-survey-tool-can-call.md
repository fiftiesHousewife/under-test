---
status: proposed
decision-makers: Toolkit maintainers
group: Understanding our repos
---

# The estate survey sits outside the toolkit, which provides a repo classifier a survey tool can call

**Decided by:** Toolkit maintainers · **Status:** proposed (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Surveying every repo an organisation has depends on its code-hosting platform, scale, ownership records and reporting tools. Classifying one repo does not. Keeping the survey out keeps the toolkit generic.

## Considered Options

* **The toolkit provides a repo classifier that works on one checked-out repo and writes a result in a published format (the repo classification schema). A survey tool, outside the toolkit, lists an organisation's repos, clones them, calls the classifier, and combines the results. The toolkit documents a design for such a tool against a GitHub organisation**  
  Generic toolkit; any organisation can build or choose its own survey
* **The toolkit includes the survey**  
  Ties the toolkit to one platform and scale

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. The design is in `docs/design/survey-tool.md`.

### Consequences

* `schema/repo-classification.schema.json`.
* `docs/design/survey-tool.md`.
* Estate-wide work leaves the toolkit's backlog.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [Old code runs first only where production cannot be reached](../../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: none yet
* Background: [repo-classification](../REFERENCES.md#repo-classification)
