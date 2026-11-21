---
status: proposed
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Lessons live apart from technique rules and move to their own repo once the convention plugin is published

**Decided by:** Toolkit maintainers · **Status:** proposed (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Lessons serve anyone learning testing; the toolkit serves organisations running a programme. Lessons and videos change faster and are heavier. But lessons build on the toolkit's convention plugin, which isn't published yet, and the technique rules belong to the toolkit because its tools read them.

## Considered Options

* **Keep one repo for now with the two concerns apart: technique rules in `techniques/<id>/technique.yaml`; lessons (README, example, exercise, video and narration scripts) in `lessons/<id>/`, published as their own lessons bundle. Move `lessons/` to its own repo once the convention plugin is published, or once lessons have their own contributors**  
  Easy to split later; no cross-repo links or second backlog yet
* **Separate repo now**  
  Lessons can't build until the convention plugin is published; two backlogs; links between repos
* **Keep lessons and rules together**  
  Harder to split later

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. The lessons bundle (each lesson's video layers, captions and scripts) is published to Maven Central with each toolkit release, under the same version, so organisations receive it through their own package repository. Only finished, reviewed videos are published, because nothing on Maven Central can be deleted.

### Consequences

* `lessons/` holds lesson material; `techniques/` holds rules only.
* Lesson examples build as `:lessons:<id>`.
* A lessons bundle published to Maven Central with each release.

## More Information

* Builds on: [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md), [How this repository is organised](0001-how-this-repository-is-organised.md)
* Later decisions that build on this: none yet
* Background: none
