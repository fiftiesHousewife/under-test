---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Each technique rule separates what calls for the technique from what makes it possible

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Each technique's rule had one `adopt_when` list. Some of its conditions say the technique is wanted ("business rules
live in stored procedures"), others only that it can be done ("the engine can run in a container"). The schema said
all must hold; the choose-techniques skill read any one as enough. Reviews of the skill showed that no single reading
of one list gives the right choice for every technique: database unit tests must wait until it is known whether there
are stored procedures, even though the engine runs in a container, while characterisation tests are called for by
tests that check nothing, even though some enabling facts are unknown.

## Considered Options

* **Two lists: `needed_when` (any one true calls for it) and `possible_when` (all must hold, or be planned work)**  
  Each choice can be traced to one rule and checked; the technique files change once
* **One list, any one true**  
  Simpler, but adopts a technique on what makes it possible alone
* **One list, all must hold**  
  Defers most techniques on some unknown condition that only makes it possible

## Decision Outcome

Chosen in discussion: the first option. A technique is rejected when every need is known false, or a reason against it
is known and permanent; deferred when no need is known true but one is unknown, a condition that makes it possible is
unknown, a reason against it will change, an outside approval is missing, or its evidence is only above the target;
and adopted when a need is true and every condition that makes it possible holds or is planned work.

### Consequences

* `schema/technique.schema.json` and every `techniques/*/technique.yaml` use `needed_when` and `possible_when`.
* The [choose-techniques](../../.github/skills/choose-techniques/SKILL.md) skill and its eval case follow the rule.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)
* Later decisions that build on this: none yet
* Background: none
