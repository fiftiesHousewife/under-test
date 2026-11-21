---
status: proposed
decision-makers: Technical Architect
group: AI-written tests
---

# How AI assistant skills and instructions reach every repo

**Decided by:** Technical Architect · **Status:** proposed (open)

## Context and Problem Statement

Skills and instructions live in this repo but are needed in every repo. Some code-hosting platforms may offer organisation-wide skills.

## Considered Options

* **Copied into each repo by an automated pull request when they change**  
  Works today; many copies
* **Vendored once into a template**  
  Simple; goes stale
* **Declared as dependencies with APM (Agent Package Manager): each repo's `apm.yml` names the toolkit's skills, pinned to a version, and `apm install` puts them where each AI assistant looks; a lock file records exact versions**  
  Works today across several AI assistants; one source, no copies to drift; APM is young and changes quickly, so pin its version
* **Organisation-level skills, where the code-hosting platform supports them**  
  One copy; not available yet

## Decision Outcome

Not yet chosen. The options are below. This toolkit itself already uses APM for the external skills it depends on. Open.

### Consequences

* the AI assistant skill used in every repo.

## More Information

* Builds on: [People do the work with AI coding assistance, and review everything it produces](../../../docs/decisions/0022-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md)
* Later decisions that build on this: none yet
* Background: none
