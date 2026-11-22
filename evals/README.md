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

The [plugin manifest](../.claude-plugin/plugin.json) exists so the skills in `.github/skills/` can be tested as one
plugin. The write-ups of each skill's trials are in [docs/skill-evaluations/](../docs/skill-evaluations/).

## Running them

From the repo root, outside any sandbox (the eval starts its own sessions, which can't start inside another
sandbox):

```bash
claude plugin eval . --scaffold --allow-tools Bash Write Edit --no-publish --json evals/results/latest.json
```

* `--case finds-every-kind` runs one case; `--runs 1` is a cheap first try.
* `--scaffold` lets each case's set-up script run. The scripts are in this folder, written by the toolkit's
  maintainers.
* A run spends tokens on your own account: five runs each way of one case cost a few dollars. `--max-cost-usd`
  sets a ceiling.

Results go to `evals/results/`, which isn't committed.

## Cases

| Skill | Case | What it checks |
|---|---|---|
| run-the-safety-inventory | `finds-every-kind` | The sample repo plus a history in which a binary keystore and a key file were added and deleted. All 18 findings, each with the id the skill's rule gives; no secret value written anywhere; the keystores in the history found and blocking |
