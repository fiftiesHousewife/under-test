# Skill eval results

Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in
[.github/evals/](../../.github/evals/README.md), at toolkit commit `5315e0f`, with Claude Code
2.1.330, model sonnet. Each case ran several times with the toolkit's skills and as many times
without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes
when every run with the skills scores 1. Every file a run wrote in `testing/` is also checked against
the toolkit's schemas.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| find-test-anti-patterns | `counts-every-kind` | 5 | 0.99 (0.94) | 0.5 | $0.16 / $0.12 | 10 / 8 | 32 s / 22 s | 5 of 5 / 5 of 5 |
| choose-techniques | `decides-every-technique` | 5 | 0.99 (0.97) | 0.88 | $0.49 / $0.63 | 12 / 20 | 156 s / 206 s | 5 of 5 / 5 of 5 |
| draft-the-connection-list | `drafts-every-connection` | 5 | 1 (1) | 0.36 | $0.2 / $0.2 | 9 / 12 | 45 s / 50 s | 5 of 5 / 5 of 5 |
| run-the-safety-inventory | `finds-every-kind` | 5 | 1 (1) | 0.22 | $0.16 / $0.14 | 6 / 5 | 33 s / 29 s | 5 of 5 / 5 of 5 |
| measure-a-repo | `measures-five-runs` | 5 | 1 (1) | 0.86 | $0.14 / $0.16 | 9 / 9 | 72 s / 74 s | 5 of 5 / 5 of 5 |
| write-the-testing-plan | `plans-every-piece-of-work` | 5 | 1 (1) | 0.34 | $0.31 / $0.32 | 10 / 14 | 73 s / 83 s | 5 of 5 / 5 of 5 |
| score-obstacles | `scores-every-obstacle` | 5 | 1 (1) | 0.93 | $0.16 / $0.17 | 9 / 8 | 27 s / 25 s | 5 of 5 / 5 of 5 |
| render-the-assessment-report | `shows-every-decision` | 5 | 1 (1) | 0.5 | $0.1 / $0.17 | 6 / 5 | 14 s / 48 s | 5 of 5 / 5 of 5 |

## Checks that failed with the skills

* find-test-anti-patterns / `counts-every-kind`: `examples-are-method-declarations`, in 1 run(s)
* choose-techniques / `decides-every-technique`: `defer-batch-file-in-file-out`, in 1 run(s)

Total cost of this run of the evals: $18.24.
