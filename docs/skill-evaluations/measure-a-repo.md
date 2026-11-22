# Evaluation: measure-a-repo

Does the [measure-a-repo](../../.github/skills/measure-a-repo/SKILL.md) skill, with
[its init script](../../tools/measurement/measure.init.gradle), save an AI assistant effort and give the same result
each time? It was tried against the same task done without it.

## How it was tried

The [sample repo](../../tools/measurement/sample-repo/) is an invented old-style build: Java 8 source and JUnit 4. It
has a flaky test that leaves a file behind, a disabled test, a test with no assertion, and a test that tries to send
mail. It was built with Gradle 6.9.4 on JDK 11, and every run went under the airgap agent. Its assessment file already
had a decided safety section. One agent followed the skill; the other was given the same task, the schema and the
level guide, and was told not to change the repo's build. Each result was compared with known answers:

| Field | Known answer |
|---|---|
| count, disabled, flaky, failing | 6, 1, 1 (the marker test), 1 (the mail test, refused by the agent) |
| line, branch coverage | 64.7, 62.5 |
| planted bugs | 14 planted, 5 caught, with the flaky and failing tests left out |
| level | 0: it builds; level 1 needs a CI runner with no route out |

The init script was also run on the same repo with Gradle 9 on JDK 21.

## Results

| Run | Tool calls | Tokens | Time | Result |
|---|---|---|---|---|
| Without the skill | 18 | 69,000 | 444 s | Right counts, coverage and planted bugs. It wrote its own init script, choosing JaCoCo 0.8.8 and a PIT Gradle plugin version that suits this Gradle version only. It made up its own tool name, counted the mail test as a broad test by reading its code (mix 83.3 / 0 / 16.7), and wrote its own schema checker |
| With the skill | 12 | 60,300 | 237 s | Right counts and coverage. Planted bugs wrong (6 caught of 20): the script planted bugs in the test classes too, because they share the code's package. Fixed in the script, which now gives 14 and 5 |

## What it shows

* **The script is most of the value:** with it, a run takes a third fewer tool calls and half the time, and the same
  commands work on Gradle 6.9 and 9. Without it, each assistant builds its own set-up, with whatever tool versions it
  picks, and only for the Gradle version in front of it.
* **The rules make results comparable between repos:** the tool name, the way the test mix is counted and the level
  rule are fixed. Without them, the mix depended on the assistant's reading of the code.
* **On a repo this small, the assistant without the skill was as accurate,** once the script's fault is set aside.
  The trial doesn't show the skill is more accurate, only that it is cheaper and gives the same shape of result.
* The trial found four faults, all fixed:
  * Test classes were mutated as well as the code.
  * PIT's run errors were counted as caught.
  * A flaky test made the planted-bug count change from run to run (7 one time, 5 the next) until flaky and failing
    tests were left out by name.
  * An unquoted commit such as `0000000` was read as a number. Every skill now quotes it.

## Limits

This is one run each way, on one small invented repo, graded by the skill's author. It shows the skill works and
where it was wrong; it doesn't measure how much results vary between runs, or how the skill does on a large or
multi-project build. A Maven build isn't covered yet.
