---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Until the toolkit's recipes exist, the AI makes repair's mechanical changes, and each repair says which a recipe should make

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md)
gives three mechanical changes to the toolkit's recipes: moving a test class's bodies into a test interface (a
parameterised class on JUnit 4), adding the class that injects the stand-in, and adding the class tagged `external`.
None of those recipes exists yet, and their shape would be a guess until a real repair has been done. Repair's first
trial, on Apache Commons Net, is ready to start.

## Considered Options

* **The AI makes every change for now, a person reviews each pull request, and each repair records which changes were mechanical**  
  Repair can be tried now, and the recipes are built from changes actually made
* **Build the recipes first**  
  Closer to decision 0079, but nothing can be tried until they exist, and they are designed before any real repair

## Decision Outcome

Chosen in discussion: the AI makes the changes for now.

* **Until a recipe for a change exists,** the repair skill makes that change itself, as it already makes the JUnit 3
  conversion ([Repair converts a JUnit 3 test class to JUnit 4 before pairing it](0102-repair-converts-a-junit-3-test-class-to-junit-4-before-pairing-it.md)).
  Every change is still in a pull request a person reviews, one external system at a time.
* **Each repair lists its mechanical changes** in its pull request: for each, the class, which of decision 0079's
  changes it was, and anything a recipe would have had to know that the work order didn't say. That list is what
  under-test-tools' recipes are built from.
* **Once a recipe exists,** the repair skill runs it for its change, and the AI makes only the changes decision 0079
  leaves to it.

This narrows [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md).

### Consequences

* The repair skill no longer waits for the recipes; the recipes item in the backlog is built from repair's lists.
* A person's review carries more weight until the recipes exist, since every change is the AI's.

## More Information

* Builds on: [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md), [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md), [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)
* Later decisions that build on this: none yet
* Background: none
