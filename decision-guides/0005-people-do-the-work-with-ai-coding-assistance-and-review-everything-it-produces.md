---
status: proposed
decision-makers: Programme Sponsor
group: How we work
---

# People do the work with AI coding assistance, and review everything it produces

**Decided by:** Programme Sponsor · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

AI can draft tests, plans and changes quickly, but it can be confidently wrong. Organisations approve specific AI assistants; the organisation profile lists which.

## Considered Options

* **A person directs an AI assistant in their editor or terminal, reviews everything it produces, and owns the result; automated checks back them up**  
  Fast drafting with a person accountable for every change
* **AI works unattended**  
  See the next decision: a future direction only

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the first option. The AI never chooses a test stand-in approach, approves a snapshot, or decides what the right answer for a test is.

### Consequences

* Work done with AI help is marked as done by a person with AI coding assistance.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [How AI assistant skills and instructions reach every repo](../docs/decisions/0019-how-ai-assistant-skills-and-instructions-reach-every-repo.md), [Independent AI agents working unattended are a future direction only](0006-independent-ai-agents-working-unattended-are-a-future-direction-only.md), [Repos are classified by rules only, so results can be explained and repeated](../docs/decisions/0025-repos-are-classified-by-rules-only-so-results-can-be-explained-and-repeated.md), [The checks an AI-written test must pass before it is kept](0047-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md)
* Background: [ai-written-tests](../docs/REFERENCES.md#ai-written-tests)
