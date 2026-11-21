# Backlog importers

Load [the backlog seed](../../plan/backlog-seed.yaml) into the organisation's issue tracker, once. After that the tracker
is the only list (see [The programme backlog lives in the organisation's issue tracker, not in a file](../../docs/decisions/0005-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md)).

| Tracker | Importer | Built on |
|---|---|---|
| GitHub Issues | [`import_to_github.py`](import_to_github.py) | GitHub CLI and REST API (sub-issues, blocked-by links) |
| Jira Cloud | to do | Jira Cloud REST API or Atlassian's command-line tool: outcomes as epics, deliverables as children, "blocks" links. Credentials from `JIRA_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN` in the environment |

```bash
python3 tools/backlog-import/import_to_github.py OWNER/REPO           # dry run
python3 tools/backlog-import/import_to_github.py OWNER/REPO --apply   # create or update issues
```

Re-running updates issues by key rather than duplicating them.
