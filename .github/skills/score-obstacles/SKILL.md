---
name: score-obstacles
description: Score each obstacle to testing a repo has, from 0 to 3, by the named list in the decision guide, using only facts already in its testing/assessment.yaml, testing/external-systems.calm.json and testing/tests.yaml, and write the obstacles section with the evidence for each score. Use after measuring a repo, before choosing techniques, or when asked what makes a repo hard to test.
---

# Scoring obstacles

**Where the toolkit's files are:** this skill's links are relative to its folder in the toolkit, `.github/skills/score-obstacles/`. In the toolkit's own repo, follow them as they are. In a repo that installed the toolkit with APM, this skill is a copy, so read each link from the toolkit's package folder instead: `TOOLKIT="$(dirname "$(find apm_modules -path '*/.github/skills/score-obstacles/SKILL.md' | head -1)")/../../.."`, then `$TOOLKIT/<the link without its ../../../>`.

Apply the table in
[The named list of obstacles to testing and how each is scored](../../../decision-guides/0029-the-named-list-of-obstacles-to-testing-and-how-each-is-scored.md)
exactly, and write the `obstacles` section of `testing/assessment.yaml` ([schema](../../../schema/assessment.schema.json)).
If the organisation repo's own version of that guide has a different table, the person will say so: use theirs.
Read only `testing/assessment.yaml`, `testing/external-systems.calm.json` and `testing/tests.yaml`; don't read or run
the repo's code.

Never copy a secret's value (a password, key or token met in code, settings or a report) into a file you write or
your reply: point at its file and line instead
([why](../../../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

## 1. Facts

* A **connection** is a relationship in the external systems list whose `metadata.under-test.state` isn't `stale`; its
  destination node is `relationship-type.connects.destination.node`. A **queue** node is one with an interface on
  port 5672, 9092 or 61616, or the destination of a connection whose `metadata.under-test.kinds` contains `queue`.
* A connection's stand-in is **decided** when its `metadata.under-test.state` is `decided`. A safety finding is
  **decided** when the decision `safety/<finding id>` has `state: decided`.
* A meaningless or unreliable kind's count is the sum of `tests` over the `meaningless_tests` or `unreliable_tests`
  findings whose `kind` is the one named, one evidence line each. The tests that **reach external systems** are the
  entries of `testing/tests.yaml` with at least one `external_systems` entry graded `reaches` or `may-reach`, one
  evidence line for their count. A connection **with `never-reach`** has a non-empty `never-reach`. With `planted` 0,
  `tests-catch-few-planted-bugs` isn't scored.
* A **share** is the count ÷ `tests.count` × 100. With `tests.count` 0 or missing, no share-based obstacle is scored.
* An obstacle whose "From" fact isn't in the files isn't scored: no external systems list means no connection obstacles;
  no `tests` section, or no such field in it (such as `tests.failing`), means no obstacle from it; no `safety` section
  means no safety obstacles. A missing
  finding, with its section present, counts as 0 tests; no `testing/tests.yaml` means `tests-reach-external-systems`
  isn't scored.

## 2. Score

For each obstacle in the table, in the table's order, find the column its fact falls in. The columns are scores 0, 1,
2 and 3, left to right. For line coverage and the share of planted bugs caught, a higher value is a lower score: line
coverage 61 falls in "60 to under 80", so it scores 1. A score of 0 is still written. Each finding has `id`, `score`, then `evidence`: one line for every item the From column matches,
whatever the score, quoted, in this form, sorted by byte order; `none` only when nothing matches:

| Fact | Evidence line |
|---|---|
| a count of connections | `"testing/external-systems.calm.json: <relationship unique-id>"`, one line per connection counted; or `"testing/external-systems.calm.json: none"` |
| a count of findings | `"testing/assessment.yaml: safety/<finding id>"` or `"testing/assessment.yaml: meaningless_tests/<finding id>, <tests> tests"`; or `"testing/assessment.yaml: none"` |
| tests that reach external systems | `"testing/tests.yaml: <count> tests reach or may reach an external system"` |
| a share of a `tests` field | `"testing/assessment.yaml: tests.<field> <value> of <tests.count>"` |
| a share of a meaningless kind | `"testing/assessment.yaml: meaningless_tests/<finding id>, <tests> tests of <tests.count>"` |
| coverage | `"testing/assessment.yaml: tests.line_coverage <value>"` |
| planted bugs | `"testing/assessment.yaml: tests.planted_bugs <caught> of <planted>"` |

```yaml
obstacles:
  found_by: {tool: score-obstacles, version: "unreleased", commit: "1a2b3c4"}
  findings:
    - id: can-reach-production
      score: 3
      evidence: ["testing/external-systems.calm.json: orders-service-to-db-orders-prod-example-com"]
```

`version` is the organisation profile's `toolkit.version` if you have it, else `unreleased`. `commit` is what
`git rev-parse --short HEAD` prints in the repo. Always double-quote `version`, `commit` and each evidence line;
`score` stays a bare number. `evidence` goes on one line, joined by `, `; `findings` is a block list with
items four spaces in, as in the example.

Replace the `obstacles` section where it is; a new one goes directly before the next section the schema lists
(`techniques`, then `decisions`, then `notes`), with no blank line. Leave every other line of the file as it is.

## 3. Report

Tell the person, briefly: each obstacle scoring 2 or 3, highest first, then in the table's order, with its evidence; the obstacles not scored
and the fact each is missing; and that scores are proposed, for the Test Quality Lead to confirm.
