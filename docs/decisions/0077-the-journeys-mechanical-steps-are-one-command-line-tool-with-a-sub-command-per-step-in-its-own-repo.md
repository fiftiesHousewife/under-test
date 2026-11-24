---
status: proposed
decision-makers: Toolkit maintainers
group: How we work
---

# The journey's mechanical steps are one command-line tool, with a sub-command per step, in its own repo

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[A skill's mechanical steps are done by deterministic tools](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md).
Reviewing the skills finds mechanical steps in most of them: turning gitleaks' reports into the safety section;
listing tests, mapping PMD's hits to them and writing `testing/tests.yaml` and its summary; reading JUnit, JaCoCo and
PIT reports into the assessment file; applying the techniques' rules; generating the testing plan; filling the
report template. They all read and write the same files (`testing/assessment.yaml`, `testing/tests.yaml`) against
the same schemas.

## Considered Options

* **One tool, a sub-command per step, in its own repo** (`under-test-tools`), one runnable jar on Java 17
* **A repo per step**: each small, but each needs its own copy of the code that reads and writes the shared files
* **Scripts in this repo's `tools/`**: no separate release, but organisations' machines would need Python or similar,
  and [code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)

## Decision Outcome

Proposed: one tool. Its sub-commands read and write the toolkit's files through one model generated from the
toolkit's schemas, so a schema change is one change. It is published like connection-paths (a jar beside a version
tag, so an organisation mirrors one file), and each sub-command has its own example repo of known answers. Programs
with uses beyond the toolkit, such as connection-paths, stay in their own repos.

The first sub-command takes find-meaningless-and-unreliable-tests' mechanical steps: list the tests, map PMD's and its copy-paste
detector's hits to them, write their `anti_patterns` in `testing/tests.yaml`, and summarise them in the assessment
file. The skill then runs it, judges what it flags as uncertain, adds the `other` kinds it finds by reading, proposes
decisions and reports.

### Consequences

* Each skill's mechanical steps become a backlog item for a sub-command, in the order the journey runs.
* Until a sub-command exists, its skill does the step from its instructions, as now.

## More Information

* Builds on: [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)
* Later decisions that build on this: none yet
* Background: none
