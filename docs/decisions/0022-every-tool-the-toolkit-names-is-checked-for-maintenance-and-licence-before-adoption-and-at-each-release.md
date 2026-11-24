---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# Every tool the toolkit names is checked for maintenance and licence before adoption and at each release

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion) (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Reusing tools only helps if they stay maintained and their licences allow use in companies. An audit found tools that were archived (Diffy), unmaintained (EvoSuite), or had added restrictive terms (jqwik's anti-AI clause), and others with copyleft or source-available licences.

## Considered Options

* **Before a tool is named in a technique, decision or build: check it is maintained (a release within about 12 months, not archived) and that its licence allows use and redistribution in companies. Re-check every named tool at each toolkit release; replace dead tools and flag copyleft, source-available or non-commercial licences for legal review**  
  Organisations aren't handed dead or legally risky tools
* **Check only when something breaks**  
  Problems found late, after organisations depend on the tool

## Decision Outcome

Chosen in discussion: the first option.

### Consequences

* A tool health check at each release, reported in the external artifact list.
* jqwik replaced by jetCheck; EvoSuite and Diffy dropped; TruffleHog flagged in favour of gitleaks.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md)
* Later decisions that build on this: [The format for intended behaviour is chosen by piloting Gherkin and Allium side by side](0028-the-format-for-intended-behaviour-is-chosen-by-piloting-gherkin-and-allium-side-by-side.md)
* Background: none
