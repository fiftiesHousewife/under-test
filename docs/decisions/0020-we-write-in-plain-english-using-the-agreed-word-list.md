---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# We write in plain English using the agreed word list

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion) (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Testing and delivery work is full of specialist and repurposed words (ladder, track, archetype, enabler, oracle), and short letter and number codes. Newcomers can't follow them.

## Considered Options

* **Plain English in its everyday sense; industry technique and tool names kept but explained on first use; no letter or number codes**  
  Clear to newcomers; still matches what people find online
* **Keep specialist words and define them in a glossary**  
  Least rework; words stay opaque

## Decision Outcome

Chosen in discussion: the first option. `GLOSSARY.md` is the agreed word list, including words not to use.

### Consequences

* Every file follows `GLOSSARY.md`.
* A word-list check in this repo's build (the check for this repo's own files).

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Technique ids match the names of the lessons that teach them, where one lesson teaches one technique](0031-technique-ids-match-the-names-of-the-lessons-that-teach-them-where-one-lesson-teaches-one-technique.md), [The toolkit calls a system a test cannot run without an external system](0062-the-toolkit-calls-a-system-a-test-cannot-run-without-an-external-system.md), [External system replaces the word connection](0081-external-system-replaces-the-word-connection.md), [An external system is one on another machine that a test cannot run without](0098-an-external-system-is-one-on-another-machine-that-a-test-cannot-run-without.md)
* Background: none
