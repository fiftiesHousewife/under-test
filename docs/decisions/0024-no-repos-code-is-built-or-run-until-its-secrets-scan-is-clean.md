---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# No repo's code is built or run until its secrets scan is clean

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

## Context and Problem Statement

Many repos hold production secrets in their configuration. Building or running them, by a person or by CI, can use or leak those secrets.

## Considered Options

* **The code-hosting platform's secret scanning and push protection**  
  Built into some code-hosting platforms; covers history and new commits
* **gitleaks or TruffleHog in the pipeline**  
  Open source; we run and tune it
* **No scan; rely on people**  
  Not acceptable at scale

## Decision Outcome

Proposed: every repo is scanned before any build, test run or app start. The code-hosting platform's own secret scanning if available, otherwise gitleaks; the organisation profile records which. Findings are recorded in the assessment file and the repo is blocked from running.

### Consequences

* the secrets scan.
* The measurement run and classifier depend on a clean scan.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Independent AI agents working unattended are a future direction only](0023-independent-ai-agents-working-unattended-are-a-future-direction-only.md), [A production secret found in a repo is handled as a security incident](0028-a-production-secret-found-in-a-repo-is-handled-as-a-security-incident.md), [Which existing tools the repo classifier combines](0048-which-existing-tools-the-repo-classifier-combines.md)
* Background: [production-safety](../REFERENCES.md#production-safety)
