# Skill evals: without the skills, version 1 and version 2

Each skill's eval case, run with Sonnet: five runs without the toolkit's skills, five with the first version of the
skills (version 1), and five with the skills as changed after the review of version 1 (version 2). A run's score is
the share of its checks passed. Costs are what the runs would cost at API prices. Each case's runs are kept in
[results/](results/); [the results page](eval-results.md) has the latest full table, and
[the baseline report](baseline-report.md) explains version 1's results and the changes made after it.

Each cell gives the mean score, how many runs scored 1, the mean cost per run and the mean turns.

| Skill | Case | Without the skills | Version 1 | Version 2 |
|---|---|---|---|---|
| [choose-techniques](../../.github/skills/choose-techniques/SKILL.md) | `decides-every-technique` | 0.87 (0 of 5), $0.61, 24 turns | 0.99 (4 of 5), $0.52, 14 turns | Not yet run |
| [draft-the-connection-list](../../.github/skills/draft-the-connection-list/SKILL.md) | `drafts-every-connection` | 0.35 (0 of 5), $0.19, 9 turns | 1 (5 of 5), $0.19, 9 turns | Not yet run |
| [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | `counts-every-kind` | 0.54 (0 of 5), $0.12, 6 turns | 0.99 (4 of 5), $0.16, 13 turns | Not yet run |
| [measure-a-repo](../../.github/skills/measure-a-repo/SKILL.md) | `measures-five-runs` | No good runs: every run failed at set-up when the network refused secure connections | 1 (2 of 2 good runs), $0.14, 8 turns; three runs lost to the same network failure | Not yet run |
| [render-the-assessment-report](../../.github/skills/render-the-assessment-report/SKILL.md) | `shows-every-decision` | 0.54 (0 of 5), $0.18, 5 turns | 1 (5 of 5), $0.10, 6 turns | Not yet run |
| [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md) | `finds-every-kind` | 0.22 (0 of 5), $0.14, 5 turns | 1 (5 of 5), $0.15, 7 turns | Not yet run |
| [score-obstacles](../../.github/skills/score-obstacles/SKILL.md) | `scores-every-obstacle` | 0.93 (0 of 5), $0.18, 9 turns | 1 (5 of 5), $0.17, 8 turns | Not yet run |
| [write-the-testing-plan](../../.github/skills/write-the-testing-plan/SKILL.md) | `plans-every-piece-of-work` | 0.35 (0 of 5), $0.32, 15 turns | 1 (5 of 5), $0.32, 9 turns | Not yet run |

## What changes between the columns

* **Without the skills to version 1:** every case scores higher with the skills, and in five of the seven cases with
  five good runs, every run scores 1. Where the run without the skills comes close (choose-techniques, score-obstacles), the skill
  mostly saves turns.
* **Version 1 to version 2:** filled in when the changed skills are run again with
  [`run-baseline.sh`](../../maintainer-tools/skill-evals/run-baseline.sh). A change to a skill is kept only if its
  case still passes in every run.
