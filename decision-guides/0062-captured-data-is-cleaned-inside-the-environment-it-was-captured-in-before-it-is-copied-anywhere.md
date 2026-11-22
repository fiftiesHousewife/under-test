---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Capturing current behaviour
---

# Captured data is cleaned inside the environment it was captured in, before it is copied anywhere

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A capture holds whatever data passed through: names, addresses, account numbers, tokens. Where it is cleaned decides
where raw data ends up: on a laptop, in a repo's history, or in an AI assistant's context.

## Considered Options

* **Clean at capture, or before export, inside the capture environment**  
  Raw data never leaves the environment it was captured in
* **Clean on the developer's machine before committing**  
  Leaves raw data on laptops, and in front of AI assistants
* **Clean in CI after committing**  
  Leaves raw data in the repo's history for good

## Decision Outcome

Proposed: clean inside the capture environment, the default the toolkit maintainers chose in discussion, from
[capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md). The cleaning rules
for each system are kept with its shared test kit, so every repo that records it cleans the same way.

### Consequences

* The capture cleaner, applying a shared test kit's rules: code in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)), deployed into the
  capture environment through its control layers.
* No AI assistant sees a capture before it is cleaned.

## More Information

* Builds on: [Order of preference for where current behaviour is captured](0061-order-of-preference-for-where-current-behaviour-is-captured.md), [Personal data is removed from any recorded traffic or data](0046-personal-data-is-removed-from-any-recorded-traffic-or-data.md)
* Later decisions that build on this: [How personal data in captures is replaced: dropped, keyed substitutes or synthetic values, chosen per field](0063-how-personal-data-in-captures-is-replaced-dropped-keyed-substitutes-or-synthetic-values-chosen-per-field.md)
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md)
