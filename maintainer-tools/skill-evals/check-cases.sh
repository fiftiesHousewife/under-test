#!/usr/bin/env bash
# Checks every skill eval case's set-up before spending usage on it:
#
#   maintainer-tools/skill-evals/check-cases.sh              # every case
#   maintainer-tools/skill-evals/check-cases.sh 'choose-*'   # only cases whose name matches
#
# 1. No file under .github/evals (outside results/) is ignored by git: the eval runs on a copy of the files git sees,
#    so an ignored fixture file is silently missing from every run.
# 2. Each case's set-up script runs from the copy the eval uses (copy-toolkit.sh, cases in evals/), in an empty
#    folder, and succeeds: a path that works only in the repo fails here.
# 3. The workspace it builds names no file in the repo, the copy or the home folder: the eval's sessions can read only
#    their workspace.
#
# Runs nothing the case's runs would, and spends no usage. The measure-a-repo case needs a JDK 11 and the network, as
# in the eval. Exits 1 if any check fails. Run by run-baseline.sh before it starts.
set -uo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
pattern="${1:-*}"
failed=0

ignored="$(cd "$root" && git ls-files -o -i --exclude-standard -- .github/evals | grep -v '^\.github/evals/results/' || true)"
if [ -n "$ignored" ]; then
  echo "== Ignored by git, so missing from the copy the eval runs on (add an exception to .gitignore):"
  echo "$ignored" | sed 's/^/   /'
  failed=1
fi

copy="$("$root/maintainer-tools/skill-evals/copy-toolkit.sh")" || exit 1
for case_file in $(find "$copy/evals" -mindepth 3 -maxdepth 3 -name case.yaml | sort); do
  dir="$(dirname "$case_file")"
  name="$(basename "$dir")"
  # shellcheck disable=SC2254
  case "$name" in $pattern) ;; *) continue ;; esac
  script="$(sed -n 's/^ *scaffold_script: *//p' "$case_file")"
  if [ -z "$script" ]; then
    echo "== $name: no set-up script, nothing to check"
    continue
  fi
  workspace="$(mktemp -d "${TMPDIR:-/tmp}/under-test-case.XXXXXX")"
  if ! out="$(cd "$workspace" && bash "$dir/$script" 2>&1)"; then
    echo "== $name: set-up failed"
    echo "$out" | tail -5 | sed 's/^/   /'
    failed=1
    continue
  fi
  outside="$(grep -rIl -e "$root" -e "$copy" -e "$HOME/" "$workspace" --exclude-dir=.git 2>/dev/null |
    sed "s#^$workspace/##" || true)"
  links="$(find "$workspace" -type l ! -path '*/.git/*' | sed "s#^$workspace/##")"
  if [ -n "$outside$links" ]; then
    echo "== $name: the workspace reaches outside itself, which the eval's sessions can't read"
    if [ -n "$outside" ]; then echo "$outside" | sed 's/^/   names a path outside: /'; fi
    if [ -n "$links" ]; then echo "$links" | sed 's/^/   symbolic link: /'; fi
    failed=1
    continue
  fi
  echo "== $name: set-up works from the copy"
done

if [ "$failed" -ne 0 ]; then
  echo "== Some cases would fail on set-up: fix them before running the evals."
fi
exit "$failed"
