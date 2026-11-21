---
status: proposed
decision-makers: Toolkit maintainers
group: How we work
---

# How this repository is organised

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

This repo holds the rules, tools and AI assistant skills for the programme; lessons live in their own repo. People and tools both need to find things in predictable places.

## Considered Options

* **One top-level folder per kind of content, with a machine-readable file next to each human-readable one**  
  Easy to find things; tools can read the same files people do
* **Organise by programme phase**  
  Content that spans phases (techniques, shared test kits) has no obvious home

## Decision Outcome

Proposed: one folder per kind of content: `docs/decisions/` (the toolkit's own decisions), `decision-guides/` (guides for adopting organisations), `techniques/<id>/technique.yaml` (rules the tools read), lessons in their own repo, [under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons) (lesson, runnable example, exercise, video scripts), `testing-guides/technology-stacks/<id>/`, `testing-guides/application-types/<id>/`, `shared-test-kits/<system-id>/`, `applications/<app-id>/`, `schema/`, `tools/<id>/`, `plan/`, `.github/skills/`, and `GLOSSARY.md`. Testing guides refer to techniques by id and never copy their rules. Summaries by organisation unit are views over the central results store, not files. Group, package and plugin ids use `io.github.fiftieshousewife`.

### Consequences

* `settings.gradle.kts` automatically includes any `techniques/*/example`, `tools/*` or `shared-test-kits/*` folder containing a `build.gradle.kts`.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Organisation-specific facts and decisions live in a private organisation repo](0003-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md), [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md), [Lessons live in their own repo, with a copy of the build conventions](0017-lessons-live-in-their-own-repo-with-a-copy-of-the-build-conventions.md)
* Background: none
