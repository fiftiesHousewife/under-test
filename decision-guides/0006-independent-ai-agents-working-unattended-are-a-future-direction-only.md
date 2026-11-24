---
status: proposed
decision-makers: Programme Sponsor
group: How we work
---

# Independent AI agents working unattended are a future direction only

**Decided by:** Programme Sponsor · **Status:** proposed (agreed in discussion)

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Some AI coding agents can be assigned work items to do on their own. Unattended AI working on repos that may hold production secrets needs approval, vetting and testing first.

## Considered Options

* **Out of scope now; a future direction after approval, a security review and a measured trial**  
  Safe; slower to scale
* **Allow it now on low-risk repos**  
  Faster, but before the safety decisions are in place

## Decision Outcome

Agreed in discussion, waiting for approval by pull request: the first option.

### Consequences

* the work item for independent AI agents stays blocked until approval, vetting and a trial are done.

## More Information

* Builds on: [People do the work with AI coding assistance, and review everything it produces](0005-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md), [No repo's tests or application run until its secrets scan is clean](0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md), [Old code runs first only where production cannot be reached](0008-old-code-runs-first-only-where-production-cannot-be-reached.md)
* Later decisions that build on this: none yet
* Background: none
