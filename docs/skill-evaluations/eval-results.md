# Skill eval results

Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in
[.github/evals/](../../.github/evals/README.md), at toolkit commit `76ff873` (with uncommitted changes to the skills or the cases), with Claude Code
2.1.330, model sonnet. Each case ran several times with the toolkit's skills and as many times
without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes
when every run with the skills scores 1. Every file a run wrote in `testing/` is also checked against
the toolkit's schemas.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| find-test-anti-patterns | `counts-every-kind` | 5 | 0.99 (0.94) | 0.53 | $0.16 / $0.12 | 13 / 6 | 32 s / 20 s | 5 of 5 / 5 of 5 |
| choose-techniques | `decides-every-technique` | 5 | 0.99 (0.97) | 0.87 | $0.52 / $0.61 | 14 / 24 | 158 s / 197 s | 5 of 5 / 5 of 5 |
| draft-the-connection-list | `drafts-every-connection` | 5 | 1 (1) | 0.35 | $0.19 / $0.19 | 9 / 9 | 41 s / 43 s | 5 of 5 / 4 of 5 |
| run-the-safety-inventory | `finds-every-kind` | 5 | 1 (1) | 0.22 | $0.15 / $0.14 | 7 / 5 | 32 s / 25 s | 5 of 5 / 5 of 5 |
| measure-a-repo | `measures-five-runs` | 5 | 0.43 (0) | 0 | $0.07 / $0 | 5 / 0 | 60 s / 0 s | 3 of 3 / not checked |
| write-the-testing-plan | `plans-every-piece-of-work` | 5 | 1 (1) | 0.35 | $0.32 / $0.32 | 9 / 15 | 73 s / 77 s | 5 of 5 / 5 of 5 |
| score-obstacles | `scores-every-obstacle` | 5 | 1 (1) | 0.93 | $0.17 / $0.18 | 8 / 9 | 25 s / 28 s | 5 of 5 / 5 of 5 |
| render-the-assessment-report | `shows-every-decision` | 5 | 1 (1) | 0.54 | $0.1 / $0.18 | 6 / 5 | 13 s / 50 s | 5 of 5 / 5 of 5 |

## Checks that failed with the skills

* find-test-anti-patterns / `counts-every-kind`: `examples-are-method-declarations`, in 1 run(s)
* choose-techniques / `decides-every-technique`: `defer-mutation-testing`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `all-local`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `branch-coverage`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `count-six-tests`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `five-caught`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `five-runs`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `found-by-the-skill`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `fourteen-planted`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `level-zero`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `line-coverage`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `mail-test-left-out`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `marker-test-left-out`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `one-disabled`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `one-failing`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `one-flaky`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `reply-names-flaky-test`, in 1 run(s)
* measure-a-repo / `measures-five-runs`: `reply-names-refused-address`, in 1 run(s)

## Runs that didn't start or finish

* `measures-five-runs`, with: API Error: Unable to connect to API: SSL certificate verification failed (UNABLE_TO_VERIFY_LEAF_SIGNATURE). The certificates the server sent don't lead to a trusted authority. If the server leaves out an intermediate certificate, which browsers fetch by themselves, whoever runs it must have it send its full chain. If it is a TLS-inspecting corporate proxy or a gateway signed by a private CA, set NODE_EXTRA_CA_CERTS to that CA bundle, or add it to the system certificate store · see https://code.claude.com/docs/en/network-config
* `measures-five-runs`, with: set-up failed: curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
* `measures-five-runs`, with: set-up failed: curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
* `measures-five-runs`, without: set-up failed: curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
* `measures-five-runs`, without: set-up failed: curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
* `measures-five-runs`, without: set-up failed: curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
* `measures-five-runs`, without: set-up failed: curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
* `measures-five-runs`, without: set-up failed: curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.

Total cost of this run of the evals: $17.05.
