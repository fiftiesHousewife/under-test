---
status: proposed
decision-makers: Test Quality Lead
group: Capturing current behaviour
---

# How personal data in captures is replaced: dropped, keyed substitutes or synthetic values, chosen per field

**Decided by:** Test Quality Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Replacing personal data must keep tests working: an identifier that appears in a request and again in a later response
must be replaced by the same value both times, and a date of birth must still be a date. Replacing everything with the
same fixed text breaks both.

## Considered Options

* **Per field: drop secrets and free text; keyed substitutes for identifiers (a keyed hash, from the JDK alone), so the
  same value always becomes the same substitute; seeded synthetic values (Datafaker) where realism matters; dates
  shifted**  
  Tests keep working; the key stays in the capture environment's vault
* **Fixed text everywhere**  
  Simple, but breaks any test that follows an identifier through
* **Format-preserving encryption everywhere**  
  Keeps formats exactly, but reversible with the key, and heavier to approve
* **A commercial test-data product**  
  Capable, but a large purchase and approval

## Decision Outcome

Proposed: per field, the default the toolkit maintainers chose in discussion, from
[capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md). The key for keyed
substitutes stays in the capture environment's vault. Format-preserving encryption (FF1 only) is a named exception,
for fields whose exact format a system checks.

### Consequences

* Each shared test kit's cleaning rules say, for each field, which kind of replacement it gets.
* The capture cleaner implements all three kinds. It is code in its own repo, later (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](../docs/decisions/0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)), deployed into the
  capture environment through its control layers.

## More Information

* Builds on: [Captured data is cleaned inside the environment it was captured in, before it is copied anywhere](0062-captured-data-is-cleaned-inside-the-environment-it-was-captured-in-before-it-is-copied-anywhere.md)
* Later decisions that build on this: [Cleaned captures pass a detector check before they are kept, and a person signs off the first sample](0064-cleaned-captures-pass-a-detector-check-before-they-are-kept-and-a-person-signs-off-the-first-sample.md)
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md)
