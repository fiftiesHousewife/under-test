---
status: proposed
decision-makers: Toolkit Owner
group: Using the toolkit in an organisation
---

# Lesson videos ship as editable layers, so organisations can rebrand, trim and revoice them

**Decided by:** Toolkit Owner · **Status:** proposed

## Context and Problem Statement

Organisations want to add their own branding at the start and end of videos, trim them, use their own terms, or replace the voice with their own. Finished videos alone make that hard.

## Considered Options

* **Each video ships as layers: silent screen recording, narration audio (whole and per step), narration script, captions (WebVTT and SRT), the finished video, and its VHS source. Organisations can edit the layers in any approved video editor, revoice from the script, or re-render automatically using a branding file in their organisation repo (intro clip, outro clip, voice, caption style) and a small step built on ffmpeg**  
  Easy to customise with no new tools; automatic re-branding at each release
* **Finished videos only**  
  Re-branding means editing by hand every release

## Decision Outcome

Proposed: the first option. Organisation branding lives in the organisation repo, never in the toolkit.

### Consequences

* The video build writes every layer.
* A branding file format, with a schema, and the re-render step.
* A section in docs/CORPORATE-USE.md.

## More Information

* Builds on: [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md), [Organisation-specific facts and decisions live in a private organisation repo](0005-organisation-specific-facts-and-decisions-live-in-a-private-organisation-repo.md)
* Later decisions that build on this: none yet
* Background: none
