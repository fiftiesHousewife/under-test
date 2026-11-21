---
name: load-repo-work-into-the-issue-tracker
description: Load a repo's approved testing plan into the organisation's issue tracker (for example GitHub Issues or Jira Cloud) as a parent item plus one item per piece of work, and write the item keys back into the plan. Use after a repo's TESTING-PLAN.md is approved, or when asked to "create the tickets" for a repo.
---

# Loading a repo's work into the issue tracker

> Placeholder: the tracker-neutral loader and its Jira Cloud adapter are still to be built
> (see [Each repo's work is loaded into the issue tracker by one tool, with an adapter per tracker](../../../docs/decisions/0044-each-repos-work-is-loaded-into-the-issue-tracker-by-one-tool-with-an-adapter-per-tracker.md)).
> Until then, use the GitHub importer in [tools/backlog-import](../../../tools/backlog-import/README.md) for the programme backlog only.

1. Read the organisation profile from the private organisation repo: `issue_tracker` (which tracker, its address and project) and
   `commit_messages`. Credentials come from the person's environment (for example a Jira API token), never from files.
2. Check the repo's `testing/TESTING-PLAN.md` is approved (merged). Don't load an unapproved plan.
3. Run the loader as a **dry run** and show the person what it would create or update.
4. Only after the person agrees, run it for real. The loader matches items by stable key, so re-running updates rather than duplicates.
5. Write the created item keys back into the plan, in the same pull request as any other plan change.
6. If `commit_messages.must_name_work_item` is true, every commit you make for this work names its item key,
   for example `TEST-123 Record current behaviour of the payment endpoint`.

You may read the tracker through an MCP server if the person's AI assistant has one, but you never create items that way:
loading always goes through the loader, so it can be repeated and reviewed.
