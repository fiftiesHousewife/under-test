---
status: proposed
decision-makers: Data Protection Officer
group: Capturing current behaviour
---

# Cleaned captures are treated as personal data unless the Data Protection Officer agrees they are anonymous

**Decided by:** Data Protection Officer · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Under the GDPR and the ICO's guidance, data with names and identifiers replaced is usually still pseudonymised personal
data, not anonymous, as long as anyone could link it back; the *EDPS v SRB* judgment of the Court of Justice of the EU
considers who could do so in practice. Treating a cleaned capture as anonymous when it isn't puts the organisation in
breach.

## Considered Options

* **Treat cleaned captures as low-risk personal data: internal, access-controlled repos only, never public, unless the
  Data Protection Officer agrees a capture is anonymous**  
  Safe in law; the person the law expects to decide, decides
* **Treat them as anonymous once they pass the detector check**  
  Easiest to work with, but likely wrong in law for most captures
* **Ask each time**  
  Careful, but slow, and inconsistent

## Decision Outcome

Proposed: treat cleaned captures as personal data, the default the toolkit maintainers chose in discussion, from
[capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md). The Data
Protection Officer, a role in the toolkit's role list, decides any exception.

### Consequences

* Repos holding cleaned captures stay internal and access-controlled.
* Shared test kits holding captures are published only inside the organisation.

## More Information

* Builds on: [Cleaned captures pass a detector check before they are kept, and a person signs off the first sample](0064-cleaned-captures-pass-a-detector-check-before-they-are-kept-and-a-person-signs-off-the-first-sample.md)
* Later decisions that build on this: none yet
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md): Regulation (EU) 2016/679, Article 4(5) and Recital 26 (<https://eur-lex.europa.eu/eli/reg/2016/679/oj>); ICO, Pseudonymisation (<https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/pseudonymisation/>); case C-413/23 P, *EDPS v SRB* (<https://eur-lex.europa.eu/case/EN/C_413_23_P>)
