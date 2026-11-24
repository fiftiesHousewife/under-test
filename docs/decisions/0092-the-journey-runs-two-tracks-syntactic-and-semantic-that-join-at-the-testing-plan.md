---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The journey runs two tracks, syntactic and semantic, that join at the testing plan

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The journey page lists nine steps in one sequence: discovery, the safety inventory, measurement, repair, capturing
current behaviour, intended behaviour, the testing plan, the work, and keeping it there. The steps answer two
different questions, from different evidence. Finding the external systems, the meaningless and unreliable tests,
measuring and repairing all ask whether a repo's tests can run and can be trusted, and read the code, its settings
and its test runs. The source list, approval tests and intended behaviour all ask what the code does and what it
should do, and read people's documents, captured behaviour and experts' answers. In one sequence, a step of one kind
waits for steps of the other kind it doesn't need: the source list is drawn up in discovery, but intended behaviour
comes after repair, though it reads nothing repair writes.

## Considered Options

* **Two tracks, by the question each step answers, joining at the testing plan**  
  Each track runs its own steps in order; neither waits for the other except where it reads what the other writes
* **One sequence of nine steps**  
  The journey page as it was: one order to follow, at the cost of steps waiting on others they don't need
* **Tracks by person**  
  One track for the developers, one for the Knowledge Curator and the experts; but the same person often works on
  both kinds of question, and the split says nothing about what each step needs

## Decision Outcome

Chosen in discussion: two tracks, by the question each step answers.

**The syntactic track** asks "can its tests run here, and can they be trusted?". It is about the tests as code:

1. finding what stops tests running: the external systems, from the code with under-test-external-calls and the
   [draft-the-external-systems-list](../../.github/skills/draft-the-external-systems-list/SKILL.md) skill, and the
   meaningless and unreliable tests;
2. measurement, under the airgap agent;
3. repair, which pairs the tests that reach external systems;
4. measuring again.

**The semantic track** asks "what does the code do, and what should it do?". It is about what the code means:

1. finding the sources of intended behaviour: the source list;
2. capturing current behaviour, with approval tests at the code's edges;
3. eliciting intended behaviour: the AI drafts functional requirements from the sources, citing each, and people
   confirm them;
4. designing tests from the requirements.

The safety inventory gates both tracks: nothing on either runs a test or the application before it is settled. Within
each track the steps run in order; between them, a step waits only for what it reads from the other, and a repo's
code first runs in measurement, as
[A repo's code first runs in measurement, which comes before capturing current behaviour and again after it](0058-a-repos-code-first-runs-in-measurement-which-comes-before-capturing-current-behaviour-and-again-after-it.md)
settled. The tracks join at the testing plan, which takes both tracks' findings; the work and keeping it there follow.

### Consequences

* The [glossary](../../GLOSSARY.md) gains "syntactic" and "semantic" as the toolkit's own words for the two tracks,
  each with its question; its rule against giving "track" a special meaning needs the same exception.
* The [journey page](../JOURNEY.md), its drawing and the README's summary of the journey follow: two tracks after the
  safety inventory, joining at the testing plan.
* The older use of "two tracks", for current behaviour against intended behaviour in
  [Current and intended behaviour are recorded side by side, and every difference is an open question](../../decision-guides/0033-current-and-intended-behaviour-are-recorded-side-by-side-and-every-difference-is-an-open-question.md),
  is renamed, so the words mean one thing.

## More Information

* Builds on: [A repo's code first runs in measurement, which comes before capturing current behaviour and again after it](0058-a-repos-code-first-runs-in-measurement-which-comes-before-capturing-current-behaviour-and-again-after-it.md), [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md), which [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md) replaces, [Discovery keeps three lists of tests apart: those that reach external systems, meaningless tests, and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)
* Later decisions that build on this: [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md)
* Background: [legacy-code](../REFERENCES.md#legacy-code)
