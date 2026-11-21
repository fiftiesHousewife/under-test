---
status: proposed
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts

**Decided by:** Toolkit maintainers · **Status:** proposed (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

People learn techniques best from short, real examples they can watch and then run. Lessons that drift from the code teach the wrong thing, and hand-recorded videos go stale with every change.

## Considered Options

* **Each technique lesson has a runnable before-and-after example, an exercise with an answer, and a terminal video generated from a script with VHS (MIT licence) in the toolkit's own CI. A check in the build runs every command a lesson shows and confirms its stated result. Learning paths group lessons by role. Videos are published as files with each release, so organisations receive them like any other content and never need VHS themselves**  
  Lessons and videos can't drift; organisations need nothing new
* **Hand-recorded screencasts**  
  Go stale with every change; can't be regenerated
* **Text-only lessons**  
  Harder for many people to follow

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option, starting with terminal videos. Every video also has captions, and a spoken voiceover, both generated from the same narration text kept with the lesson. The voice is an open-source text-to-speech engine that runs offline in the toolkit's CI (no accounts or keys), chosen after checking the licences of the engine and its voice. Organisations receive finished MP4 files with captions, so they never need the speech engine. GIFs stay silent.

### Consequences

* `.tape` script and narration text per lesson, and a CI workflow that renders video, voice and captions.
* Learning paths by role.
* A lesson-command check in the build.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [How this repository is organised](0001-how-this-repository-is-organised.md)
* Later decisions that build on this: [Lessons live in their own repo, with a copy of the build conventions](0017-lessons-live-in-their-own-repo-with-a-copy-of-the-build-conventions.md), [Lesson videos ship as editable layers, so organisations can rebrand, trim and revoice them](0018-lesson-videos-ship-as-editable-layers-so-organisations-can-rebrand-trim-and-revoice-them.md)
* Background: none
