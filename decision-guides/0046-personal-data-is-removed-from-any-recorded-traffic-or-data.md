---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Test hygiene
---

# Personal data is removed from any recorded traffic or data

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Recorded traffic and copied data can contain customers' personal data, and sensitive data such as passwords, tokens
and cookies, the commonest leak in recorded HTTP traffic.

## Considered Options

* **Removing personal and sensitive data, including secrets, is a required step before anything recorded is committed or shared**  
  Protects customers
* **Left to each team**  
  Inconsistent; risky

## Decision Outcome

Proposed: the first option. Seed data for shared test kits is synthetic.

### Consequences

* Where cleaning happens, how values are replaced, how cleaning is checked, and the legal status of cleaned data:
  [Captured data is cleaned inside the environment it was captured in, before it is copied anywhere](0062-captured-data-is-cleaned-inside-the-environment-it-was-captured-in-before-it-is-copied-anywhere.md),
  [How personal data in captures is replaced: dropped, keyed substitutes or synthetic values, chosen per field](0063-how-personal-data-in-captures-is-replaced-dropped-keyed-substitutes-or-synthetic-values-chosen-per-field.md),
  [Cleaned captures pass a detector check before they are kept, and a person signs off the first sample](0064-cleaned-captures-pass-a-detector-check-before-they-are-kept-and-a-person-signs-off-the-first-sample.md),
  [Cleaned captures are treated as personal data unless the Data Protection Officer agrees they are anonymous](0065-cleaned-captures-are-treated-as-personal-data-unless-the-data-protection-officer-agrees-they-are-anonymous.md).
* Shared test kits include the step, and so does the lesson on [recorded HTTP responses](https://github.com/fiftiesHousewife/under-test-lessons/blob/main/lessons/recorded-http-responses/README.md).

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: none yet
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md)
