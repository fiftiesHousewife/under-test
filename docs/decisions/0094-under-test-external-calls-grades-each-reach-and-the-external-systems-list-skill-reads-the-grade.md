---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# under-test-external-calls grades each reach, and the external systems list skill reads the grade

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Each test is graded reaches, may reach or cannot reach](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md),
by a table of rules over facts under-test-external-calls already records for each reach: the address as the test's
settings give it, the first call on a mock, and the embedded servers the test starts. The
[draft-the-external-systems-list](../../.github/skills/draft-the-external-systems-list/SKILL.md) skill applies the
table, and the check of discovery against a run under the airgap agent applies it again. A program can decide the
grade from the facts alone, the same way every time, and two copies of the table can drift.

## Considered Options

* **The tool computes the grade and its reason**  
  One copy of the rules, in the program with the facts; the skill and the check read the result
* **The skill keeps the table**  
  Nothing changes in the tool; the AI applies the rules on every run, and the check keeps its own copy

## Decision Outcome

Chosen in discussion: under-test-external-calls computes each reach's grade (reaches, may reach, or cannot reach)
and the reason for it, from the facts it already has, and its facts format gets a new version to carry them. The
skill and the check of discovery read the grade, and stop applying the table themselves. Until the tool's released
version carries grades, the skill's table stays.

### Consequences

* under-test-external-calls gains the grade, with a case for each grade and each reason in its example repo.
* The skill's table of rules is removed once the skill pins a version that carries grades; its eval case keeps a test
  of each grade.
* [The check of discovery](../design/checking-discovery-against-a-run-under-the-airgap-agent.md) compares the
  tool's grades with the airgap run directly.

## More Information

* Builds on: [connection-paths does everything a program can decide, and the connection-list skill only what needs judgement](0074-connection-paths-does-everything-a-program-can-decide-and-the-connection-list-skill-only-what-needs-judgement.md), [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md), [Each test is graded reaches, may reach or cannot reach, from the address its own settings give](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md)
* Later decisions that build on this: none yet
* Background: none
