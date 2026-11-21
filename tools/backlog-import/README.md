# Backlog importers

Load a backlog file into an issue tracker: [the toolkit's own backlog](../../plan/toolkit-backlog.yaml) into this repo's
tracker, or [the programme backlog template](../../templates/programme-backlog.yaml) into an organisation's tracker as its
starting backlog. After import, the tracker is the only list (see [The programme backlog lives in the organisation's issue tracker, not in a file](../../docs/decisions/0009-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md)).

| Tracker | Importer | Built on |
|---|---|---|
| GitHub Issues (public or an internal server) | [`import_to_github.py`](import_to_github.py) | GitHub REST API only; Python standard library; no GitHub CLI |
| Jira Cloud | to do | Jira Cloud REST API or Atlassian's command-line tool: outcomes as epics, deliverables as children, "blocks" links. Credentials from `JIRA_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN` in the environment |

```bash
export UNDERTEST_GITHUB_TOKEN=...                        # a token that can write issues
export GITHUB_API_URL=https://github.example.com/api/v3  # only for an internal GitHub server
python3 tools/backlog-import/import_to_github.py OWNER/REPO           # dry run
python3 tools/backlog-import/import_to_github.py OWNER/REPO --apply   # create or update issues
```

Re-running updates issues by key rather than duplicating them.
