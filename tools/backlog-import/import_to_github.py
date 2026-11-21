#!/usr/bin/env python3
"""Import plan/backlog-seed.yaml into GitHub Issues, using the GitHub REST API directly.

Needs only Python 3 (standard library) and a token. No GitHub CLI or other tools.

    python3 tools/backlog-import/import_to_github.py OWNER/REPO            # dry run: shows what would happen
    python3 tools/backlog-import/import_to_github.py OWNER/REPO --apply    # creates and updates issues

Settings, from the environment:
    UNDERTEST_GITHUB_TOKEN (or GH_TOKEN, or GITHUB_TOKEN)   a token with permission to write issues in the repo
    GITHUB_API_URL   API address. Default https://api.github.com; for an internal GitHub server use
                     https://<your-host>/api/v3. A proxy is taken from HTTPS_PROXY as usual.

What it does, in order:
  1. Creates labels for item type, phase, owner role, who does it, and horizon (if missing).
  2. Creates one issue per item, or updates it if an issue with the same key already exists.
     The key is stored in a hidden comment in the issue body, so re-running never duplicates.
  3. Closes, as not planned, any issue whose item is no longer in the seed.
  4. Links each item to its parent as a sub-issue.
  5. Adds "blocked by" links between items.
"""
import json
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

SEED = Path(__file__).resolve().parents[2] / "plan" / "backlog-seed.yaml"
KEY_MARKER = "<!-- backlog-key: {} -->"
LABEL_COLOURS = {"type": "5319e7", "phase": "0e8a16", "owner": "1d76db", "done-by": "fbca04", "horizon": "d93f0b"}
PAUSE_SECONDS = 1.5      # GitHub asks for at least a second between requests that create content
RATE_LIMIT_WAIT = 90     # wait this long, then retry, if a rate limit is hit and GitHub gives no time


def parse_seed(path):
    """Strict reader for the seed's simple shape: scalar values are JSON, lists are one JSON value per line."""
    items, current, list_key = [], None, None
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip() or line.startswith("#") or line == "items:":
            continue
        m = re.fullmatch(r"(  - |    )([a-z_]+):(?: (.*))?", line)
        if m:
            if m.group(1) == "  - ":
                current = {}
                items.append(current)
            key, value = m.group(2), m.group(3)
            if value is None:
                current[key], list_key = [], key
            else:
                current[key], list_key = json.loads(value), None
            continue
        m = re.fullmatch(r"      - (.*)", line)
        if m and list_key:
            current[list_key].append(json.loads(m.group(1)))
            continue
        sys.exit(f"{path}:{number}: unexpected line: {line!r}")
    return items


class GitHub:
    def __init__(self, repo):
        self.base = os.environ.get("GITHUB_API_URL", "https://api.github.com").rstrip("/")
        self.repo = repo
        self.token = (os.environ.get("UNDERTEST_GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
                      or os.environ.get("GITHUB_TOKEN"))

    def request(self, method, path, body=None, writes=False, allow_fail=False):
        url = path if path.startswith("http") else f"{self.base}/repos/{self.repo}/{path}"
        data = json.dumps(body).encode() if body is not None else None
        for _ in range(6):
            req = urllib.request.Request(url, data=data, method=method, headers={
                "Accept": "application/vnd.github+json",
                "X-GitHub-Api-Version": "2022-11-28",
                "Authorization": f"Bearer {self.token}",
                "User-Agent": "under-test-backlog-import",
                **({"Content-Type": "application/json"} if data else {}),
            })
            try:
                with urllib.request.urlopen(req) as response:
                    payload = response.read()
                    if writes:
                        time.sleep(PAUSE_SECONDS)
                    return (json.loads(payload) if payload else None), response.headers
            except urllib.error.HTTPError as error:
                text = error.read().decode(errors="replace")
                if error.code in (403, 429) and "rate limit" in text.lower():
                    wait = int(error.headers.get("Retry-After") or RATE_LIMIT_WAIT)
                    print(f"    rate limited; waiting {wait}s before retrying")
                    time.sleep(wait)
                    continue
                if allow_fail:
                    return None, None
                sys.exit(f"{method} {url} failed with {error.code}:\n{text}")
        sys.exit("still rate limited after several retries; run the importer again later")

    def all_pages(self, path):
        url, results = f"{self.base}/repos/{self.repo}/{path}", []
        while url:
            page, headers = self.request("GET", url)
            results += page
            links = headers.get("Link", "") if headers else ""
            m = re.search(r'<([^>]+)>;\s*rel="next"', links)
            url = m.group(1) if m else None
        return results


def labels_for(item):
    return [f"type: {item['type']}", f"phase: {item['phase']}", f"owner: {item['owner_role']}",
            f"done-by: {item['done_by']}"] + ([f"horizon: {item['horizon']}"] if "horizon" in item else [])


def body_for(item, web_base):
    lines = [KEY_MARKER.format(item["key"]), "", "**Done when:**", ""]
    lines += [f"- [ ] {d}" for d in item["done_when"]]
    if "decision_record" in item:
        lines += ["", f"**Decision record:** [{item['title']}]({web_base}/blob/main/{item['decision_record']})"]
    if "notes" in item:
        lines += ["", item["notes"]]
    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    repo, apply = sys.argv[1], "--apply" in sys.argv
    items = parse_seed(SEED)
    print(f"{len(items)} items in {SEED.name}; {'APPLYING to' if apply else 'dry run for'} {repo}")
    if not apply:
        for item in items:
            print(f"  would create or update: {item['title']}")
        print("dry run complete; add --apply to make these changes")
        return

    github = GitHub(repo)
    if not github.token:
        sys.exit("Set UNDERTEST_GITHUB_TOKEN (or GH_TOKEN / GITHUB_TOKEN) to a token that can write issues.")
    web_base = github.base.replace("://api.github.com", "://github.com").replace("/api/v3", "") + f"/{repo}"

    existing = {label["name"] for label in github.all_pages("labels?per_page=100")}
    for label in sorted({label for item in items for label in labels_for(item)} - existing):
        print(f"  label: {label}")
        github.request("POST", "labels", {"name": label, "color": LABEL_COLOURS[label.split(":")[0]]}, writes=True)

    by_key = {}
    for issue in github.all_pages("issues?state=all&per_page=100"):
        if "pull_request" in issue:
            continue
        m = re.search(r"<!-- backlog-key: ([a-z0-9-]+) -->", issue.get("body") or "")
        if m:
            by_key[m.group(1)] = issue

    for item in items:
        payload = {"title": item["title"], "body": body_for(item, web_base), "labels": labels_for(item)}
        if item["key"] in by_key:
            number = by_key[item["key"]]["number"]
            print(f"  update #{number}: {item['title']}")
            by_key[item["key"]], _ = github.request("PATCH", f"issues/{number}", payload, writes=True)
        else:
            print(f"  create: {item['title']}")
            by_key[item["key"]], _ = github.request("POST", "issues", payload, writes=True)

    seed_keys = {item["key"] for item in items}
    for key, issue in by_key.items():
        if key not in seed_keys and issue.get("state") == "open":
            print(f"  close as not planned #{issue['number']}: {issue['title']} (no longer in the seed)")
            github.request("PATCH", f"issues/{issue['number']}", {"state": "closed", "state_reason": "not_planned"},
                           writes=True)

    for item in items:
        issue = by_key[item["key"]]
        if "parent" in item:
            parent = by_key[item["parent"]]
            github.request("POST", f"issues/{parent['number']}/sub_issues", {"sub_issue_id": issue["id"]},
                           writes=True, allow_fail=True)
        for blocker in item.get("blocked_by", []):
            github.request("POST", f"issues/{issue['number']}/dependencies/blocked_by",
                           {"issue_id": by_key[blocker]["id"]}, writes=True, allow_fail=True)
    print("done")


if __name__ == "__main__":
    main()
