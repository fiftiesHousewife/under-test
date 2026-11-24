---
status: proposed
decision-makers: Test Quality Lead, approved by the Steering Group
group: Understanding our repos
---

# The named list of obstacles to testing and how each is scored

**Decided by:** Test Quality Lead, approved by the Steering Group · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

Plans need a consistent, named list of what makes a repo hard to test, with a rule for scoring each.

## Considered Options

* **Agree a full list with plain names (e.g. "uses the system clock directly", "needs a real Oracle database", "holds production secrets", "can reach production"), each with a scoring rule from measured facts**  
  Explainable and consistent
* **Score only the obstacles already well understood**  
  Gaps in the plan

## Decision Outcome

Proposed: the first option, scored only from facts the toolkit's skills already record in the assessment file and the
external systems list. Each obstacle scores 0 (not an obstacle), 1, 2 or 3 (severe). An obstacle whose facts aren't
recorded yet isn't scored. Obstacles that need a code scan (the system clock used directly, hard-wired dependencies)
are added when a skill records them.

| Obstacle | From | 0 | 1 | 2 | 3 |
|---|---|---|---|---|---|
| `can-reach-production` | connections with `never-reach` | none, or every one decided | | | any whose stand-in isn't decided |
| `holds-production-secrets` | `safety` findings of kind `committed-secret`, `keystore-or-private-key` or `production-credential` | none | every one decided | | any not decided |
| `may-hold-real-personal-data` | `safety` findings of kind `real-personal-data` | none | every one decided | | any not decided |
| `starts-things-by-itself` | `safety` findings of kind `self-starting-job` or `migration-at-start-up` | none | 1 | 2 or 3 | 4 or more |
| `needs-real-infrastructure` | connections to a `database`, `ldap` or queue node whose stand-in isn't decided | none | 1 | 2 | 3 or more |
| `depends-on-other-services` | connections to a `service` node | none | 1 | 2 or 3 | 4 or more |
| `talks-to-unplanned-systems` | connections whose stand-in approach is `not-chosen` | none | 1 | 2 | 3 or more |
| `tests-reach-external-systems` | tests in `testing/tests.yaml` with an external system graded `reaches` or `may-reach` | 0 | 1 to 5 | 6 to 20 | more than 20 |
| `flaky-tests` | `tests.flaky` as a share of `tests.count` | 0 | under 2% | 2% to under 5% | 5% or more |
| `tests-fail-every-run` | `tests.failing` as a share of `tests.count` | 0 | under 2% | 2% to under 5% | 5% or more |
| `tests-check-nothing` | the `no-real-assertion` meaningless tests' `tests` as a share of `tests.count` | 0 | under 5% | 5% to under 15% | 15% or more |
| `disabled-tests` | `tests.disabled` as a share of `tests.count` | 0 | under 2% | 2% to under 5% | 5% or more |
| `little-code-run-by-tests` | `tests.line_coverage` | 80 or more | 60 to under 80 | 30 to under 60 | under 30 |
| `tests-catch-few-planted-bugs` | `tests.planted_bugs`: caught ÷ planted | 0.8 or more | 0.5 to under 0.8 | 0.2 to under 0.5 | under 0.2 |
| `native-libraries` | `safety` findings of kind `native-library` | none | 1 | 2 | 3 or more |

### Consequences

* The [score-obstacles](../.github/skills/score-obstacles/SKILL.md) skill applies the table and writes the
  assessment file's `obstacles` section.

## More Information

* Builds on: [The assessment file: where it lives, who writes which fields, and its schema version](0023-the-assessment-file-where-it-lives-who-writes-which-fields-and-its-schema-version.md)
* Later decisions that build on this: none yet
* Background: none
