# Skill eval results

Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in
[.github/evals/](../../.github/evals/README.md), at toolkit commit `5bda446`, with Claude Code
2.1.330, model sonnet. Each case ran several times with the toolkit's skills and as many times
without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes
when every run with the skills scores 1. Every file a run wrote in `testing/` is also checked against
the toolkit's schemas.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| find-test-anti-patterns | `counts-every-kind` | 5 | 0.99 (0.94) | 0.53 | $0.16 / $0.12 | 13 / 6 | 32 s / 20 s | 5 of 5 / 5 of 5 |
| choose-techniques | `decides-every-technique` | 5 | 0.99 (0.97) | 0.88 | $0.49 / $0.63 | 12 / 20 | 156 s / 206 s | 5 of 5 / 5 of 5 |
| draft-the-connection-list | `drafts-every-connection` | 5 | 1 (1) | 0.35 | $0.19 / $0.19 | 9 / 9 | 41 s / 43 s | 5 of 5 / 4 of 5 |
| run-the-safety-inventory | `finds-every-kind` | 5 | 1 (1) | 0.22 | $0.15 / $0.14 | 7 / 5 | 32 s / 25 s | 5 of 5 / 5 of 5 |
| measure-a-repo | `measures-five-runs` | 5 | 1 (1) | 0.91 | $0.15 / $0.17 | 9 / 9 | 67 s / 76 s | 5 of 5 / 5 of 5 |
| write-the-testing-plan | `plans-every-piece-of-work` | 5 | 1 (1) | 0.35 | $0.32 / $0.32 | 9 / 15 | 73 s / 77 s | 5 of 5 / 5 of 5 |
| score-obstacles | `scores-every-obstacle` | 5 | 1 (1) | 0.93 | $0.17 / $0.18 | 8 / 9 | 25 s / 28 s | 5 of 5 / 5 of 5 |
| render-the-assessment-report | `shows-every-decision` | 5 | 1 (1) | 0.54 | $0.1 / $0.18 | 6 / 5 | 13 s / 50 s | 5 of 5 / 5 of 5 |

## Checks that failed with the skills

* find-test-anti-patterns / `counts-every-kind`: `examples-are-method-declarations`, in 1 run(s)
* choose-techniques / `decides-every-technique`: `defer-batch-file-in-file-out`, in 1 run(s)

Total cost of this run of the evals: $18.24.
