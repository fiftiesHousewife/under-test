---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A skill keeps each kind of repo in its own file, and reads only the ones that apply

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Repos differ in ways that change what a skill has to do: Maven or Gradle, one module or several, JUnit 4, 5 or 6,
Cucumber feature files, Spring XML. Written into one skill file, every run reads every rule, whatever the repo, which
costs time and money and gives the AI assistant rules that don't apply to mistake for ones that do. A skill per
combination would multiply: four independent differences already make sixteen.

## Considered Options

* **A short skill file, with each difference in its own file in the skill's folder, read only when it applies**  
  The skill file says how to tell which apply; scripts in the folder are run, not read
* **One skill per combination**  
  Each short, but many, and a fix has to be made in each
* **Everything in one skill file**  
  Simple to find, but every run reads all of it

## Decision Outcome

Chosen in discussion: the first option. A skill's `SKILL.md` holds what every repo goes through, and a table of which
other file to read when, with the searches that tell. Each difference that only some repos have (a build tool, more
than one module, a test framework, a kind of settings file) is a file of its own beside it, read only when the
table says it applies. A search or script that does work, rather than explaining it, is a file in the skill's
`scripts/` folder, run without being read. A separate skill is only for a different job, not for different details.

### Consequences

* find-test-anti-patterns is split first: `modules.md`, `maven.md`, `cucumber.md`, `spring-xml.md` and
  `scripts/no-real-assertion.awk`.
* measure-a-repo gets its Maven route as a file beside its Gradle one, and the follow-up skill for tests that reach
  external systems its JUnit 4 and JUnit 5 or 6 forms the same way.
* Each skill's eval case still checks the whole skill; an example repo with some differences and not others checks
  that the skill reads only what applies.
* Later, the repo classifier can record what kind of repo it is in the assessment file once, so each skill reads
  those facts instead of telling for itself.

## More Information

* Builds on: [A skill finds what to read by searching, and reads only what the searches find](0054-a-skill-finds-what-to-read-by-searching-and-reads-only-what-the-searches-find.md), [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)
* Later decisions that build on this: [The journey works module by module](0060-the-journey-works-module-by-module.md)
* Background: none
