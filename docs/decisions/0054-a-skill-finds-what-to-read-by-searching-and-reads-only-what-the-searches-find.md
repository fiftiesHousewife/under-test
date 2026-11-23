---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A skill finds what to read by searching, and reads only what the searches find

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The find-test-anti-patterns skill told the AI assistant to read every test file. On a real repo with 35,000 lines of
tests that wasn't practical, and the person using it wrote a read-only script instead. The eval cases' example repos
are small, so the evals didn't show it. Other skills that look through a repo's code or settings face the same limit.

## Considered Options

* **Exact searches for what the skill looks for, then reading only what they find**  
  `grep` or ripgrep patterns written in the skill; every machine has them, nothing to build or approve, and a search
  gives line numbers that don't depend on reading
* **A read-only script for each such skill, in its own repo**  
  The most repeatable, but code to maintain and to get approved in each organisation
* **An existing test-smell detector mapped onto the toolkit's lists**  
  Reuses prior art, but each tool needs checking for maintenance, licence, old JDKs and Cucumber, and covers one skill

## Decision Outcome

Chosen in discussion: exact searches, then reading only what they find. A skill that looks through a repo's code,
tests or settings gives the search for each thing it looks for, in a plain code block (not a table, where `|` has to
be escaped). Where no search can settle something, the skill says which files to read and the report says what wasn't
checked. Line numbers always come from a search.

### Consequences

* find-test-anti-patterns lists tests and finds each anti-pattern by search, including Cucumber scenarios and the
  Spring XML a test loads.
* The connection list drafted from settings files uses searches the same way.
* Each skill's searches are tried with the macOS and GNU versions of `grep`, which differ.
* An eval case's example repo is still small; the field trial on large public repos checks that searching scales.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [The journey is field-trialled on old releases of well-known public repos before any organisation pilot](0050-the-journey-is-field-trialled-on-old-releases-of-well-known-public-repos-before-any-organisation-pilot.md)
* Later decisions that build on this: none yet
* Background: none
