---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# External system replaces the word connection

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

"Connection" carries several meanings at once in the toolkit: the connection list, a connection point in the code,
each test's `connections`, the connection-paths tool, and a database connection. "External system" is already the
glossary's word for what a test reaches off the machine.

## Considered Options

* **External system, everywhere**  
  One word already in use; "a test that reaches an external system" already reads well
* **Integration point**  
  Michael Nygard's term from *Release It!*; recognised, but a second word to explain
* **Outside call**  
  The airgap agent's framing; names the call, not the thing called

## Decision Outcome

Chosen in discussion: external system, everywhere.

| Was | Becomes |
|---|---|
| connection list, `testing/connections.calm.json` | external systems list, `testing/external-systems.calm.json` |
| connection point | reach point: where the code opens or uses an external system |
| a test's `connections` in `testing/tests.yaml` | its `external_systems` |
| draft-the-connection-list | draft-the-external-systems-list |

"Connection" stays for a database connection, and as CALM's own word inside the file's format. The connection-paths
tool's name is its own repo's decision.

### Consequences

* The glossary, the journey page, its drawing and the README use the new words now; the schemas, skills, eval
  cases and checks are renamed together in one change, with the skill evals' output validator.

## More Information

* Builds on: [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md), [We write in plain English using the agreed word list](0020-we-write-in-plain-english-using-the-agreed-word-list.md)
* Later decisions that build on this: none yet
* Background: [test-doubles](../REFERENCES.md#test-doubles)
