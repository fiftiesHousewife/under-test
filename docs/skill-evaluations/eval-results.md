# Skill eval results

Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in
[.github/evals/](../../.github/evals/README.md), at toolkit commit `8fe3fe5`, with Claude Code
2.1.331, model sonnet. Each case ran several times with the toolkit's skills and as many times
without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes
when every run with the skills scores 1. Every file a run wrote in `testing/` is also checked against
the toolkit's schemas.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| choose-techniques | `decides-every-technique` | 5 | 1 (1) | 0.87 | $0.47 / $0.6 | 14 / 28 | 148 s / 192 s | 5 of 5 / 5 of 5 |
| draft-the-external-systems-list | `drafts-every-connection` | 5 | 1 (1) | 0.33 | $0.29 / $0.25 | 12 / 12 | 67 s / 67 s | 5 of 5 / 5 of 5 |
| draft-the-external-systems-list | `grades-every-test` | 5 | 1 (1) | 0.29 | $0.28 / $0.23 | 10 / 8 | 66 s / 60 s | 5 of 5 / 5 of 5 |
| find-meaningless-and-unreliable-tests | `counts-every-kind` | 5 | 0.99 (0.96) | 0.33 | $0.33 / $0.21 | 12 / 8 | 105 s / 46 s | 5 of 5 / 5 of 5 |
| render-the-assessment-report | `shows-every-decision` | 5 | 1 (1) | 0.5 | $0.11 / $0.15 | 6 / 3 | 54 s / 43 s | 5 of 5 / 5 of 5 |
| run-the-safety-inventory | `finds-every-kind` | 5 | 1 (1) | 0.23 | $0.15 / $0.14 | 7 / 5 | 37 s / 30 s | 5 of 5 / 5 of 5 |
| score-obstacles | `scores-every-obstacle` | 5 | 1 (1) | 0.93 | $0.17 / $0.18 | 10 / 9 | 30 s / 28 s | 5 of 5 / 5 of 5 |
| write-the-testing-plan | `plans-every-piece-of-work` | 5 | 0.85 (0.26) | 0.36 | $0.28 / $0.36 | 9 / 14 | 74 s / 101 s | 5 of 5 / 5 of 5 |

`measures-five-runs` isn't in this table: the eval's sandbox can't run it, so it runs with
[run-outside-eval.sh](../../maintainer-tools/skill-evals/run-outside-eval.sh).

## Checks that failed with the skills

* find-meaningless-and-unreliable-tests / `counts-every-kind`: `count-disabled`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `fourteen-not-in-plan`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `fourteen-pieces-of-work`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-fix-flaky-tests-flaky-tests`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-make-code-testable-architecture-rules`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-make-code-testable-refactoring-for-testability`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-make-it-run-on-its-own-choose-stand-in-payments-example-com`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-make-it-run-on-its-own-fake-behind-an-interface`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-make-it-run-on-its-own-recorded-http-responses`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-make-it-run-on-its-own-stand-in-db-orders-prod-example-com`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-make-it-run-on-its-own-stand-in-smtp-example-com`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-record-current-behaviour-ai-written-tests`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-record-current-behaviour-characterisation-tests`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-record-current-behaviour-structured-output-comparison`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-strengthen-tests-disabled-tests`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-strengthen-tests-no-real-assertion`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `key-test-against-requirements-business-rule-tests`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `marked-generated`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `no-check-in-production`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `question-listed`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `six-workstreams`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `target-four-unreachable`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `template-note-removed`, in 1 run(s)
* write-the-testing-plan / `plans-every-piece-of-work`: `workstreams-in-order`, in 1 run(s)

Total cost of this run of the evals: $22.37.
