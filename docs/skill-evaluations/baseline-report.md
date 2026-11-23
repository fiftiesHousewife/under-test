# Skill eval baseline: report and actions

The first full run of every skill's eval case with
[`run-baseline.sh`](../../maintainer-tools/skill-evals/run-baseline.sh), with Sonnet: five runs with the toolkit's
skills and five without, each in a fresh session. Each case's results are kept in
[results/](results/) (scores, cost, turns and time per run, the checks that failed, and the schema check), and the
table of all cases is on [the results page](eval-results.md). Costs are what the runs would cost at API prices.

## Summary

Seven of the eight cases ran. With the skills, 33 of 35 runs scored 1, and the other two each missed one check;
without them, no run scored 1. The eighth, measure-a-repo, can't run inside `claude plugin eval`: its Gradle build
needs local ports, which the eval's sandbox doesn't allow, so it runs with
[`run-outside-eval.sh`](../../maintainer-tools/skill-evals/run-outside-eval.sh) instead (action 14); there, all five runs with the skill score 1, and none of the five without it does. Three cases
failed on their set-up in the first pass; they were fixed, and `check-cases.sh` now tries every set-up before a run.

| Skill | Runs scoring 1, with / without | Mean cost per run, with / without | What the skill adds |
|---|---|---|---|
| choose-techniques | 4 / 0 of 5 | $0.52 / $0.61 | right choices, half the turns |
| draft-the-connection-list | 5 / 0 of 5 | $0.19 / $0.19 | ids the plan and tracker can follow |
| find-test-anti-patterns | 4 / 0 of 5 | $0.16 / $0.12 | ids that make runs comparable |
| measure-a-repo | 5 / 0 of 5 | $0.15 / $0.17 | the starting level right, and the build kept on the machine |
| render-the-assessment-report | 5 / 0 of 5 | $0.10 / $0.18 | the template, at half the cost and a quarter of the time |
| run-the-safety-inventory | 5 / 0 of 5 | $0.15 / $0.14 | stable ids, and no secret repeated |
| score-obstacles | 5 / 0 of 5 | $0.17 / $0.18 | the last few scores right, evidence in one form |
| write-the-testing-plan | 5 / 0 of 5 | $0.32 / $0.32 | keys a tracker can follow |

## Cases

### choose-techniques: `decides-every-technique`

| | With the skill | Without it |
|---|---|---|
| Score per run | 0.97, 1, 1, 1, 1 | 0.77, 0.90, 0.92, 0.87, 0.90 |
| Runs scoring 1 | 4 of 5 | 0 of 5 |
| Mean cost per run | $0.52 | $0.61 |
| Turns per run | 11 to 18 | 17 to 43 |
| Files in the right shape | 5 of 5 | 5 of 5 |

* With the skill, one run adopted mutation testing ("Waits for fix-flaky-tests") instead of deferring it: it read
  the flaky suite as something planned work will fix, a rule the skill gives only for `possible_when` conditions.
  "Flaky suite" is a `reject_or_defer_when` condition that is true now, which defers.
* Without the skill, every run got 3 to 7 of the 30 choices wrong, always among the same nine techniques: in-memory
  databases and property-based testing in every run, then batch file in file out, machine state checks and AI-written
  tests in three runs.
* The skill cut turns by about half and cost by about a sixth, and runs varied far less.

### draft-the-connection-list: `drafts-every-connection`

Run again after its fixture was fixed (the first pass found nothing to read, since git ignored the airgap reports).

| | With the skill | Without it |
|---|---|---|
| Score per run | 1, 1, 1, 1, 1 | 0.31, 0.31, 0.37, 0.40, 0.34 |
| Runs scoring 1 | 5 of 5 | 0 of 5 |
| Mean cost per run | $0.19 | $0.19 |
| Turns per run | 8 to 9 | 5 to 12 |
| Time per run | 36 to 47 s | 41 to 49 s |
| Files in the right shape | 5 of 5 | 4 of 5 |

* With the skill, every run was perfect: every connection with the node and relationship ids the rules give, the
  production database the only never-reach, one stand-in not chosen, and the program and native library left out.
  A run took six tool calls: the skill, two reads of the reports and the assessment file, the two schemas, one script
  writing the connection list, and one edit.
* Without the skill, every run found the same systems but named them its own way (`orders-database` for
  `db-orders.prod.example.com`), so no node, relationship or finding check matched; most recorded the started program
  as if it were a connection, and one wrote an assessment file its schema rejects. The cost was the same; the skill
  buys ids that stay the same from run to run, which the testing plan and the tracker rely on.

### find-test-anti-patterns: `counts-every-kind`

| | With the skill | Without it |
|---|---|---|
| Score per run | 1, 0.94, 1, 1, 1 | 0.56, 0.56, 0.5, 0.5, 0.56 |
| Runs scoring 1 | 4 of 5 | 0 of 5 |
| Mean cost per run | $0.16 | $0.12 |
| Turns per run | 7 to 17 | 6 to 7 |
| Files in the right shape | 5 of 5 | 5 of 5 |

* With the skill, one run cited three examples by their annotation's line rather than the line with the test's name
  (`RefundTest.java:12` for 13, `PricingServiceTest.java:22` for 23, `ReminderJobTest.java:17` for 18). The rule is
  stated, but reading line numbers by eye is where runs slip.
* Without the skill, the counts were mostly right, but each run named its findings in its own words
  (`disabled-tests`, `sleeps-for-background-job`, `checkout-steps-share-state`), so every count check missed them:
  the ids are what make runs comparable, and that is what the skill adds. They also counted the test calling
  `localhost` as reaching a shared system, which the rules leave out.

### measure-a-repo: `measures-five-runs`, still blocked

The first pass failed because the Gradle distribution was outside the workspace. With that fixed, the second pass
failed further on, on the sandbox the eval runs its sessions in. Every run, with and without the skill, scored 0.16 to
0.21 in 8 to 11 turns and about 30 seconds, and rightly wrote no results:

1. `/usr/libexec/java_home` finds no Java inside the session, so the wrapper didn't start until the run set
   `JAVA_HOME` itself.
2. Java takes the home folder from the system's user, not from `$HOME`, so the wrapper tried to unpack Gradle into
   `/Users/<user>/.gradle`, outside the workspace, and couldn't. The run set `GRADLE_USER_HOME` to get past it.
3. Gradle then failed with `java.net.BindException: Operation not permitted`: its daemon and test workers talk over
   local ports, and the session's sandbox doesn't allow binding them. The run said so and stopped.

`check-cases.sh` runs the set-up in the maintainer's own shell, not in the eval's sandbox, so it can't see these. The
eval's documented settings can't allow local ports: no case field or flag changes its sandbox, and a case's `env` takes only `EVAL_*` names, so not `JAVA_HOME` either. So this case has to run outside `claude plugin eval` (action 14).

### render-the-assessment-report: `shows-every-decision`

| | With the skill | Without it |
|---|---|---|
| Score per run | 1, 1, 1, 1, 1 | 0.52, 0.52, 0.56, 0.56, 0.52 |
| Runs scoring 1 | 5 of 5 | 0 of 5 |
| Mean cost per run | $0.10 | $0.18 |
| Turns per run | 5 to 7 | 3 to 7 |
| Time per run | 11 to 16 s | 39 to 58 s |
| Files in the right shape | 5 of 5 | 5 of 5 |

* With the skill, every run was perfect, at about half the cost and a quarter of the time: the fixed command fills
  the template in one step.
* Without the skill, each run wrote its own page, so none had the template's data block, and two of five got the
  "runs on its own" answer wrong.

### run-the-safety-inventory: `finds-every-kind`

| | With the skill | Without it |
|---|---|---|
| Score per run | 1, 1, 1, 1, 1 | 0.24, 0.20, 0.20, 0.24, 0.24 |
| Runs scoring 1 | 5 of 5 | 0 of 5 |
| Mean cost per run | $0.15 | $0.14 |
| Turns per run | 6 to 9 | 4 to 6 |
| Files in the right shape | 5 of 5 | 5 of 5 |

* With the skill, every run was perfect: all 18 findings with the ids the rules give, the keystores in the history
  found, and no secret written anywhere.
* Without the skill, every run made up its own ids, so no id check passed, and one run repeated a found password
  (`Sup3rSecret`) in its reply. The cost is about the same either way: here the skill buys correctness and safety,
  not savings.

### score-obstacles: `scores-every-obstacle`

Run again after its set-up was fixed (in the first pass no run started).

| | With the skill | Without it |
|---|---|---|
| Score per run | 1, 1, 1, 1, 1 | 0.90, 0.90, 0.95, 0.95, 0.95 |
| Runs scoring 1 | 5 of 5 | 0 of 5 |
| Mean cost per run | $0.17 | $0.18 |
| Turns per run | 7 to 10 | 7 to 11 |
| Files in the right shape | 5 of 5 | 5 of 5 |

* With the skill, every run was perfect, in five tool calls: the skill, one read of the guide and both files, one
  read again of the assessment file, two short scripts for the commit and the counts, and one edit.
* Without the skill, runs came close, since the case gives them the decision guide with its table too. Two of five
  scored `tests-reach-shared-systems` 1 instead of 2, and every run wrote the flaky evidence its own way
  (`tests.flaky 7 of tests.count 212` for `tests.flaky 7 of 212`). The skill buys the last few scores and evidence
  in the same form every run.
* The run with the skill read the assessment file twice (once in a `cat` with the guide, once with Read before its
  edit), which the trace breakdown in action 5 is to look at.

### write-the-testing-plan: `plans-every-piece-of-work`

| | With the skill | Without it |
|---|---|---|
| Score per run | 1, 1, 1, 1, 1 | 0.38, 0.34, 0.34, 0.34, 0.34 |
| Runs scoring 1 | 5 of 5 | 0 of 5 |
| Mean cost per run | $0.32 | $0.32 |
| Turns per run | 7 to 11 | 9 to 23 |
| Files in the right shape | 5 of 5 | 5 of 5 |

* With the skill, every run gave the same 15 pieces of work with the same keys, the plan marked as generated, and the
  unreachable level 4 shown.
* Without the skill, no run's keys matched (each keyed and split the work its own way), so a tracker loader couldn't
  follow the work from one run to the next. Cost was the same; the skill buys a plan the tracker can rely on.

## Tuning runs

### choose-techniques, first try of actions 1, 3 and 4

Two runs with the skill: scores 1 and 0.97, 17 and 20 turns, $0.54 and $0.59, no better than the baseline. The
traces show why: both runs read `techniques/rules.json` relative to the workspace rather than the skill's folder,
found nothing, and fell back to the case's copies of the 30 technique files, in four tool calls as before. The skill
now says the toolkit's root is three folders up from its own folder, as the render and plan skills do, and to read no
`technique.yaml` even where the repo has copies. The run scoring 0.97 deferred automatic test generation, calling
'Framework-heavy code (Spring contexts)' unknown on a Spring Boot build because annotation density wasn't measured;
the skill now says the build file's dependencies settle which framework the code uses.

### choose-techniques, second try

| | Baseline, with the skill | Second try |
|---|---|---|
| Runs scoring 1 | 4 of 5 | 2 of 2 |
| Mean cost per run | $0.52 | $0.45 |
| Turns per run | 11 to 18 | 11 and 14 |
| Tool calls per run | 9 to 16 | 9 and 11 |
| Calls reading technique rules | 3 to 5 | 1 |

Each run read `techniques/rules.json` once, from the toolkit, and no technique file. What is left to read is small:
the 1.4 KB guide on the order of workstreams, for the report, and in one run a look at the assessment schema.
Actions 1, 3 and 4 are kept.

### measure-a-repo, outside the eval

Three single runs with `run-outside-eval.sh`, each finding one more thing the runs need:

1. With `--safe-mode`, Gradle started and compiled, but couldn't download its dependencies: Claude Code's sandbox
   sends traffic through a proxy that Java ignores. `--safe-mode` also left out the toolkit's skills. The script now
   uses `--setting-sources project`, and gives Gradle the proxy in each run's own Gradle home.
2. With the skill loaded, Gradle failed at start-up: `Could not create service of type
   BuildLifecycleAwareVirtualFileSystem ... Operation not permitted`. The skill stopped rightly, without writing.
3. Turning off Gradle's native file system didn't help.

So the case's runs now run their commands without Claude Code's sandbox (`sandbox: off` in its
`runs-outside-eval.txt`), as the maintainers chose: each run is still a fresh workspace with only the case's tools,
and its tests run under the airgap agent.

The next single run, with the skill, scored 1 in 9 turns, 114 seconds and $0.15, with its file in the right shape: 6 tests, the flaky and the failing one named, 64.7% of lines and 62.5% of branches covered, 5 of 14 planted bugs caught with both left out, level 0. The full case, five runs each way, runs with the next `run-baseline.sh`.

## Where the cost goes

From the kept traces of runs with the skills (tool calls and token counts per run):

* **Each turn re-reads the whole conversation.** A choose-techniques run read about 600,000 cached input tokens and
  wrote about 90,000 new ones into the cache, with only a few hundred output tokens. Cost rises with the number of
  turns times the size of what has been read, so the levers are fewer turns and less to read.
* **choose-techniques reads its 30 technique rules in three to five tool calls.** Together they are 33 KB, more than
  one tool result shows, so runs dumped them, were cut off, and read them again in batches; one spilled to a file and
  read that back. That is 3 to 5 of its 9 to 16 tool calls.
* **Runs read files they didn't need:** the techniques README (5 KB) and both decision guides, though the target level
  was decided in the assessment file.

## Actions

| # | Skill | Action | Why | State |
|---|---|---|---|---|
| 1 | choose-techniques | Say that planned work counts only for `possible_when`: a true `reject_or_defer_when` that planned work will change still defers | One run in five adopted mutation testing on a flaky suite | Done in the skill; kept: 2 of 2 scored 1 at $0.45, one read of the rules |
| 2 | draft-the-connection-list | Run its case again with `run-baseline.sh` after the baseline finishes, and commit the fixture's airgap reports with the next push | The reports were ignored by git and missing from every run | Rerun: 5 of 5 scored 1; the reports are to commit with the next push |
| 3 | choose-techniques | Read the technique rules from one compact file made from them: a generated `techniques/rules.json` with only the fields the skill uses (id, name, workstream, the three condition lists, precondition checks, fallback, stand-in approach, evidence levels, application types), rebuilt and checked by the repo checks like the decision indexes | The rules are 33 KB in 30 files and took 3 to 5 tool calls; one file under the result limit takes one | Done: `techniques/rules.json`, 18 KB, rebuilt by `buildDecisionIndexes`; kept: 2 of 2 scored 1 at $0.45, one read of the rules |
| 4 | choose-techniques | Say which files not to read: the techniques README, and decision guide 0015 when `level/target` is decided | Runs read 8 KB they didn't need, carried through every later turn | Done in the skill; kept: 2 of 2 scored 1 at $0.45, one read of the rules |
| 5 | every skill | After the baseline, break down one trace per case the same way, and add an action for each file read more than once or not needed | The same pattern is likely in the plan and report skills, which also read the technique rules or a large template | To do |
| 6 | evals | Before a baseline, check every fixture file is seen by git (`git ls-files -co --exclude-standard`), since the eval runs on a copy of those files only | Any ignored fixture file is silently missing | Done: `check-cases.sh` fails on any ignored file under the cases |
| 7 | evals | After the baseline, write a maintainer skill that reviews eval results: a script for the counts (tool calls by type, tokens, files read twice or not needed, how often each check fails) and the skill for reading a failing run's files to find why, writing each finding into this report as an action. Give it an eval case built from these kept results | The review of each case is done by hand today, the same way every time | To do |
| 8 | evals | Add `keep-summary.sh` and `keep-traces.sh` to `run-baseline.sh` after each case | They are run by hand during this baseline, because a running script can't safely be changed | Done: `run-baseline.sh` keeps both after each case |
| 9 | find-test-anti-patterns | Find each example's line with `grep -n` on the method's name (for example `grep -n "void cancelsOrder("`), not by reading | One run in five cited annotation lines | To do |
| 10 | measure-a-repo | Run its case again with `run-baseline.sh` after this pass | Its runs couldn't read the Gradle distribution outside the workspace | Rerun: still blocked, by the eval's sandbox (action 14) |
| 11 | evals | Note in the evals README that a case's set-up must put every file its runs read inside the workspace: the eval's sessions can't read the repo, the cache or the home folder | Two of the first four cases were broken by files outside the workspace | Done: "Writing a case's set-up" in the evals README |
| 12 | score-obstacles | Run its case again with `run-baseline.sh` after this pass | Its set-up named another case's fixture by a path that only exists in the repo | Rerun: 5 of 5 scored 1 |
| 13 | evals | Before a baseline, try every case's set-up script from a copy laid out as `run-all.sh` makes it (cases in `evals/`), so a path that only works in the repo shows up without spending usage | Three of eight cases failed on set-up the first time | Done: `check-cases.sh` runs each set-up from the copy; `run-baseline.sh` runs it first |
| 14 | measure-a-repo | Run this case outside `claude plugin eval`: a script that sets up the workspace with its `scaffold.sh`, runs the skill with `claude -p` five times with it and five without in a sandbox that allows local ports, and grades the files with the case's own checks. The eval's documented settings can't allow local ports (a case's `env` takes only `EVAL_*` names, and no case field or flag changes its sandbox); set-up should also write `distributionBase=PROJECT` so Gradle unpacks inside the workspace | Gradle can't start in the eval's sandbox, so the case measures nothing | Script built and its grading checked against the eval's on 60 kept runs; to run: `maintainer-tools/skill-evals/run-outside-eval.sh measures-five-runs` |
| 15 | evals | Make `check-cases.sh` also try one command of each case that runs a build, in a sandbox like the eval's | Its set-up check passed this case, but the eval's sandbox still stopped the build | To do |
