#!/usr/bin/env python3
"""Import plan/backlog-seed.yaml into GitHub Issues, using the GitHub CLI (`gh`).

    python3 tools/backlog-import/import_to_github.py OWNER/REPO            # dry run: shows what would happen
    python3 tools/backlog-import/import_to_github.py OWNER/REPO --apply    # creates and updates issues

What it does, in order:
  1. Creates labels for item type, phase, owner role, who does it, and horizon (if missing).
  2. Creates one issue per item, or updates it if an issue with the same key already exists.
     The key is stored in a hidden comment in the issue body, so re-running never duplicates.
  3. Links each item to its parent as a sub-issue.
  4. Adds "blocked by" links between items.

Needs `gh` logged in with access to the repo. Sub-issues and issue dependencies use GitHub's REST API.
Issue types are organisation-level on GitHub, so this importer records the item type as a label.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

SEED = Path(__file__).resolve().parents[2] / "plan" / "backlog-seed.yaml"
KEY_MARKER = "<!-- backlog-key: {} -->"
LABEL_COLOURS = {"type": "5319e7", "phase": "0e8a16", "owner": "1d76db", "done-by": "fbca04", "horizon": "d93f0b"}


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


def gh(*args, input_json=None):
    result = subprocess.run(["gh", *args], input=json.dumps(input_json) if input_json else None,
                            capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(f"gh {' '.join(args)} failed:\n{result.stderr}")
    return json.loads(result.stdout) if result.stdout.strip() else None


def labels_for(item):
    return [f"type: {item['type']}", f"phase: {item['phase']}", f"owner: {item['owner_role']}",
            f"done-by: {item['done_by']}"] + ([f"horizon: {item['horizon']}"] if "horizon" in item else [])


def body_for(item, repo):
    lines = [KEY_MARKER.format(item["key"]), "", "**Done when:**", ""]
    lines += [f"- [ ] {d}" for d in item["done_when"]]
    if "decision_record" in item:
        lines += ["", f"**Decision record:** [{item['title']}](https://github.com/{repo}/blob/main/{item['decision_record']})"]
    if "notes" in item:
        lines += ["", item["notes"]]
    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    repo, apply = sys.argv[1], "--apply" in sys.argv
    items = parse_seed(SEED)
    print(f"{len(items)} items in {SEED.name}; {'APPLYING to' if apply else 'dry run for'} {repo}")

    wanted = sorted({label for item in items for label in labels_for(item)})
    existing_labels = {l["name"] for l in gh("api", f"repos/{repo}/labels", "--paginate")} if apply else set()
    for label in wanted:
        if label not in existing_labels:
            print(f"  label: {label}")
            if apply:
                colour = LABEL_COLOURS[label.split(":")[0]]
                gh("api", f"repos/{repo}/labels", "-X", "POST", "-f", f"name={label}", "-f", f"color={colour}")

    by_key = {}
    if apply:
        for issue in gh("api", f"repos/{repo}/issues?state=all&per_page=100", "--paginate"):
            m = re.search(r"<!-- backlog-key: ([a-z0-9-]+) -->", issue.get("body") or "")
            if m:
                by_key[m.group(1)] = issue

    for item in items:
        payload = {"title": item["title"], "body": body_for(item, repo), "labels": labels_for(item)}
        if item["key"] in by_key:
            print(f"  update #{by_key[item['key']]['number']}: {item['title']}")
            if apply:
                by_key[item["key"]] = gh("api", f"repos/{repo}/issues/{by_key[item['key']]['number']}", "-X", "PATCH",
                                         "--input", "-", input_json=payload)
        else:
            print(f"  create: {item['title']}")
            if apply:
                by_key[item["key"]] = gh("api", f"repos/{repo}/issues", "-X", "POST", "--input", "-", input_json=payload)

    for item in items:
        if not apply:
            continue
        issue = by_key[item["key"]]
        if "parent" in item:
            parent = by_key[item["parent"]]
            subprocess.run(["gh", "api", f"repos/{repo}/issues/{parent['number']}/sub_issues", "-X", "POST",
                            "-F", f"sub_issue_id={issue['id']}"], capture_output=True, text=True)
        for blocker in item.get("blocked_by", []):
            subprocess.run(["gh", "api", f"repos/{repo}/issues/{issue['number']}/dependencies/blocked_by", "-X", "POST",
                            "-F", f"issue_id={by_key[blocker]['id']}"], capture_output=True, text=True)
    print("done" if apply else "dry run complete; add --apply to make these changes")


if __name__ == "__main__":
    main()
