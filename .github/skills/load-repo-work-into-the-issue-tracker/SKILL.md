---
name: load-repo-work-into-the-issue-tracker
description: Load a repo's approved testing/TESTING-PLAN.md into the organisation's issue tracker (for example GitHub Issues or Jira Cloud) as a parent item plus one item per piece of work, and record each item in the plan's Tracker item column. Use after a repo's testing plan is approved, or when asked to "create the tickets" for a repo.
---

# Loading a repo's work into the issue tracker

> **The loader isn't built yet**
> (see [Each repo's work is loaded into the issue tracker by one tool, with an adapter per tracker](../../../docs/decisions/0023-each-repos-work-is-loaded-into-the-issue-tracker-by-one-tool-with-an-adapter-per-tracker.md)).
> Until it is, do steps 1 and 2, tell the person what the loader would do (per row, create or update, looking items up
> in the tracker only by Tracker item cell or key, or saying every action is unverified if you can't read the
> tracker), and **stop**. Create, change or close no
> item by any other means: not the backlog importer, not an MCP server, not by hand. The rules below are what the
> loader does, so it can be built to them.

Never copy a secret's value (a password, key or token met in code, settings or a report) into a file you write or
your reply: point at its file and line instead
([why](../../../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

The plan comes from the [write-the-testing-plan](../write-the-testing-plan/SKILL.md) skill, which keeps each row's
Tracker item when it regenerates the plan.

## 1. Check

Stop, and say why, unless all of these hold:

* The person names the organisation repo, and its `organisation-profile.yaml`
  ([schema](../../../schema/organisation-profile.schema.json)) has `issue_tracker.kind` with a loader adapter
  (`github-issues` or `jira-cloud`), with `url` (for `github-issues`, the repository whose issues hold the work) and,
  for `jira-cloud`, `project_key` too.
* On the repo's default branch, the last pull request that changed anything in `testing/TESTING-PLAN.md` other than
  Tracker item cells was approved by the plan's Application Owner: someone the person confirms holds that role for
  the repo, or a code owner of `testing/` where the repo names one ([Who approves repo and application testing plans](../../../decision-guides/0026-who-approves-repo-and-application-testing-plans.md)).
  Load that copy, not a working copy.
* Every label in the plan has no space or comma inside it.

Credentials come from the person's environment (for example a Jira API token), never from files.

## 2. What the loader does

| Plan | Tracker |
|---|---|
| The repo | One parent item, key `<repo name>`, title "Testing plan: <repo name>", empty description, label `application:<the plan's Application cell>` (none if the cell is empty). Every item below is its child. |
| Each row under "Work, in order" | One item. Title: the Work cell, with each escaped bar (backslash then bar) turned back into a plain bar. Description: the Done when cell, a blank line, then "Key: <key>", the key being the cell's text without backticks. Labels: the Labels cell, split on ", ". |
| Each row under "Work no longer in the plan" | Its Tracker item is closed as "won't do", unless the cell is empty or the item is already closed. |

* **Matching:** by the Tracker item cell when it has one, otherwise by the "Key: <key>" line in descriptions. An item
  is never created when one matches. An item closed as "won't do" whose key is back under "Work, in order" is
  reopened; an item closed any other way is left as it is.
* **Updates** change only the title, the description, and labels starting `workstream:`, `technique:`, `level:` or
  `application:`; every other label, the status, assignee and comments are left alone.

| Tracker | Child items | Closed as "won't do" |
|---|---|---|
| `github-issues` | sub-issues of the parent | closed as "not planned" |
| `jira-cloud` | the parent is an Epic, each item a Task in it | the "Won't Do" resolution |
* **Dry run first:** show the person every item it would create, update, close or reopen, and every label it would
  create in the tracker. Their agreement is to all of it or none. To load less, change the assessment file and
  generate the plan again. If the real run would do anything the dry run didn't show, stop and show them again.

## 3. Record the items

After a real run, write each item's tracker key (`#123` for GitHub Issues, `TEST-123` for Jira) into the Tracker item
cell of the row with the same key. Write the parent's key nowhere in the plan: the loader finds it by its own key.
Change nothing else in the plan, and open a pull request that changes only Tracker item cells. It needs no
Application Owner approval, because the plan's scope is unchanged.

If the profile's `commit_messages.must_name_work_item` is true
([When the organisation requires it, every commit names its work item](../../../decision-guides/0028-when-the-organisation-requires-it-every-commit-names-its-work-item.md)),
that commit names the parent item's key, and a later commit for one piece of work names that item's key; each key
must match `commit_messages.work_item_key_pattern`; if one doesn't, don't commit: stop and tell the person. An absent `commit_messages` means false.

You may read the tracker through an MCP server if the person's AI assistant has one, but only the loader changes it,
so every change can be repeated and reviewed.
