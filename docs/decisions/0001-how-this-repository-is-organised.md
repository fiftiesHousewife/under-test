---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# How this repository is organised

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

This repo holds the rules, tools and AI assistant skills for the programme; lessons live in their own repo. People and tools both need to find things in predictable places.

## Considered Options

* **One top-level folder per kind of content, with a machine-readable file next to each human-readable one**  
  Easy to find things; tools can read the same files people do
* **Organise by programme phase**  
  Content that spans phases (techniques, shared test kits) has no obvious home

## Decision Outcome

Chosen in discussion: one folder per kind of content: `docs/decisions/` (the toolkit's own decisions), `decision-guides/` (guides for adopting organisations), `techniques/<id>/technique.yaml` (rules the tools read), lessons in their own repo, [under-test-lessons](https://github.com/fiftiesHousewife/under-test-lessons) (lesson, runnable example, exercise, video scripts), `templates/` (starting points an organisation copies, including a testing guide and a shared test kit; see [Testing guides and shared test kits belong to each organisation, and the toolkit provides templates for them](0033-testing-guides-and-shared-test-kits-belong-to-each-organisation-and-the-toolkit-provides-templates-for-them.md)), `examples/organisation-repo/` (the shape of an organisation's private organisation repo), `self/` (this repo's own organisation profile, as its own first adopter), `schema/`, `tools/<id>/` (tools adopting organisations run), `maintainer-tools/` (tools that keep this repo itself in order), `plan/`, `.github/skills/`, and `GLOSSARY.md`. Testing guides refer to techniques by id and never copy their rules. Summaries by organisation unit are views over the central results store, not files. Group, package and plugin ids use `io.github.fiftieshousewife`.

### Consequences

* `settings.gradle.kts` automatically includes any `tools/*` folder containing a `build.gradle.kts`.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Organisation-specific facts and decisions live in a private organisation repo](0003-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md), [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md), [Lessons live in their own repo, with a copy of the build conventions](0017-lessons-live-in-their-own-repo-with-a-copy-of-the-build-conventions.md), [Testing guides and shared test kits belong to each organisation, and the toolkit provides templates for them](0033-testing-guides-and-shared-test-kits-belong-to-each-organisation-and-the-toolkit-provides-templates-for-them.md), [This repo's own upkeep is kept apart from what adopting organisations use](0034-this-repos-own-upkeep-is-kept-apart-from-what-adopting-organisations-use.md), [The README describes the journey and links every decision guide, and the build checks it does](0035-the-readme-describes-the-journey-and-links-every-decision-guide-and-the-build-checks-it-does.md)
* Background: none
