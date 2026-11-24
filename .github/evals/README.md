# Skill evaluations

Repeatable tests of the toolkit's AI assistant skills, run with `claude plugin eval`. Each case runs several times
with the toolkit's skills and several times without them, in fresh sessions. Its graders check the files the run
wrote against known answers, so the result says how often a skill gets it right and how much runs vary, not just
whether one run worked.

| Folder | What it holds |
|---|---|
| `<skill>/<case>/prompt.md` | The task, and how many runs, turns and tools the case gets |
| `<skill>/<case>/case.yaml` | The script that sets up the case's workspace |
| `<skill>/<case>/scaffold.sh`, `fixture/` | That script, and the files it copies in |
| `<skill>/<case>/graders/` | One check per file: a pattern that must or must not appear, or criteria for an AI judge |

The plugin is the whole toolkit: [its manifest](../../.claude-plugin/plugin.json) names the skills in
`.github/skills/` and the cases here. The eval lets its sessions read only the plugin's folder, so the scripts below
run it on a clean copy of the toolkit, without build output. The write-ups of each skill's trials are in
[docs/skill-evaluations/](../../docs/skill-evaluations/).

## Running them

The baseline, every case one at a time with Sonnet, carrying on where it stopped if a usage limit interrupts it:

```bash
maintainer-tools/skill-evals/run-baseline.sh
```

Or every case in one go, five runs each way, and the results page
[docs/skill-evaluations/eval-results.md](../../docs/skill-evaluations/eval-results.md), from the repo root:

```bash
maintainer-tools/skill-evals/run-all.sh             # every case, with Sonnet; MAX_COST_USD=60 by default
maintainer-tools/skill-evals/run-all.sh 'choose-*'  # only cases whose name matches
RUNS=2 WITHOUT=no maintainer-tools/skill-evals/run-all.sh finds-every-kind  # a short tuning run
```

A short tuning run tries a change to one skill: two runs, with the skills only, compared with the case's last full
results. A change is kept only if every run still scores 1 and its files are in the right shape. Each run's files
in `testing/` are checked against the toolkit's schemas, as well as by the case's own checks.

Run it in your own terminal, not inside an AI assistant's sandbox: the eval starts its own sessions, which can't
start inside another sandbox. It spends tokens on your own account. The scripts pass `--scaffold`, so each case's
set-up script runs; they are all in this folder, written by the toolkit's maintainers. One case, once, with the skills only, as a cheap first try:

```bash
RUNS=1 WITHOUT=no maintainer-tools/skill-evals/run-all.sh shows-every-decision
```

On a Claude subscription the runs come out of the plan's usage, not money; the costs reported are what they would cost at API prices, which is still the measure to tune against. Runs use Sonnet unless `MODEL=<model>` names another (`MODEL=default` for Claude Code's own default); compare results only between runs with the same model.

Full results go to `.github/evals/results/`, which isn't committed.

## Writing a case's set-up

The eval's sessions can read only their own workspace: not this repo, the download cache or the home folder. So a
case's set-up script copies or hard-links into the workspace every file its runs read, writes no path outside it into
those files, and makes no symbolic links. It finds the toolkit by walking up to `AGENTS.md`, since the cases are in
`evals/` in the copy the eval runs on, and names other cases' files relative to its own folder. Fixture files must be
seen by git, or they are missing from that copy.

A case whose runs need what the eval's sandbox can't give, such as binding local ports for a Gradle build, runs
with `run-outside-eval.sh` instead. It does what the eval does with the case's own files (the toolkit copy, the
set-up, the prompt with and without the skills, in fresh sessions without your own settings or plugins, the same checks and the schema check),
and writes the eval's results format. Today that is `measures-five-runs`:

```bash
maintainer-tools/skill-evals/run-outside-eval.sh measures-five-runs
```

Check every case before spending usage on them (`run-baseline.sh` does this first):

```bash
maintainer-tools/skill-evals/check-cases.sh             # every case; 'choose-*' for some
```

## Cases

| Skill | Case | What it checks |
|---|---|---|
| run-the-safety-inventory | `finds-every-kind` | The sample repo plus a history in which a binary keystore and a key file were added and deleted. All 18 findings, each with the id the skill's rule gives; no secret value written anywhere; the keystores in the history found and blocking |
| draft-the-external-systems-list | `drafts-every-connection` | Two airgap agent reports reaching six systems, a program, a native library and the machine itself, and an assessment file with a safety section and a decision. Every connection with the node and relationship ids the skill's rules give; the production database marked never-reach; a stand-in proposed for each, in the guide's order; no program, native library or local call recorded as a connection; the `running_offline` section written and the earlier sections kept |
| find-test-anti-patterns | `counts-every-kind` | The sample of 22 JUnit 4 tests from the skill's first trial. Each of the seven kinds with the right count and the id the rule gives; the test expecting an exception and the test calling `localhost` not counted; every example a method's declaration line; the schema line kept and the tests unchanged |
| measure-a-repo | `measures-five-runs` | The measurement sample repo (Java 8 source, JUnit 4) on a Gradle 6.9.4 wrapper and JDK 11, under the airgap agent. Six tests, one flaky, one failing every run, one disabled; 64.7% line and 62.5% branch coverage; 14 bugs planted and 5 caught, with the flaky and failing tests left out; level 0; the build file and tests unchanged. Needs a JDK 11, and fetches the airgap agent from Maven Central (see its `scaffold.sh`) |
| score-obstacles | `scores-every-obstacle` | The example order service's assessment file and external systems list. Each of the 14 obstacles with the score the guide's table gives, and the one whose fact isn't measured left unscored; evidence with counts and totals; scores as bare numbers; the other sections kept |
| choose-techniques | `decides-every-technique` | The example order service: Spring Boot 2.3 on JDK 8, Oracle, high criticality, a decided target of level 4, flaky and weak tests, container tests in CI only, and developers' machines that can't run containers (stated in the prompt). A proposed decision and a candidate for each of the 30 techniques; the choice the rules settle for every one of them; every other section and the decisions people made kept |
| write-the-testing-plan | `plans-every-piece-of-work` | The example order service after its techniques were chosen. The 15 pieces of work with the keys the skill's rules give, and no others; six workstreams in the guide's order, with check in production left out; marked as generated, with the template's note removed; level 4 shown as reached by no adopted technique; the open question listed; 14 techniques not in the plan, each with its state; the assessment file unchanged |
| render-the-assessment-report | `shows-every-decision` | The example assessment file, external systems list and source list, with a question quoting `</script>` and notes holding HTML markup. The page is the template, unchanged but for its data block; the block holds all three files with every `</` escaped; nothing loaded from the network; the three files untouched; the reply's three answers (not safe to run: the payments keystore; doesn't run on its own: the payments connection has no stand-in; tests not trusted: 23 of 100 planted bugs caught) |
