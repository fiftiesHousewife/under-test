---
status: proposed
decision-makers: Technical Architect
group: Capturing current behaviour
---

# Differential tests replay saved requests offline, and live comparison runs only on read-only traffic

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A differential test sends the same requests to the old version and the new one, and compares the answers. Done live, it
sends real requests twice, which is harmless for reads and dangerous for anything that changes data.

## Considered Options

* **Offline by default: saved, cleaned requests are replayed against old and new builds with recorded responses
  standing in for their dependencies; live comparison only on read-only endpoints, with named approvals**  
  No real request is sent twice; live comparison stays possible where it is safe
* **Live mirroring with comparison inside production's boundary**  
  Realistic, but every write is a risk
* **A comparison proxy such as Diffy**  
  Ruled out: the original is archived and its only fork has a non-commercial licence

## Decision Outcome

Proposed: offline by default, the default the toolkit maintainers chose in discussion, from
[capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md).

### Consequences

* [The differential-testing technique](../techniques/differential-testing/technique.yaml) prefers offline replay.
* A replay helper may be built, if no existing tool replays saved requests against two builds.

## More Information

* Builds on: [Black-box captures are taken in non-production first, and from production only with named approvals](0060-black-box-captures-are-taken-in-non-production-first-and-from-production-only-with-named-approvals.md), [Captured data is cleaned inside the environment it was captured in, before it is copied anywhere](0062-captured-data-is-cleaned-inside-the-environment-it-was-captured-in-before-it-is-copied-anywhere.md)
* Later decisions that build on this: none yet
* Background: [capturing and cleaning black-box data](../docs/research/capturing-and-cleaning-black-box-data.md)
