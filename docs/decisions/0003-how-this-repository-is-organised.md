---
status: proposed
decision-makers: Technical Architect
group: How we work
---

# How this repository is organised

**Decided by:** Technical Architect · **Status:** proposed

## Context and Problem Statement

This repo holds the rules, tools, AI assistant skills and lessons for the programme. People and tools both need to find things in predictable places.

## Considered Options

* **One top-level folder per kind of content, with a machine-readable file next to each human-readable one**  
  Easy to find things; tools can read the same files people do
* **Organise by programme phase**  
  Content that spans phases (techniques, shared test kits) has no obvious home

## Decision Outcome

Proposed: one folder per kind of content: `adr/`, `techniques/<id>/` (lesson, runnable example, `technique.yaml` rules), `testing-guides/technology-stacks/<id>/`, `testing-guides/application-types/<id>/`, `shared-test-kits/<system-id>/`, `applications/<app-id>/`, `schema/`, `tools/<id>/`, `plan/`, `.github/skills/`, and `GLOSSARY.md`. Testing guides refer to techniques by id and never copy their rules. Summaries by organisation unit are views over the central results store, not files. Group, package and plugin ids use `io.github.fiftieshousewife`.

### Consequences

* `settings.gradle.kts` automatically includes any `techniques/*/example`, `tools/*` or `shared-test-kits/*` folder containing a `build.gradle.kts`.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Organisation-specific facts and decisions live in a private organisation repo](0005-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md), [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md)
* Background: none
