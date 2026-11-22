---
status: proposed
decision-makers: Test Quality Lead
group: Capturing current behaviour
---

# Cleaned captures pass a detector check before they are kept, and a person signs off the first sample

**Decided by:** Test Quality Lead · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Cleaning rules miss things: a new field, a name inside free text, a token in a header. Nothing shows a miss unless
something looks for it.

## Considered Options

* **A detector check in every build (patterns and check digits for known kinds of data, plus the secrets scan), a
  language-model detector such as Presidio where it is approved, and a person's sign-off on the first sample for each
  set of rules**  
  Machines catch what they can every time; a person checks what machines can't, once per set of rules
* **A person's review only**  
  Catches subtle leaks, but doesn't scale, and isn't repeated
* **A detector only**  
  Repeatable, but misses what patterns can't see

## Decision Outcome

Proposed: the detector check plus a person's sign-off, the default the toolkit maintainers chose in discussion, from
[capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md). A capture that
fails the check isn't kept.

### Consequences

* A detector gate in the convention plugin, run on every committed capture.
* The sign-off is recorded in the assessment file, with the rules it covers.

## More Information

* Builds on: [How personal data in captures is replaced: dropped, keyed substitutes or synthetic values, chosen per field](0063-how-personal-data-in-captures-is-replaced-dropped-keyed-substitutes-or-synthetic-values-chosen-per-field.md), [No repo's code is built or run until its secrets scan is clean](0007-no-repos-code-is-built-or-run-until-its-secrets-scan-is-clean.md)
* Later decisions that build on this: [Cleaned captures are treated as personal data unless the Data Protection Officer agrees they are anonymous](0065-cleaned-captures-are-treated-as-personal-data-unless-the-data-protection-officer-agrees-they-are-anonymous.md)
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md)
