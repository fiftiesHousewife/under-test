---
status: proposed
decision-makers: Technical Architect
group: Rolling out
---

# From the first piece of work, no change may lower a repo's measured results

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Once a repo is measured, each piece of work in its testing plan moves its results: more code run by tests, more planted
bugs caught, fewer flaky and meaningless tests. Re-measuring monthly, and reporting mutation results in pull requests
without blocking ([Mutation testing in pull requests reports only at first](0055-mutation-testing-in-pull-requests-reports-only-at-first.md)),
lets a change quietly undo that progress between measurements.

## Considered Options

* **A ratchet: from the first piece of work, a change may not lower the repo's last measured results**  
  Progress can't slip back; teams see the rule from day one
* **Report only, and gate after handover**  
  Less friction early, but progress can be lost unnoticed
* **Gate only the code a change touches (its new and changed lines)**  
  Lighter, and common, but the repo's overall results can still fall

## Decision Outcome

Proposed: the first option.

* **What is ratcheted:** the results measure-a-repo records in the assessment file's `tests` section: line and
  branch coverage, the share of planted bugs caught, and the counts of flaky, failing, disabled, meaningless and
  unreliable tests. A share may not fall and a count may not rise.
* **From when:** the repo's first measurement. The check keeps the last measured values and fails a change that falls
  below them; a change that improves a result raises its bar.
* **How:** CI runs the same measurement on the change, with the same settings, and compares. Where planted bugs take
  too long for every change, they run nightly, and the ratchet on them blocks the next change after a nightly run that
  fell.
* **An exception** needs the Application Owner's decision, recorded in the assessment file, such as a test deleted
  once the approval-test baseline covers its behaviour.

This narrows [Mutation testing in pull requests reports only at first](0055-mutation-testing-in-pull-requests-reports-only-at-first.md):
mutation results still report in pull requests, and from the first measurement they also may not fall.

### Consequences

* A check, in under-test-tools or a CI template, compares a change's measurement with the repo's last one.
* The journey's "Keep it there" step starts at the first piece of work, not at handover.

## More Information

* Builds on: [Mutation testing in pull requests reports only at first](0055-mutation-testing-in-pull-requests-reports-only-at-first.md), [Progress is measured by required tests met, alongside coverage and mutation results](0014-progress-is-measured-by-required-tests-met-alongside-coverage-and-mutation-results.md), [How often repos are re-scanned and re-measured](0056-how-often-repos-are-re-scanned-and-re-measured.md)
* Later decisions that build on this: none yet
* Background: [mutation-testing](../docs/REFERENCES.md#mutation-testing)
