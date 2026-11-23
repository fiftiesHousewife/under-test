# Skill evals round by round: without the skills and with them

Each skill's eval case, run with Sonnet in rounds. In each round a case runs five times without the toolkit's skills and
five times with them. A run's score is the share of its checks passed. Costs are what the runs would cost at API
prices. Each round's results are kept in [results/](results/): round 1 in [results/round-1/](results/round-1/), the
latest round in `results/` itself. [The results page](eval-results.md) has the latest round in full, and
[the baseline report](baseline-report.md) explains round 1. [What the skills produce](what-the-skills-produce.md)
shows the files they write for each case's example repo.

Each cell gives the mean score, how many runs scored 1, the mean cost per run and the mean turns.

| Skill | Case | Without, round 1 | Without, round 2 | With, round 1 | With, round 2 |
|---|---|---|---|---|---|
| [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md) | `finds-every-kind` | 0.22 (0 of 5), $0.14, 5 turns | 0.22 (0 of 5), $0.14, 5 turns | 1 (5 of 5), $0.15, 7 turns | 1 (5 of 5), $0.16, 6 turns |
| [draft-the-connection-list](../../.github/skills/draft-the-connection-list/SKILL.md) | `drafts-every-connection` | 0.35 (0 of 5), $0.19, 9 turns | 0.36 (0 of 5), $0.20, 12 turns | 1 (5 of 5), $0.19, 9 turns | 1 (5 of 5), $0.20, 9 turns |
| [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | `counts-every-kind` | 0.54 (0 of 5), $0.12, 6 turns | 0.51 (0 of 5), $0.13, 11 turns | 0.99 (4 of 5), $0.16, 13 turns | 0.98 (3 of 5), $0.16, 15 turns |
| [measure-a-repo](../../.github/skills/measure-a-repo/SKILL.md) | `measures-five-runs` | 0.90 (0 of 5), $0.17, 9 turns | 0.86 (0 of 5), $0.16, 9 turns | 1 (5 of 5), $0.15, 9 turns | 1 (5 of 5), $0.14, 9 turns |
| [score-obstacles](../../.github/skills/score-obstacles/SKILL.md) | `scores-every-obstacle` | 0.93 (0 of 5), $0.18, 9 turns | 0.94 (0 of 5), $0.18, 9 turns | 1 (5 of 5), $0.17, 8 turns | 0.99 (4 of 5), $0.16, 9 turns |
| [choose-techniques](../../.github/skills/choose-techniques/SKILL.md) | `decides-every-technique` | 0.87 (0 of 5), $0.61, 24 turns | 0.88 (0 of 5), $0.63, 20 turns | 0.99 (4 of 5), $0.52, 14 turns | 0.99 (4 of 5), $0.49, 12 turns |
| [write-the-testing-plan](../../.github/skills/write-the-testing-plan/SKILL.md) | `plans-every-piece-of-work` | 0.35 (0 of 5), $0.32, 15 turns | 0.34 (0 of 5), $0.32, 14 turns | 1 (5 of 5), $0.32, 9 turns | 1 (5 of 5), $0.31, 10 turns |
| [render-the-assessment-report](../../.github/skills/render-the-assessment-report/SKILL.md) | `shows-every-decision` | 0.54 (0 of 5), $0.18, 5 turns | 0.50 (0 of 5), $0.17, 5 turns | 1 (5 of 5), $0.10, 6 turns | 1 (5 of 5), $0.10, 6 turns |

Between the rounds only choose-techniques changed; every other skill ran the same instructions twice, so the
difference between its rounds is how much the results vary by chance.

## Round 3: the two skills changed after round 2

Only find-test-anti-patterns and score-obstacles changed, so only their cases ran again; round 2's results are kept
in [results/round-2/](results/round-2/).

| Skill | Case | Without, round 3 | With, round 1 | With, round 2 | With, round 3 |
|---|---|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | `counts-every-kind` | 0.50 (0 of 5), $0.12, 8 turns | 0.99 (4 of 5), $0.16, 13 turns | 0.98 (3 of 5), $0.16, 15 turns | 0.99 (4 of 5), $0.16, 10 turns |
| [score-obstacles](../../.github/skills/score-obstacles/SKILL.md) | `scores-every-obstacle` | 0.93 (0 of 5), $0.17, 8 turns | 1 (5 of 5), $0.17, 8 turns | 0.99 (4 of 5), $0.16, 9 turns | 1 (5 of 5), $0.16, 9 turns |

* **score-obstacles:** every run scores line coverage the right way round again.
* **find-test-anti-patterns:** no run gives the line where a problem shows any more, and the runs take a third fewer
  turns. One run gave a test's `@Test` line instead of the line with its name; the skill now says that too.

## Round 4: find-test-anti-patterns again

| Skill | Case | Without, round 4 | With, round 4 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | `counts-every-kind` | 0.54 (0 of 5), $0.12, 6 turns | 0.98 (3 of 5), $0.15, 11 turns |

Saying which line in more words doesn't settle it: two runs again gave the line where the problem shows (the first
line of a copy-pasted block, and a call that depends on an earlier test). Over four rounds the skill misses this in
one or two runs of every five, and nothing else.

## Round 5: find-test-anti-patterns, with each test's line taken from a search

| Skill | Case | Without, round 5 | With, round 5 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | `counts-every-kind` | 0.51 (0 of 5), $0.12, 7 turns | 0.99 (4 of 5), $0.16, 7 turns |

Taking each test's line from `grep -n` halves the turns (7, against 15 in round 2) at the same cost. One run still gave
the line of a call that depends on an earlier test. The rule stays as it is: the miss is one check in one run of five.

## What the rounds show

* **With the skills, the results hold.** In both rounds every case scores 0.98 or more, and 74 of the 80 runs with the
  skills score 1. Without them no run, in either round, scores 1.
* **The same mistakes repeat without the skills.** Without run-the-safety-inventory, one run in each round repeats a
  password, in the reply or in the assessment file. Without measure-a-repo, every run gets the starting level wrong,
  and half measure with a build that reaches outside the machine. Without render-the-assessment-report, every run
  builds its own page instead of filling the template.
* **Two misses with the skills repeat, and are fixed for the next round.** find-test-anti-patterns gave the line
  where a problem shows instead of the test's own line in 3 of its 10 runs, and score-obstacles once scored line
  coverage the wrong way round; both skills now say how.
* **choose-techniques' change between the rounds** keeps its accuracy (4 of 5 runs score 1, each round missing one
  deferral in one run, a different one each time) with a few turns fewer.
* **Chance moves the results a little.** The same instructions vary by up to 0.04 in mean score and a few turns
  between rounds, so a smaller change after an edit to a skill isn't evidence either way.
