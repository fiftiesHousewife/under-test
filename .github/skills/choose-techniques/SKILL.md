---
name: choose-techniques
description: Go through every technique rule in the toolkit's techniques/ folder against a repo's assessment file, connection list and source list, and propose adopt, defer or reject for each, with the rule that decided it. Writes the techniques section and proposed decisions of testing/assessment.yaml. Use before writing a repo's testing plan, or when asked which testing techniques fit a repo.
---

# Choosing techniques

Each technique in [`techniques/`](../../../techniques/README.md) has a `technique.yaml`: `adopt_when`,
`reject_or_defer_when`, `precondition_checks`, a `fallback`, `constraints`, the `workstream` its work goes into and the
`evidence_for_maturity_levels` it gives. You apply those rules to one repo and propose a choice for every technique, so
nothing is skipped and every choice can be traced to a rule. People decide; you propose.

## 1. Gather the facts

Read the repo's `testing/assessment.yaml` (its repo, level, safety, running_offline, tests, anti_patterns sections and
decisions), `testing/connections.calm.json` and `testing/sources.yaml` if they exist, and the organisation's testing
guide for the repo's technology stack and application type if you are given one. Read the repo's build files for its
JDK, build tool and test framework. Don't build or run anything.

The **target level** is the decided `level/target`, or failing that the target for the repo's business criticality
from [Target test maturity level for each business criticality](../../../decision-guides/0015-target-test-maturity-level-for-each-business-criticality.md).

## 2. Decide each technique, in this order

The question is whether a technique belongs in this repo's plan, not whether its work can start today: the testing plan
puts the workstreams in order, so a technique that has to wait for earlier work (stand-ins in place, the code running
on its own) is still adopted, with that dependency in its reason.

Go through **every** technique folder. For each, the first rule that applies decides:

1. **reject** if a `reject_or_defer_when` condition is known to be true and won't change (the repo has no such
   boundary, the system is a vendor's, the licence rules it out), or nothing in the repo calls for it.
2. **defer** if:
   * a `reject_or_defer_when` condition is true now but will change by itself or through work already planned (a
     flaky suite, coverage near zero);
   * it needs a person's answer or agreement that hasn't been given (another team agreeing to verify contracts, an
     open question in the assessment file);
   * every level in `evidence_for_maturity_levels` is above the target;
   * a fact it depends on is **unknown** from what you can read (whether stored procedures hold business rules, whether
     an upgrade is planned). Never reject on an unknown: defer, and say what to check.
3. **adopt** if an `adopt_when` condition is true from the facts.

The **reason** names the condition, quoted from the rule, and the fact behind it, for example: "adopt: 'Infrastructure
you own (database, broker, cache) that has an image', the orders database (connection
orders-service-to-db-orders-prod-example-com)". For a deferred technique, add what would bring it back. Respect
`constraints` (a JDK the tool needs, for example), and where a technique is rejected for a connection that still needs a
stand-in, say which technique its `fallback` points to.

## 3. Write it down

* `techniques` section, rewritten in full: `found_by` `{tool: choose-techniques, version: "<toolkit version, or
  unreleased>", commit: "<short commit>"}`, and a candidate for **every** technique, sorted by id, with `because`: the
  conditions you checked, each as a short line.
* A decision `techniques/<id>` for every technique, `state: proposed`, `drafted_by: ai`, `choice` adopt, defer or
  reject, `reason` as above. Don't change a decision people have made; if yours would differ, say so in your reply
  instead.

Leave every other section as it is.

## 4. Report

Tell the person, briefly:

* the techniques to adopt, grouped by workstream in the order of
  [The order of workstreams for a repo](../../../decision-guides/0050-the-order-of-workstreams-for-a-repo.md);
* the deferred ones, with what would bring each back;
* any connection left without a technique to stand in for it;
* any decided choice the rules now disagree with.
