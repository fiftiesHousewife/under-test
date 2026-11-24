#!/bin/bash
# For toolkit maintainers: checks the toolkit installs as an APM package the way an adopting repo gets it.
#
#   maintainer-tools/apm-package/check-install.sh [commit]   (default HEAD)
#
# Clones the commit (tracked files only, as a tag install gets them), installs it into an empty project with
# `apm install`, then checks that exactly the skills in .apm/skills/ arrive, that no maintainer-only skill or
# development dependency does, and that every toolkit file each installed skill links to is found from the copy, as
# the skill's "Where the toolkit's files are" paragraph says. Needs git, python3 and apm; no network.
set -euo pipefail
toolkit="$(cd "$(dirname "$0")/../.." && pwd)"
commit="${1:-HEAD}"
work="$(mktemp -d "${TMPDIR:-/tmp}/apm-check.XXXXXX")"
trap 'rm -rf "$work"' EXIT
git clone -q "$toolkit" "$work/toolkit"
git -C "$work/toolkit" checkout -q "$commit"
mkdir -p "$work/project" "$work/home"
cd "$work/project"
git init -q
HOME="$work/home" apm install "$work/toolkit" --target claude > "$work/install.log" 2>&1 || { cat "$work/install.log"; exit 1; }
python3 -I - "$work/toolkit" "$work/project" <<'PY'
import os, re, subprocess, sys
toolkit, project = sys.argv[1], sys.argv[2]
expected = sorted(os.listdir(os.path.join(toolkit, ".apm", "skills")))
installed = sorted(os.listdir(os.path.join(project, ".claude", "skills")))
problems = []
if installed != expected:
    problems.append(f"installed skills {installed}, expected {expected}")
for skill in installed:
    text = open(os.path.join(project, ".claude", "skills", skill, "SKILL.md")).read()
    if "Where the toolkit's files are" not in text:
        problems.append(f"{skill}: no 'Where the toolkit's files are' paragraph")
    found = subprocess.run(["find", "apm_modules", "-path", f"*/.github/skills/{skill}/SKILL.md"],
                           cwd=project, capture_output=True, text=True).stdout.split()
    if not found:
        problems.append(f"{skill}: its copy in apm_modules isn't found")
        continue
    root = os.path.normpath(os.path.join(project, os.path.dirname(found[0]), "..", "..", ".."))
    for link in sorted(set(re.findall(r"\]\(\.\./\.\./\.\./([^)#\s]+)", text))):
        if not os.path.exists(os.path.join(root, link)):
            problems.append(f"{skill}: links to {link}, missing from the installed toolkit")
for problem in problems:
    print("PROBLEM", problem)
print(f"{len(installed)} skills installed; {len(problems)} problems")
sys.exit(1 if problems else 0)
PY
