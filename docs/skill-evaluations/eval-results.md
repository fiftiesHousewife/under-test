# Skill eval results

Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in
[.github/evals/](../../.github/evals/README.md), at toolkit commit `c335709`, with Claude Code
2.1.332, model sonnet. Each case ran several times with the toolkit's skills and as many times
without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes
when every run with the skills scores 1. Every file a run wrote in `testing/` is also checked against
the toolkit's schemas.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| draft-the-external-systems-list | `grades-every-openfire-test` | 3 | 0.87 (0.85) | 0.38 | $0.4 / $0.47 | 17 / 16 | 89 s / 115 s | 3 of 3 / 3 of 3 |

`measures-five-runs` isn't in this table: the eval's sandbox can't run it, so it runs with
[run-outside-eval.sh](../../maintainer-tools/skill-evals/run-outside-eval.sh).

## Checks that failed with the skills

* draft-the-external-systems-list / `grades-every-openfire-test`: `database-has-no-address`, in 3 run(s)
* draft-the-external-systems-list / `grades-every-openfire-test`: `every-test-listed`, in 2 run(s)

Total cost of this run of the evals: $2.62.

## Real repos

Two cases run the skill on real repos, against what the field trial's run under the airgap agent showed: Openfire 4.6.0,
where no test reached another machine, and Apache Commons Net 3.6, where 18 did. They ran three times each way, at
toolkit commit `b4023ec`, with Claude Code 2.1.332, model sonnet.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| draft-the-external-systems-list | `grades-every-commons-net-test` | 3 | 0.88 (0.64) | 0.43 | $0.39 / $0.53 | 16 / 16 | 91 s / 130 s | 3 of 3 / 3 of 3 |
| draft-the-external-systems-list | `grades-every-openfire-test` | 3 | 1 (1) | 0.36 | $0.39 / $0.51 | 14 / 18 | 92 s / 127 s | 3 of 3 / 3 of 3 |

Checks that failed with the skills:

* draft-the-external-systems-list / `grades-every-commons-net-test`: `eight-reach`, in 1 run(s)
* draft-the-external-systems-list / `grades-every-commons-net-test`: `every-test-listed`, in 1 run(s)
* draft-the-external-systems-list / `grades-every-commons-net-test`: `no-host-from-test-code`, in 1 run(s)
* draft-the-external-systems-list / `grades-every-commons-net-test`: `one-node-per-system`, in 1 run(s)
* draft-the-external-systems-list / `grades-every-commons-net-test`: `one-relationship-per-system`, in 1 run(s)

These runs cost $5.46 in all.
