---
name: choose-techniques
description: Propose adopt, defer or reject for every technique in techniques/ against a repo's assessment file, connection list and source list, each traced to the rule that decided it, in testing/assessment.yaml. Use before writing a repo's testing plan, or when asked which testing techniques fit a repo.
---

# Choosing techniques

You propose; people decide. Don't build or run anything.

## 1. Read

The repo's `testing/assessment.yaml` ([its schema](../../../schema/assessment.schema.json)), or stop if it is missing;
`testing/connections.calm.json` and `testing/sources.yaml` if they exist; its build files (JDK, build tool, test
framework); the organisation's testing guide for its stack and application type, if given; and every technique's
rules, in one read of [`techniques/rules.json`](../../../techniques/rules.json) in the toolkit, whose root is three
folders up from this skill's folder (not in the repo; generated from the `techniques/<id>/technique.yaml` files, one
technique per line, with every field these rules use). Read nothing else: not the techniques README, nor any
`technique.yaml`, even where the repo has copies.

The **target level** is the `level/target` choice if its state is `decided`, else the target for
`repo.business_criticality` (high 4, medium 3, low 2, from
[Target test maturity level for each business criticality](../../../decision-guides/0015-target-test-maturity-level-for-each-business-criticality.md),
which you needn't read). With neither, stop and say so.

## 2. Decide each technique

Give each `needed_when`, `possible_when` and `reject_or_defer_when` condition a result: true, false or unknown.

* A `needed_when` or `possible_when` condition is **true** when the build files, the testing files or the request show
  it holds; **false** when they show it can't hold; **unknown** when it depends on code or facts you weren't given.
  Something missing from the files is unknown, not false, unless a file that would list it leaves it out: the build
  file for dependencies and frameworks, the measurement run for tests, the anti-pattern check for anti-patterns, the
  connection list for connections and the programs the application starts. A condition about which framework the
  code uses is known from the build file's dependencies (Spring Boot starters mean Spring contexts); a precondition
  check that would measure it more closely doesn't make it unknown.
* A `reject_or_defer_when` condition the files don't mention is false. One they mention but don't settle is unknown.
  A condition counts as mentioned only when a file speaks to every part of it.
* A fact the person states in the request counts as known; say so in the fact ("stated in the request").
* **Planned work** is: every technique adopted in this run; the fix-flaky-tests workstream whenever `tests.flaky` is
  above 0; and the make-it-run-on-its-own workstream whenever any connection has no decided stand-in (its state isn't
  `decided`, or its `stand-in.approach` is `not-chosen`) or `tests.failing` is above 0. An adopted technique's work
  belongs to its `workstream`. A condition about what will be ("has been or will be") is true when planned work does
  it.
* A `possible_when` condition that is false or unknown now, but that planned work will make true, counts as planned
  work; its fact names the work. So does a `possible_when` condition that is unknown and that one of the technique's
  own precondition checks would settle; its fact names the check. Never do either for a `needed_when` or a
  `reject_or_defer_when` condition: a `reject_or_defer_when` condition true now stays true even when planned work will
  change it (a flaky suite that fix-flaky-tests will fix still defers), and the reason says `Waits for` that work.
* A precondition check marked `outside_approval: true` that the files or the request don't show as given defers the
  technique. A decided stand-in in the connection list is not an `outside_approval`. Every other check is part of the
  work, and never defers it.
* `constraints` never change the choice; respect them in the work.

Then apply these in order; the first that applies decides. Work that must wait for earlier work is still adopted: the
plan orders it. An adopt can make a condition of another technique planned work, so go through the techniques again
until a pass changes nothing.

1. **defer** if every level in `evidence_for_maturity_levels` is above the target level.
2. **reject** if any of these holds:
   1. a `reject_or_defer_when` condition is known true and is about the framework, a vendor, a licence or who owns
      what;
   2. every `needed_when` condition is known false;
   3. the technique lists `application_types` and none of them is in the repo's `application_types`.
3. **defer** if any of these holds:
   1. any other `reject_or_defer_when` condition is known true, or one is unknown. When it is that there is no
      subject-matter expert and no specification, the reason's fact says this is an open risk for the Application
      Owner;
   2. an `outside_approval` check isn't given;
   3. no `needed_when` condition is known true, but one is unknown;
   4. a `possible_when` condition is unknown, or false and not planned work.
4. **adopt** if a `needed_when` condition is known true and every `possible_when` condition holds or is planned work.

Never reject on an unknown.

## 3. Write `testing/assessment.yaml`

Change only the `techniques` section and the `techniques/<id>` decisions. Each value you write goes on one line;
every other line in the file stays exactly as it is. Double-quote every `commit`, `reason` and `because` line, and any
other text value (not a number) starting with a digit or containing `:` or `#`, escaping `"` and `\` with `\`.

```yaml
techniques:
  found_by: {tool: choose-techniques, version: unreleased, commit: "<git rev-parse --short HEAD, in the repo>"}
  candidates:
  - id: <technique id>
    because:
    - "<field> '<condition>': <true, false or unknown>; <fact>"
```

* It replaces the existing section, or goes before `decisions:`, else before `notes:`, else at the end. `version` is
  the organisation profile's `toolkit.version` if you have it, else `unreleased`.
* One candidate per technique, sorted by id in character order.
* `because` has exactly these lines, and no others:
  1. one per `needed_when`, then `possible_when`, then `reject_or_defer_when` condition, each in the rule's order, as
     `<field> '<condition>': <true, false or unknown>; <fact>`, the condition copied exactly, apostrophes included;
  2. one per `precondition_checks` entry, as `precondition '<check>': <fact>`, where `<fact>` is exactly one of:
     `part of <workstream id>` when the check names a workstream; `part of the work` for any other check not marked
     `outside_approval`; for an `outside_approval` check, `not given`, or `given; <fact>` when the files or the request
     show it given;
  3. `evidence_for_maturity_levels [<levels>] is above the target level <n>`, only when it decides the choice, with
     the levels joined by `, `.
* Decisions: remove the proposed `techniques/<id>` ones, then after the last remaining decision write, sorted by id,
  `techniques/<id>:` with `state: proposed`, `drafted_by: ai`, `choice` and `reason`, in that order. Skip a technique
  whose decision is `decided` or `stale`, leaving it as it is; if your choice differs from a decided one, report it.

### `reason`

The first part names the rule that decided. Within a choice, the first matching sub-rule decides the reason form: the
forms below are in the order of the sub-rules, so a defer that both needs an `outside_approval` check and has an unknown
`needed_when` uses the `needs` form.

| Choice | Forms, in order |
|---|---|
| defer (evidence) | `defer: every level in evidence_for_maturity_levels (<levels>) is above the target level <n>` |
| reject | `reject: '<reject_or_defer_when condition>', <fact>`; `reject: every needed_when is known false; <fact>`; `reject: application_types (<types>) does not include <repo's types>` |
| defer | `defer: '<reject_or_defer_when condition>', <fact>`; `defer: needs '<check>', <fact>`; `defer: '<needed_when condition>' is unknown; <fact>. Check <what>`; `defer: '<possible_when condition>' is <unknown or false>; <fact>. Check <what>` |
| adopt | `adopt: '<needed_when condition>', <fact>`, once for each true `needed_when`, joined by `; ` |

`<levels>` are joined by `, `. `needs '<check>'` quotes the first missing `outside_approval` check, in the order
listed.

Then `.`; then, as they apply, in this order:

* `Waits for <workstream id>.` once for each workstream whose planned work the choice depends on: a `possible_when`
  condition counted as planned work because of it, a precondition check that names it, or, on a defer, a true
  `reject_or_defer_when` condition it will change. Write them in the order of the workstreams. Planned work that is the
  technique's own precondition check names no workstream.
* `Brought back when <what would change>.` on every defer, naming every condition and check that deferred the
  technique, in rule order.
* On a reject of a technique that has a `test_stand_in_approach`, one sentence for each connection, in the connection
  list's order, whose `stand-in.approach` is `not-chosen`, or equals that `test_stand_in_approach` and no adopted
  technique has the same `test_stand_in_approach`: `Its fallback, <fallback>, stands in for <unique-id>.`
  `<fallback>` is the technique's `fallback`, in single quotes if it isn't a technique id; `<unique-id>` is the
  connection's CALM relationship `unique-id`. Connections come only from `testing/connections.calm.json`'s
  `relationships`, never from the assessment file's `running_offline` findings.

The `<fact>` text in reasons and `because` lines is your own evidence and may vary between runs. The choice, the
conditions quoted and their true, false or unknown results may not.

An adopt with two true needs:

```yaml
    reason: "adopt: 'Code must change soon and nobody can say exactly what it does', the refund code is being rewritten; 'Many tests run the code without checking results, or few planted bugs are caught', 14 tests check nothing. Waits for make-it-run-on-its-own."
```

## 4. Report

Briefly: what to adopt, grouped by workstream in the order of
[The order of workstreams for a repo](../../../decision-guides/0050-the-order-of-workstreams-for-a-repo.md); what is
deferred, each with what would bring it back; any connection left without a technique to stand in for it; any decided
choice the rules now disagree with. Connections are the relationships in `testing/connections.calm.json` only; a
`running_offline` finding with no relationship there isn't one, so say it needs adding to the connection list.
