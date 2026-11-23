# Skill evals: without the skills, version 1 and version 2

Each skill's eval case, run with Sonnet: five runs without the toolkit's skills, five with the first version of the
skills (version 1), and five with the skills as changed after the review of version 1 (version 2). A run's score is
the share of its checks passed. Costs are what the runs would cost at API prices. Each case's runs are kept in
[results/](results/); [the results page](eval-results.md) has the latest full table, and
[the baseline report](baseline-report.md) explains version 1's results and the changes made after it.

Each cell gives the mean score, how many runs scored 1, the mean cost per run and the mean turns.

| Skill | Case | Without the skills | Version 1 | Version 2 |
|---|---|---|---|---|
| [choose-techniques](../../.github/skills/choose-techniques/SKILL.md) | `decides-every-technique` | 0.87 (0 of 5), $0.61, 24 turns | 0.99 (4 of 5), $0.52, 14 turns | 0.99 (4 of 5), $0.49, 12 turns |
| [draft-the-connection-list](../../.github/skills/draft-the-connection-list/SKILL.md) | `drafts-every-connection` | 0.35 (0 of 5), $0.19, 9 turns | 1 (5 of 5), $0.19, 9 turns | Unchanged since version 1, so not run again |
| [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | `counts-every-kind` | 0.54 (0 of 5), $0.12, 6 turns | 0.99 (4 of 5), $0.16, 13 turns | Unchanged since version 1, so not run again |
| [measure-a-repo](../../.github/skills/measure-a-repo/SKILL.md) | `measures-five-runs` | 0.91 (0 of 5), $0.17, 9 turns | 1 (5 of 5), $0.15, 9 turns | Unchanged since version 1, so not run again |
| [render-the-assessment-report](../../.github/skills/render-the-assessment-report/SKILL.md) | `shows-every-decision` | 0.54 (0 of 5), $0.18, 5 turns | 1 (5 of 5), $0.10, 6 turns | Unchanged since version 1, so not run again |
| [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md) | `finds-every-kind` | 0.22 (0 of 5), $0.14, 5 turns | 1 (5 of 5), $0.15, 7 turns | Unchanged since version 1, so not run again |
| [score-obstacles](../../.github/skills/score-obstacles/SKILL.md) | `scores-every-obstacle` | 0.93 (0 of 5), $0.18, 9 turns | 1 (5 of 5), $0.17, 8 turns | Unchanged since version 1, so not run again |
| [write-the-testing-plan](../../.github/skills/write-the-testing-plan/SKILL.md) | `plans-every-piece-of-work` | 0.35 (0 of 5), $0.32, 15 turns | 1 (5 of 5), $0.32, 9 turns | Unchanged since version 1, so not run again |

## What changes between the columns

* **Without the skills to version 1:** every case scores higher with the skills, and in six of the eight cases
  every run scores 1. Where the runs without the skills come close (choose-techniques, measure-a-repo,
  score-obstacles), the skill makes the result the same every time or saves turns. Without measure-a-repo, every
  run misses the starting level, and some run a build that reaches outside the machine or leave the refused address
  out of the reply.
* **Version 1 to version 2:** only choose-techniques changed. Its accuracy is the same (4 of 5 runs score 1, each
  version missing one deferral in one run, a different one each time), with about a tenth fewer turns and slightly
  lower cost. Five runs each is too few to call that difference more than a small one.

A change to a skill is kept only if its case still passes in every run. The other skills are run again, as a new
version, when they change.
