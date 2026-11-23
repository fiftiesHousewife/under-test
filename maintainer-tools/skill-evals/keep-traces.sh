#!/usr/bin/env bash
# Copies each run's trace and the files it wrote in testing/ out of the system's temporary folder (cleared on restart)
# into .github/evals/results/<folder>/kept/<case>/<arm>-<run>/, which survives a restart but isn't committed:
#
#   maintainer-tools/skill-evals/keep-traces.sh .github/evals/results/baseline/<case>.json
#
# Reads the run's workspaces from <case>.json.workspaces.tsv, made by run-all.sh. Copies only; changes nothing in the
# kept temporary folders.
set -uo pipefail

json="$1"
dest="$(dirname "$json")/kept"
workspaces="$json.workspaces.tsv"
if [ ! -s "$workspaces" ]; then
  echo "No workspaces listed for $json"
  exit 1
fi

while IFS=$'\t' read -r dir arm run workspace; do
  case_name="${dir##*/}"
  to="$dest/$case_name/$arm-$((run + 1))"
  mkdir -p "$to"
  trace="$(jq -r --arg d "$dir" --arg a "$arm" --argjson r "$run" \
    '.cases[] | select(.dir == $d) | .arms[$a][$r].tracePath // empty' "$json")"
  if [ -n "$trace" ] && [ -f "$trace" ]; then cp "$trace" "$to/trace.jsonl"; fi
  if [ -n "$workspace" ] && [ -d "$workspace/testing" ]; then cp -R "$workspace/testing" "$to/"; fi
  echo "$to: $(ls "$to" | tr '\n' ' ')"
done < "$workspaces"
