# Evaluation: run-the-safety-inventory

These runs come from before the skills' renames (find-test-anti-patterns, now find-meaningless-and-unreliable-tests;
draft-the-connection-list, now draft-the-external-systems-list), so they use the earlier names and words.

Does the [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md) skill save an AI
assistant effort and give the same result each time? It was tried against the same task done without it.

## How it was tried

The repo was the safety inventory's [sample repo](../../tools/safety-inventory/sample-repo), with two reports in
gitleaks' JSON format made from the toolkit's rules: a secrets report with an AWS key, a private key and a keystore in
the history, and the inventory report over the current files. Each agent got the same task, the same reports and the
toolkit; agents without the skill were told not to read the skills. Two scenarios:

* **First run:** no assessment file yet.
* **Re-run:** an assessment file from an earlier run, with people's decisions in it; since then one finding's file has
  been deleted.

Each result was compared with the findings the skill's rules give, checked against the assessment file's schema, and
searched for secret values.

## Results

| Run | Tool calls | Tokens | Time | Result |
|---|---|---|---|---|
| First run, without the skill | 12 | 75,800 | 118 s | Valid, but every id invented (none follows a rule, so the next run's ids differ and people's decisions stop pointing at their findings); a proposed decision for every finding, blockers included; the password and a personal email address quoted in its reply |
| First run, with the skill | 7 | 57,900 | 53 s | Every finding right; its `where` lists broke a strict YAML reader (fixed in the skill) |
| Re-run, without the skill | 7 | 64,000 | 49 s | Right: it copied the conventions from the earlier file. It proposed only one decision |
| Re-run, with the skill | 7 | 56,500 | 63 s | Right |
| First run, with the skill, after the fixes | 7 | 57,900 | 63 s | Right, and valid against the schema |
| Re-run, with the skill, after the fixes | 7 | 57,000 | 69 s | Right: the deleted file's decision marked stale, the keystore still blocking from the history |

## What it shows

* **The first run is where the skill matters.** Without it the assistant took 40% more tool calls and tokens and
  twice as long, and produced ids that can't be reproduced, so every later run would orphan people's decisions. It
  also put secret values in its reply.
* **On a re-run the earlier file teaches most of the conventions,** so the saving is smaller: about 12% fewer tokens,
  and a proposed decision for every finding that needs one, the same way each time.
* **The trial found two faults the skill now covers:** bare `path:line` entries that some YAML readers reject, and
  keystores deleted from the current files but still in the history, which the inventory's rules missed (see
  [Keystores and private key files are found over the whole history, by rules added to the secrets scan](../decisions/0041-keystores-and-private-key-files-are-found-over-the-whole-history-by-rules-added-to-the-secrets-scan.md)).
* The assistant without the skill noticed one thing the skill doesn't ask for: a production database address in the
  settings. That belongs to the connection list, drafted in discovery, not to the inventory.
