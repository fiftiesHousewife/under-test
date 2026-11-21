---
name: work-on-an-item
description: Pick up a work item from the organisation's issue tracker (in this repo, the toolkit backlog in plan/toolkit-backlog.yaml) and finish it in this repo. Use when asked to "do the next item", "work the backlog", or to work on a named item.
---

# Working on an item

## 1. Pick an item
- If the person named an item, use it. Otherwise list open items in the issue tracker that aren't blocked, using
  the tracker's REST API or web view. Don't assume extra command-line tools are installed. For GitHub, for example:
  `curl -s -H "Authorization: Bearer $UNDERTEST_GITHUB_TOKEN" "$GITHUB_API_URL/repos/OWNER/REPO/issues?labels=horizon:%20now&state=open"`
  (then skip items with open "blocked by" links). For Jira, a JQL search through its REST API.
  Before the backlog has been imported, read [the toolkit backlog](../../../plan/toolkit-backlog.yaml).
- Read the item's "done when" list and any linked decision record. If it depends on an open decision, stop and say so.

## 2. Act according to who does it
| Done by | You may | You must not |
|---|---|---|
| **tool** | Build or configure a tool, with tests. Same input gives the same output. Look for an existing tool first, and record the choice in a decision guide. | Put an AI model inside the tool. |
| **ai** | Draft content (skills, prompts, tests, lessons) for the person to review. | Leave it unchecked: finish with `./gradlew check` or the relevant checklist. |
| **person** | Draft the decision record or document, with options and a recommendation. | Accept a decision, choose between open options, or invent owners, thresholds or expert names. |

## 3. Rules
- Follow [AGENTS.md](../../../AGENTS.md): plain English, references by name and link, no dates, a schema for every YAML file, the code standards.
- Keep this repo generic. Organisation facts and choices go in the organisation's private organisation repo.
- Never build or run another repo's code unless its secrets scan is clean, and only where production can't be reached.

## 4. Finish
1. Run `./gradlew check` and include the result.
2. Tick the item's "done when" list in the tracker, and link the pull request.
