---
name: write-the-testing-plan
description: Generate a repo's testing/TESTING-PLAN.md from its testing/assessment.yaml and external systems list: the target level, every piece of work in workstream order with a stable key, the techniques deferred and rejected, and what the Application Owner settles by approving it. Use after the techniques are chosen, when asked for a repo's testing plan, or to regenerate it after the assessment file changes.
---

# Writing the testing plan

**Where the toolkit's files are:** this skill's links work wherever it is: in the toolkit's own repo they are relative to it, and when APM installs the toolkit in a repo it rewrites them to the toolkit's folder under `apm_modules/`. Where a command names `<toolkit>`, that is the toolkit's root: the repo root in the toolkit itself, otherwise `"$(dirname "$(find apm_modules -path '*/.github/skills/write-the-testing-plan/SKILL.md' | head -1)")/../../.."`.

The plan is generated, never edited by hand
([Testing plans are generated from the assessment file, and the issue tracker follows the work](../../../decision-guides/0024-testing-plans-are-generated-from-the-assessment-file-and-the-issue-tracker-follows-the-work.md)),
and [load-repo-work-into-the-issue-tracker](../load-repo-work-into-the-issue-tracker/SKILL.md) matches it to tracker
items by key. Follow these rules exactly, add nothing that isn't in the files, and change no other file.

Never copy a secret's value (a password, key or token met in code, settings or a report) into a file you write or
your reply: point at its file and line instead
([why](../../../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

## 1. Read and check

Read `testing/assessment.yaml` ([its schema](../../../schema/assessment.schema.json));
`testing/external-systems.calm.json` ([its schema](../../../schema/external-systems-list.schema.json)) if it exists;
only each entry's `test`, `external_systems` and `repair` in `testing/tests.yaml`
([its schema](../../../schema/tests.schema.json)) if it exists; each
technique's `name`, `workstream`, `test_stand_in_approach` and `evidence_for_maturity_levels`, only from its
`techniques/<id>/technique.yaml` ([the toolkit's techniques](../../../techniques/README.md); that list is not a
source); and only the Key and Tracker item columns of any existing `testing/TESTING-PLAN.md`.

Write nothing, and report only why, if there is no `techniques` section (run the choose-techniques skill first), no
target level, or a `safety` finding with `effect: blocks` and no `safety/<finding id>` decision with `state: decided`
(whatever its choice): name each such finding, and say the Security and Platform Owner decides it.

* A `stale` decision counts as absent.
* A technique is **adopted**, **deferred** or **rejected** when its `techniques/<id>` decision's `choice` is exactly
  `adopt`, `defer` or `reject`, proposed or decided; otherwise it appears nowhere.
* The **target level** is the `level/target` choice, marked `decided` or `proposed` by its state; without one, the
  target for `repo.business_criticality` in
  [Target test maturity level for each business criticality](../../../decision-guides/0015-target-test-maturity-level-for-each-business-criticality.md):
  `high` 4, `medium` 3, `low` 2, marked `from business criticality, not yet decided`. Level 5 checks on key journeys
  come from the "check in production" techniques.
* A missing count, such as `tests.failing` or a connection's `tests`, is 0.
* **Sorted** is character order (`LC_ALL=C sort`).
* A copied value goes on one line, each line break inside it as a space, with no space at either end, and `|` as `\|`.

## 2. Work out the pieces of work

Each row's **key** is `<repo.name>:<workstream>:<slug>`. Make rows by these rules only; in Work and Done when, fill
`<...>` from the files and write the rest exactly. A **connection** is any relationship in the external systems list
whose state isn't `stale`; its destination node id is `relationship-type.connects.destination.node`, its destination name
that node's `name`, and its `stand-in.approach`, `stand-in.kit`, `state`, `never-reach` and `tests` are all under `metadata.under-test`.

| # | From | Made when | Workstream | Slug | Work | Done when |
|---|---|---|---|---|---|---|
| 1 | each connection | approach is `run-in-container`, `recorded-responses`, `contract` or `fake-behind-an-interface` | `make-it-run-on-its-own` | `stand-in-<destination node id>` | Give tests a stand-in for <destination name>: <approach, in words>, with <technique name> | Tests that reach <destination name> use the stand-in and pass with outbound calls blocked. |
| 2 | each connection | approach is `not-chosen` | `make-it-run-on-its-own` | `choose-stand-in-<destination node id>` | Choose what tests use for <destination name> | The Architecture Owner has decided the stand-in in the external systems list |
| 3 | each external system: a node named by an `external_systems` entry graded `reaches` in `testing/tests.yaml` | a test with such an entry for it has no `repair` field | `make-it-run-on-its-own` | `pair-<node id>` | Pair the <n> tests that reach <system name> (repair) | Each is a pair, or recorded as waiting |
| 4 | `tests.failing` | more than 0 | `make-it-run-on-its-own` | `tests-failing-every-run` | Make the <n> tests that fail in every run pass with outbound calls blocked | No test fails in every run |
| 5 | `tests.flaky` | more than 0 | `fix-flaky-tests` | `flaky-tests` | Fix the <n> flaky tests, groups that fail together first | Five runs in a row with no flaky test |
| 6 | each `unreliable_tests` finding (kind `sleeps` or `order-dependent`) | always | `fix-flaky-tests` | `<finding id>` | Fix the <n> tests that <sleep / depend on the order they run in> | <No test sleeps / Every test passes when run alone> |
| 7 | each adopted technique | it is no row 1's technique | its `workstream` | `<technique id>` | <technique name> | Gives evidence for level <the lowest of its evidence_for_maturity_levels> |
| 8 | each `meaningless_tests` finding of kind `disabled` or `never-runs` | always | `strengthen-tests` | `<disabled-tests / never-run-tests>` (with `-<finding id>` added if that kind has more than one finding) | <Re-enable or delete the <n> disabled tests / Make the <n> tests that never run run, or delete them>, as the Application Owner decides, once current behaviour is recorded | <No disabled test / No test that never runs> is left undecided |
| 9 | each `meaningless_tests` finding of kind `no-real-assertion`, `swallows-failures`, `mocks-everything` or `other` | always | `strengthen-tests` | `<finding id>` | Fix the <n> tests that <have no real assertion / swallow their own failures / mock everything / its id with hyphens as spaces, dropping a leading `other-`> | Each of those tests asserts what the code does, and catches a planted bug |

* `<a / b>` picks by kind, in the order the kinds are listed.
* **Approach in words:** `run-in-container` "run in a container", `recorded-responses` "recorded responses",
  `contract` "a contract test", `fake-behind-an-interface` "a fake behind an interface".
* **Row 1's technique** is the adopted one whose `test_stand_in_approach` is the connection's approach, the first by
  id if several. With none, write "no technique adopted yet" as its name and make the row anyway.
* **Row 1 extras:** append to Work ", using the shared test kit <kit>" if the stand-in has a `kit`, then
  " (proposed: the Architecture Owner confirms it)" if the connection's state is `proposed`; to Done when,
  " No test can reach <never-reach hosts, in file order, joined by ", ">." if it has any.
* **Row 3** stands until repair exists: while a test that reaches a system has no `repair` field in
  `testing/tests.yaml`, the system gets the row; once each such test has one, the row goes. `<system name>` is the
  node's `name` in the external systems list, else its id. No `testing/tests.yaml` makes no row 3.
* **Row 9 for `mocks-everything`**
  ([why](../../../docs/decisions/0087-tests-that-mock-everything-are-fixed-in-the-testing-plans-work-each-mock-sorted-by-what-it-stands-for.md)):
  Work is instead "Fix the <n> tests that mock everything, after the approval-test baseline covers their behaviour:
  sort each mock into the real object, the system's stand-in from the external systems list, or a call kept as the
  behaviour", and Done when "Each mock is the real object, the system's stand-in, or kept as the behaviour, and each
  of those tests catches a planted bug".
* **Finding rows** (6, 8, 9) are made whatever the `unreliable/<finding id>` or `meaningless/<finding id>` decision,
  unless it is decided with a choice of exactly `leave as is`. A finding with no `tests` makes no row.
* **`<n>`** is, for row 3, how many tests have an `external_systems` entry for the node graded `reaches` and no
  `repair` field; the From value for rows 4 and 5 (`tests.failing`, `tests.flaky`); and the finding's `tests` for rows
  6, 8 and 9.
* **Order:** within a workstream by rule number; within a rule, rows 1 to 3 by most tests then by key, other rows by
  key. For row 3, the tests are its `<n>`.
* **Labels**, plain, joined by ", ", in this order: `workstream:<id>`; `technique:<id>` for row 7 and for row 1 with a
  technique; `level:<lowest evidence level>` for row 7; `application:<repo.application>` if set
  ([Repo work is tracked in the organisation's issue tracker with standard labels](../../../decision-guides/0027-repo-work-is-tracked-in-the-organisations-issue-tracker-with-standard-labels.md)).
* **Tracker item:** the key's, from the existing plan's "Work, in order" or "Work no longer in the plan" tables;
  empty for a new key. A key that comes back keeps its tracker item; the loader reopens it. Under "Work no
  longer in the plan" go, sorted by key, each key from the existing plan's "Work, in order" or "Work no longer in the
  plan" tables that is no longer made and has a tracker item; the loader closes them, and skips any already closed.

## 3. Write `testing/TESTING-PLAN.md`

Fill [the plan template](../../../templates/testing-plan.md): its path is the file the template link above points
to (in a repo that installed the toolkit, under `apm_modules/`), that is `templates/testing-plan.md` there. If you can't read the template, stop and say so; don't
write the plan from memory. Replace each `{...}` as below; keep every other
character, the generated-file comment included. Remove the "Template note" comment and each line that is only a
braced instruction ending in `:}`, each with the blank line after it. A list placeholder becomes one line per item; a
placeholder table row becomes one row per item, or none, leaving the header. An empty cell is `| |`. Leave out "Work
no longer in the plan", with its instruction line, unless it has rows. Never two blank lines in a row; end with one
newline.

| Placeholder | Filled with |
|---|---|
| `{repo.<field>}`, `{level.reached}` | that value; if missing, an empty cell, and for `{repo.summary}` no line and no blank line after it |
| `{short commit}` | what `git rev-parse --short HEAD` prints in the repo |
| `{target level} ({its mark})` | from step 1 |
| `{decision lines}` | per decision with `state: proposed` and a `choice`, sorted by key: ``* `<key>`: <choice>.``, then ` <reason>` if any; but ``* `<key>`: <reason>`` when the reason begins with `<choice>:`. No `.` after a choice ending in `.`, `?` or `!`. No state marked. With none, "None." |
| `{question lines}` | per decision with a `question` and no `choice`, sorted by key: ``* `<key>`: <question>``. With none, "None." |
| `{level}` | each level above `level.reached` up to the target, lowest first; with no `level.reached`, every level from 0 up to the target |
| `{evidence}` | the ids of adopted techniques whose `evidence_for_maturity_levels` has the level, sorted, joined by "; "; with none, "None adopted. Deferred: " and each such deferred one as "<id> (<its decision's reason>)", or just "<id>" with no reason, sorted, joined by "; ", with no full stop after the last; or "none." Never rejected ones |
| `{n}. {workstream, in words}` | one section per workstream with rows, one blank line between, numbered from 1, in the order of [The order of workstreams for a repo](../../../decision-guides/0050-the-order-of-workstreams-for-a-repo.md): "Make it run on its own", "Fix flaky tests", "Record current behaviour", "Make code testable", "Test against requirements", "Strengthen tests", "Check in production" |
| `{key}`, `{work}`, `{done when}`, `{labels}`, `{tracker item}` | from step 2 |
| `{technique name}`, `{defer or reject}`, `{state}`, `{reason}` | the deferred techniques, then the rejected ones, each group sorted by id: its `name`, its choice, its decision's state, and its decision's `reason` word for word |

## 4. Report

If you stopped, say only what stopped you and who decides it. Otherwise: how many pieces of work in each workstream,
the decisions and questions the Application Owner must settle, any connection still without a stand-in, and that
merging the pull request holding the plan and the assessment file approves it.
