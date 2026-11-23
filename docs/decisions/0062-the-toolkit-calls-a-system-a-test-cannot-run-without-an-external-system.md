---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# The toolkit calls a system a test cannot run without an external system

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The toolkit called databases, services and other systems a test reached "shared systems". People using it found
"external" clearer, and it matches the tag build tools already use (Bazel's `external`).

## Considered Options

* **"External system" everywhere, in one pass**
* **"External" in tags and text, the machine-readable name unchanged**  
  Two words for one thing
* **Keep "shared system"**

## Decision Outcome

Chosen in discussion: "external system" everywhere. The anti-pattern kind becomes `reaches-external-system`, the tag
`external`, and the glossary, decision guides, skills, schemas and eval checks follow, in one pass.

### Consequences

* A rename across the toolkit, done with the change to one list of tests, since both touch the same files.

## More Information

* Builds on: [We write in plain English using the agreed word list](0020-we-write-in-plain-english-using-the-agreed-word-list.md)
* Later decisions that build on this: none yet
* Background: none
