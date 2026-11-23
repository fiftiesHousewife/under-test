# Skill eval results

Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in
[.github/evals/](../../.github/evals/README.md), at toolkit commit `64f6482`, with Claude Code
2.1.330, model sonnet. Each case ran several times with the toolkit's skills and as many times
without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes
when every run with the skills scores 1. Every file a run wrote in `testing/` is also checked against
the toolkit's schemas.

| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |
|---|---|---|---|---|---|---|---|---|
| find-test-anti-patterns | `counts-every-kind` | 5 | 0.89 (0.53) | 0.29 | $0.36 / $0.22 | 11 / 9 | 258 s / 48 s | 3 of 5 / 5 of 5 |
| choose-techniques | `decides-every-technique` | 5 | 0.99 (0.97) | 0.88 | $0.49 / $0.63 | 12 / 20 | 156 s / 206 s | 5 of 5 / 5 of 5 |
| draft-the-connection-list | `drafts-every-connection` | 5 | 1 (1) | 0.36 | $0.2 / $0.2 | 9 / 12 | 45 s / 50 s | 5 of 5 / 5 of 5 |
| run-the-safety-inventory | `finds-every-kind` | 5 | 1 (1) | 0.22 | $0.16 / $0.14 | 6 / 5 | 33 s / 29 s | 5 of 5 / 5 of 5 |
| measure-a-repo | `measures-five-runs` | 5 | 1 (1) | 0.86 | $0.14 / $0.16 | 9 / 9 | 72 s / 74 s | 5 of 5 / 5 of 5 |
| write-the-testing-plan | `plans-every-piece-of-work` | 5 | 1 (1) | 0.34 | $0.31 / $0.32 | 10 / 14 | 73 s / 83 s | 5 of 5 / 5 of 5 |
| score-obstacles | `scores-every-obstacle` | 5 | 1 (1) | 0.93 | $0.16 / $0.17 | 9 / 8 | 27 s / 25 s | 5 of 5 / 5 of 5 |
| render-the-assessment-report | `shows-every-decision` | 5 | 1 (1) | 0.5 | $0.1 / $0.17 | 6 / 5 | 14 s / 48 s | 5 of 5 / 5 of 5 |

## Checks that failed with the skills

* find-test-anti-patterns / `counts-every-kind`: `count-no-real-assertion`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `does-not-count-a-spring-junit3-test-as-never-running`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `does-not-list-a-clean-test`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `does-not-list-tests-that-stay-local`, in 2 run(s)
* find-test-anti-patterns / `counts-every-kind`: `examples-are-method-declarations`, in 2 run(s)
* find-test-anti-patterns / `counts-every-kind`: `keyed-by-class-and-name`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-a-jndi-lookup`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-a-never-run-method`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-a-placeholder-default`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-an-inherited-spring-boot-test`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-the-empty-test`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-the-host-in-code`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-the-jpa-test-on-the-real-database`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-the-legacy-xml-host`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-the-spring-boot-host`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `lists-the-spring-xml-host`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `not-counted-assertion-helper`, in 1 run(s)
* find-test-anti-patterns / `counts-every-kind`: `not-counted-expected-exception-idiom`, in 1 run(s)
* choose-techniques / `decides-every-technique`: `defer-batch-file-in-file-out`, in 1 run(s)

## Files in the wrong shape, with the skills

The first problem in each run whose files don't match the toolkit's schemas.

* find-test-anti-patterns / `counts-every-kind`, run 2: /private/tmp/e-zxd0C4/sealed/home/cwd/testing/tests.yaml: can't be read: mapping values are not allowed here  in reader, line 187, column 54:      ... sources/features/refunds.feature: A refund after                                           ^   at [Source: (StringReader); line: 187, column: 54]
* find-test-anti-patterns / `counts-every-kind`, run 4: /private/tmp/e-9h7CAL/sealed/home/cwd/testing/tests.yaml: can't be read: mapping values are not allowed here  in reader, line 195, column 54:      ... sources/features/refunds.feature: A refund after 30 days is refused                                          ^   at [Source: (StringReader); line: 195, column: 54]

## Runs that didn't start or finish

* `counts-every-kind`, with: timed out after 600s

Total cost of this run of the evals: $19.75.
