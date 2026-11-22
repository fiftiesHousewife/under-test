# Skill eval results

Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in
[.github/evals/](../../.github/evals/README.md), at toolkit commit `e23b5f6` (with uncommitted changes to the skills or the cases), with Claude Code
2.1.330, model sonnet. Each case ran several times with the toolkit's skills and as many times
without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes
when every run with the skills scores 1. Every file a run wrote in `testing/` is also checked against
the toolkit's schemas.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| render-the-assessment-report | `shows-every-decision` | 1 | 1 (1) | 0 | $0.14 / $0 | 8 / 0 | 16 s / 0 s | not checked / not checked |

## Checks that failed with the skills

None.

Total cost of this run of the evals: $0.14.
