"""Grades one run of a skill eval case with the case's own regex checks, as claude plugin eval does.

    python3 -I grade.py <case folder> <workspace> <file holding the run's last message>

Prints a JSON list of {"name", "passed"}, one per file in <case folder>/graders/, in name order. Each check's front
matter has type: regex, pattern, match (contains, not_contains or count:N), optional flags (m, i, s) and target
(last_message, or {source: file, path: <path in the workspace>}). A missing target file fails the check. Used by
run-outside-eval.sh for cases the eval can't run.
"""
import json
import re
import sys
from pathlib import Path

FLAGS = {"m": re.MULTILINE, "i": re.IGNORECASE, "s": re.DOTALL}


def value(text):
    text = text.strip()
    if len(text) >= 2 and text[0] == text[-1] == "'":
        return text[1:-1].replace("''", "'")
    if len(text) >= 2 and text[0] == text[-1] == '"':
        return json.loads(text)
    return text


def front_matter(path):
    lines = path.read_text(encoding="utf-8").split("\n")
    if lines[0].strip() != "---":
        raise ValueError(f"{path}: no front matter")
    fields = {}
    for line in lines[1:]:
        if line.strip() == "---":
            return fields
        key, _, rest = line.partition(":")
        fields[key.strip()] = rest.strip()
    raise ValueError(f"{path}: front matter not closed")


def target_text(target, workspace, last_message):
    if target in ("", "last_message"):
        return last_message
    inner = target.strip().lstrip("{").rstrip("}")
    parts = dict(part.split(":", 1) for part in inner.split(","))
    parts = {key.strip(): value(val) for key, val in parts.items()}
    if parts.get("source") != "file":
        raise ValueError(f"unsupported target: {target}")
    path = Path(workspace) / parts["path"]
    return path.read_text(encoding="utf-8", errors="replace") if path.is_file() else None


def passes(fields, workspace, last_message):
    if value(fields.get("type", "")) != "regex":
        return False
    text = target_text(fields.get("target", ""), workspace, last_message)
    if text is None:
        return False
    flags = 0
    for flag in value(fields.get("flags", "")):
        flags |= FLAGS.get(flag, 0)
    found = len(re.findall(value(fields["pattern"]), text, flags))
    match = value(fields.get("match", "contains"))
    if match == "contains":
        return found > 0
    if match == "not_contains":
        return found == 0
    if match.startswith("count:"):
        return found == int(match.split(":", 1)[1])
    return False


def main():
    case, workspace, message_file = sys.argv[1:4]
    last_message = Path(message_file).read_text(encoding="utf-8") if Path(message_file).is_file() else ""
    results = []
    for grader in sorted(Path(case, "graders").glob("*.md")):
        results.append({"name": grader.stem, "passed": passes(front_matter(grader), workspace, last_message)})
    print(json.dumps(results))


if __name__ == "__main__":
    main()
