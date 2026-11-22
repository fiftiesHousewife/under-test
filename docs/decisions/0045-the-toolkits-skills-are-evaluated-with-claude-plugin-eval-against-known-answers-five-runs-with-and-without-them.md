---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# The toolkit's skills are evaluated with claude plugin eval, against known answers, five runs with and without them

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

A skill is kept only if it saves an AI assistant effort or makes the result the same every time. Each skill was first
tried by hand: one run with it and one without, graded by the skill's author. That shows a skill works and where it
is wrong, but not how much runs vary, and a grader who knows the skill's rules can lean towards it. Claude Code has a
built-in way to evaluate a plugin: `claude plugin eval` runs each case several times with the plugin and several times
without it, each in a fresh session, and scores each run with the case's checks.

## Considered Options

* **`claude plugin eval`, with deterministic checks against known answers**  
  Repeatable; measures variance; the run without the skills comes for free; no code of ours beyond a script that
  runs it and writes a results page. Needs a plugin manifest, and runs only outside an AI assistant's sandbox
* **Keep trying skills by hand**  
  Cheap per trial, but one run each way, graded by the author
* **Our own harness**  
  Full control, but code to build and keep, which the toolkit avoids (see [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md))

## Decision Outcome

Chosen in discussion: the first option, after a pilot on the safety inventory skill. With the skills, one run passed
all 25 checks; without them, it passed 2 and wrote the passwords it found into the file and its reply.

### Consequences

* `.github/` is the plugin: [its manifest](../../.github/.claude-plugin/plugin.json) makes `.github/skills/` one
  plugin, and the cases live in [`.github/evals/`](../../.github/evals/README.md).
* Checks are patterns that must, or must not, appear in the files a run writes or in its reply, from answers worked
  out by hand from the fixture and the skill's rules. No AI judge, so a result can't drift with the judge.
* [`run-all.sh`](../../maintainer-tools/skill-evals/run-all.sh) runs every case five times each way and writes
  [the results page](../skill-evaluations/eval-results.md). It spends tokens on the maintainer's own account, and
  runs in their own terminal.
* A new skill gets a case with it. A change to a skill is kept only if its case still passes in every run.
* The results give each run's cost, turns and time, not tokens or tool calls, so effort is judged by cost and turns.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)
* Later decisions that build on this: none yet
* Background: none
