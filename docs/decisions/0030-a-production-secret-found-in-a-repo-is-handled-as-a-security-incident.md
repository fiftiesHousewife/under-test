---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# A production secret found in a repo is handled as a security incident

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

## Context and Problem Statement

A secret in a repo may already have leaked. Treating it as a test failure would leave it live.

## Considered Options

* **Security incident: rotate the secret, then unblock the repo**  
  Closes the risk
* **Log it and carry on**  
  The secret stays usable

## Decision Outcome

Proposed: the first option.

### Consequences

* The secrets-scan tool opens an incident, not a testing issue.

## More Information

* Builds on: [No repo's code is built or run until its secrets scan is clean](0026-no-repos-code-is-built-or-run-until-its-secrets-scan-is-clean.md)
* Later decisions that build on this: none yet
* Background: none
