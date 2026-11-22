---
status: proposed
decision-makers: Toolkit maintainers
group: How we work
---

# Skill evals run on a clean copy of the whole toolkit, which is the plugin, so skills can read its files

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[The toolkit's skills are evaluated with claude plugin eval, against known answers, five runs with and without them](0045-the-toolkits-skills-are-evaluated-with-claude-plugin-eval-against-known-answers-five-runs-with-and-without-them.md)
made `.github/` the plugin, because a plugin folder of more than 20,000 entries isn't accepted and the repo's build
output exceeds that. A trial run showed that `claude plugin eval` lets its sessions read only the plugin's folder:
the report skill couldn't read its template in `templates/`, and stopped. The same holds for every skill that reads
the toolkit's schemas, templates or technique rules.

## Considered Options

* **Run the eval on a clean copy of the toolkit's tracked and new files, with the plugin manifest at its root**  
  Skills read the toolkit as it is laid out; nothing moves; the copy has a few hundred files
* **Move every file the skills read into `.github/`**  
  Templates, schemas and technique rules leave the folders people look for them in
* **Have each case's set-up script copy what its skill needs into the workspace**  
  The run without the skills then gets the same files, and each case must know what its skill reads

## Decision Outcome

Proposed: the first option, with everything else in the decision it would replace unchanged. The plugin
manifest is [`.claude-plugin/plugin.json`](../../.claude-plugin/plugin.json) at the repo's root, naming
`.github/skills/` and the cases in [`.github/evals/`](../../.github/evals/README.md).
[`run-all.sh`](../../maintainer-tools/skill-evals/run-all.sh) copies the toolkit into a temporary folder, runs the
cases there, and writes the results into the repo.

### Consequences

* Cases are run only through `run-all.sh` (or `run-baseline.sh`), not with `claude plugin eval` in the repo itself.
* The download cache in `.github/evals/results/cache/` is shared between copies.

## More Information

* Builds on: [The toolkit's skills are evaluated with claude plugin eval, against known answers, five runs with and without them](0045-the-toolkits-skills-are-evaluated-with-claude-plugin-eval-against-known-answers-five-runs-with-and-without-them.md)
* Later decisions that build on this: none yet
* Background: none
