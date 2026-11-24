# Skill evals round by round: without the skills and with them

These runs come from before the skills' renames (find-test-anti-patterns, now find-meaningless-and-unreliable-tests;
draft-the-connection-list, now draft-the-external-systems-list), so they use the earlier names and words.

Each skill's eval case, run with Sonnet in rounds. In each round a case runs five times without the toolkit's skills and
five times with them. A run's score is the share of its checks passed. Costs are what the runs would cost at API
prices. Rounds 1 and 2 keep their results in [results/round-1/](results/round-1/) and [results/round-2/](results/round-2/), and
the latest round's are in `results/` itself; later rounds are summarised here only. [The results page](eval-results.md) has the latest round in full, and
[the baseline report](baseline-report.md) explains round 1. [What the skills produce](what-the-skills-produce.md)
shows the files they write for each case's example repo.

Each cell gives the mean score, how many runs scored 1, the mean cost per run and the mean turns.

| Skill | Case | Without, round 1 | Without, round 2 | With, round 1 | With, round 2 |
|---|---|---|---|---|---|
| [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md) | `finds-every-kind` | 0.22 (0 of 5), $0.14, 5 turns | 0.22 (0 of 5), $0.14, 5 turns | 1 (5 of 5), $0.15, 7 turns | 1 (5 of 5), $0.16, 6 turns |
| [draft-the-connection-list](../../.github/skills/draft-the-external-systems-list/SKILL.md) | `drafts-every-connection` | 0.35 (0 of 5), $0.19, 9 turns | 0.36 (0 of 5), $0.20, 12 turns | 1 (5 of 5), $0.19, 9 turns | 1 (5 of 5), $0.20, 9 turns |
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.54 (0 of 5), $0.12, 6 turns | 0.51 (0 of 5), $0.13, 11 turns | 0.99 (4 of 5), $0.16, 13 turns | 0.98 (3 of 5), $0.16, 15 turns |
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
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.50 (0 of 5), $0.12, 8 turns | 0.99 (4 of 5), $0.16, 13 turns | 0.98 (3 of 5), $0.16, 15 turns | 0.99 (4 of 5), $0.16, 10 turns |
| [score-obstacles](../../.github/skills/score-obstacles/SKILL.md) | `scores-every-obstacle` | 0.93 (0 of 5), $0.17, 8 turns | 1 (5 of 5), $0.17, 8 turns | 0.99 (4 of 5), $0.16, 9 turns | 1 (5 of 5), $0.16, 9 turns |

* **score-obstacles:** every run scores line coverage the right way round again.
* **find-test-anti-patterns:** no run gives the line where a problem shows any more, and the runs take a third fewer
  turns. One run gave a test's `@Test` line instead of the line with its name; the skill now says that too.

## Round 4: find-test-anti-patterns again

| Skill | Case | Without, round 4 | With, round 4 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.54 (0 of 5), $0.12, 6 turns | 0.98 (3 of 5), $0.15, 11 turns |

Saying which line in more words doesn't settle it: two runs again gave the line where the problem shows (the first
line of a copy-pasted block, and a call that depends on an earlier test). Over four rounds the skill misses this in
one or two runs of every five, and nothing else.

## Round 5: find-test-anti-patterns, with each test's line taken from a search

| Skill | Case | Without, round 5 | With, round 5 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.51 (0 of 5), $0.12, 7 turns | 0.99 (4 of 5), $0.16, 7 turns |

Taking each test's line from `grep -n` halves the turns (7, against 15 in round 2) at the same cost. One run still gave
the line of a call that depends on an earlier test. The rule stays as it is: the miss is one check in one run of five.

## Round 6: find-test-anti-patterns searches instead of reading every file

A user couldn't run the skill on 35,000 lines of tests, so it now finds tests and anti-patterns by search and reads
only what the searches find. It also counts Cucumber scenarios, follows the Spring XML a test loads, and never takes
an XML namespace for a host; the example repo gained a case of each.

| Skill | Case | Without, round 6 | With, round 6 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.52 (0 of 5), $0.14, 12 turns | 0.99 (4 of 5), $0.20, 12 turns |

With the skill, every run found the host behind Spring XML, left the namespace-only XML alone and counted the ignored
scenario; without it, no run found the Spring XML host. The extra searches, on a larger example repo, cost $0.04 and
five turns more a run. The one miss is the same as before: one example's line.

## Round 7: tests that never run, empty bodies, and whole copied classes

| Skill | Case | Without, round 7 | With, round 7 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.50 (0 of 5), $0.14, 9 turns | 0.97 (3 of 5), $0.22, 9 turns |

With the skill, every run found the empty test and the class copied between folders, and four of five counted the
tests that never run exactly. The fifth took Maven's rule (`*IT` classes run only with Failsafe) for a Gradle build, so
it counted OrderRepositoryIT as never running and left it out of the external-system count; the skill now says that rule
is Maven's only. One run without the skill timed out while the network was down.

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

## Round 8: the list of tests, swallowed failures and tests JUnit 5 skips

| Skill | Case | Without, round 8 | With, round 8 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.40 (0 of 5), $0.17, 7 turns | 0.99 (4 of 5), $0.31, 11 turns |

With the skill, every run wrote `testing/tests.yaml` keyed by class and method, found both tests that swallow their
own failures and left the try, fail, catch idiom alone, and found the JUnit 5 tests that silently never run. The one
miss is one example's line again. The larger example repo and the extra checks cost $0.09 a run more than round 7.

## Round 9: tests reaching external systems through Spring Boot and old Spring XML, and assertion helpers

| Skill | Case | Without, round 9 | With, round 9 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.29 (0 of 5), $0.22, 9 turns | 0.89 (2 of 5), $0.35, 11 turns |

Every run that wrote the list of tests found all six tests reaching external systems through Spring Boot's settings or
old Spring XML, left the four local ones alone, and didn't take Spring's JUnit 3 tests for tests that never run. The
misses were elsewhere: one run wrote only the summary, two wrote a scenario's name, which holds a colon, without
quotes, and one ran past the case's time limit, set when the example repo was half the size. One check was wrong, not
the run: a test whose profile points at a server on `localhost` that nothing starts is rightly listed as
`other-server-nothing-starts`. The skill now says to write both files, every time, and to quote every test's name.

## Round 10: writing both files, quoting names

| Skill | Case | Without, round 10 | With, round 10 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.30 (0 of 5), $0.22 | 0.88 (1 of 5), $0.43, 13 turns |

No run wrote invalid YAML or ran out of time, and the Spring cases held. One run again wrote only the summary, so the
list of tests is now written first and the summary worked out from it. One run took MockMvc's `andExpect` for no
assertion, which PMD's rules recognise. One check was wrong again: a test whose profile points mail at a server on
`localhost` that nothing starts is rightly listed as `other-server-nothing-starts`.

## Round 11: find-test-anti-patterns on PMD

| Skill | Case | Without, round 11 | With, round 11 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.29 (0 of 5), $0.23, 9 turns | 0.97 (2 of 5), $0.44, 15 turns |

Every run found PMD in the workspace and ran it, and every run wrote both files: the mean rose from 0.88 to 0.97. The
cost didn't fall, and runs took longer (190 s against 115 s): the transcripts show the money going on long listings and
whole test files read into the run, not on finding things. The misses were labels and lines: a host in a properties
file that Spring XML loads recorded as reached through `properties`, and `at` lines taken from annotations. The skill
now lists one line per test, reads only each hit's method, and says that `through` is the route and `at` the method's
line.

## Round 12: PMD, reading less

| Skill | Case | Without, round 12 | With, round 12 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.30 (0 of 5), $0.23, 16 turns | 0.99 (4 of 5), $0.42, 14 turns |

Four runs of five scored 1, the best round so far; the one miss was an example's line. One line per test, and giving
the ruleset's path, brought runs back to 120 seconds from 190. The cost barely moved: runs still printed whole test
files to check a few hits, so the skill now forbids it and says how to read only each hit's method. (A first attempt
at this round lost four runs to a dropped connection and was run again.)

## Round 13: never printing whole test files

| Skill | Case | Without, round 13 | With, round 13 |
|---|---|---|---|
| [find-test-anti-patterns](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | `counts-every-kind` | 0.30 (0 of 5) | 0.99 (4 of 5), $0.42, 16 turns |

Four runs in five printed no whole test file. The cost held at $0.42: on an example repo this small it comes from
the skill's own text and PMD's report, not from reading files; reading less matters on real modules. The same day,
the toolkit's PMD rules were run read-only over one module of Openfire 4.6.0 (426 tests, about a second): three rules
misread real code (a helper method named `test...` that a test calls, `assertNull` as the check, and a `catch
(Throwable)` that records the exception), and were fixed, with a case of each added to the example repo.

