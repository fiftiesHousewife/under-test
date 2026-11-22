---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# No repo's code is built or run until its secrets scan is clean

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Many repos hold production secrets in their configuration. Building or running them, by a person or by CI, can use or leak those secrets.

## Considered Options

* **gitleaks (MIT) on every repo, history included, whatever the platform; the platform's own scanning as well, where
  it has it**  
  One tool everywhere gives the same results in one report format, which the toolkit writes into each assessment file.
  We run and tune it. TruffleHog is an alternative but is AGPL-licensed, a strong copyleft licence
* **The code-hosting platform's secret scanning and push protection where available, gitleaks otherwise**  
  Less to run; covers history and new commits; but results come in a different shape on each platform, and on some
  platforms scanning private repos costs extra
* **Both, required**  
  Strongest; organisations without paid platform scanning can't comply
* **No scan; rely on people**  
  Not acceptable at scale

## Decision Outcome

Proposed: every repo is scanned with gitleaks, its whole history included, before any build, test run or app start.
Where the code-hosting platform has its own secret scanning and push protection, switch it on too: it catches new
secrets as they are pushed, but it doesn't replace the gitleaks scan. Findings are recorded in the assessment file and
the repo is blocked from running until they are resolved. A finding that isn't a real secret (a test fixture, an
example key) is resolved only by adding it to the repo's `.gitleaksignore` with a one-line reason, in a pull request
that the Security and Platform Owner, or someone they delegate, approves; so every exemption is reviewed and kept in
source control. (The toolkit maintainers chose gitleaks over the platform's
scanning as the default; an organisation may still narrow or replace this.)

### Consequences

* The secrets scan, built on gitleaks, writes its findings into the assessment file.
* The measurement run and classifier depend on a clean scan.
* gitleaks is feature complete: it gets security fixes only. That suits a stable scanner, and it is rechecked at
  each release under [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](../docs/decisions/0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md).
* The scan is the first part of the safety inventory, in [Before any code runs, a safety inventory records what could reach production or real data, and some findings block the run](0057-before-any-code-runs-a-safety-inventory-records-what-could-reach-production-or-real-data-and-some-findings-block-the-run.md).

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Independent AI agents working unattended are a future direction only](0006-independent-ai-agents-working-unattended-are-a-future-direction-only.md), [A production secret found in a repo is handled as a security incident](0011-a-production-secret-found-in-a-repo-is-handled-as-a-security-incident.md), [Which existing tools the repo classifier combines](../docs/decisions/0026-which-existing-tools-the-repo-classifier-combines.md)
* Background: [production-safety](../docs/REFERENCES.md#production-safety)
