---
status: proposed
decision-makers: Security and Platform Owner (can veto)
group: Keeping production safe
---

# Before any test or application runs, a safety inventory records what could reach production or real data, and some findings block the run

**Decided by:** Security and Platform Owner (can veto) · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

A secrets scan finds committed passwords and tokens, but an old repo holds other dangers that nothing else looks for
before it first runs: keystores and private keys, production credentials in configuration, real personal data in test
fixtures or database dumps, jobs that start by themselves, database migrations that run against whatever database is
configured, build tasks that publish or deploy, fixed file paths and Windows file shares, and native libraries. Some of
these must be fixed before any test or the application runs; others are harmless once the test profile and the airgap agent are in place,
as long as someone has looked.

## Considered Options

* **A safety inventory before any test or the application runs, tiered: some findings block the run until resolved, the rest are recorded
  and neutralised in the test profile or the build**  
  Every danger is looked for and written down; only the ones a test profile can't make safe hold the repo up
* **Every finding blocks until resolved or accepted**  
  Safest, but slowest, and a scheduler or a publish task is harmless once neutralised
* **Record only; only the secrets scan blocks**  
  Fastest, but relies on the airgap agent and the test profile catching everything else

## Decision Outcome

Proposed: the tiered inventory, the default the toolkit maintainers chose in discussion. The inventory runs after the
secrets scan, alongside discovery, and is settled before any test run or application start; a build that runs no tests
may come before it (the toolkit's own decision:
[The safety inventory is a gate before the first run, and no skill ever copies a secret](../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

**Blocks the run until resolved:** committed secrets (from the secrets scan), keystores and private keys, production
credentials in configuration, and real personal data in fixtures or database dumps.

**Recorded and neutralised, without blocking:** jobs that start by themselves (schedulers, message listeners, start-up
tasks), automatic database migrations, build tasks that publish or deploy, fixed file paths and Windows file shares,
and native libraries. Each is switched off or pointed at a stand-in in the test profile or the build, and the airgap
agent's report confirms nothing slipped through on the first run.

Every finding goes in the repo's assessment file. The Security and Platform Owner signs off anything accepted rather
than fixed.

### Consequences

* The [run-the-safety-inventory](../.github/skills/run-the-safety-inventory/SKILL.md) skill, which writes its findings into the assessment file:
  the secrets rules over the whole history, a `git log` list of every keystore ever added, and the inventory rules over
  current files (see [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](../docs/decisions/0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md)).
* The assessment file gains a section for the inventory's findings, with how each was resolved or neutralised.
* The test profile switches off jobs that start by themselves and automatic migrations by default.
* Discovery starts only once the blocking findings are resolved.

## More Information

* Builds on: [No repo's tests or application run until its secrets scan is clean](0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md), [Old code runs first only where production cannot be reached](0008-old-code-runs-first-only-where-production-cannot-be-reached.md), [A production secret found in a repo is handled as a security incident](0011-a-production-secret-found-in-a-repo-is-handled-as-a-security-incident.md)
* Later decisions that build on this: [Every repo starts with discovery: a draft external systems list, a source list and a check of its existing tests, and a first approval-test baseline follows](0032-every-repo-starts-with-discovery-a-draft-external-systems-list-a-source-list-and-a-check-of-its-existing-tests-and-a-first-approval-test-baseline-follows.md)
* Background: [production-safety](../docs/REFERENCES.md#production-safety)
