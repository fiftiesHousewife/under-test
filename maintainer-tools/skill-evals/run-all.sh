#!/usr/bin/env bash
# Runs every skill eval case in .github/evals with claude plugin eval, several runs with the toolkit's skills and as
# many without, and writes the results page docs/skill-evaluations/eval-results.md. Meant to run unattended,
# overnight:
#
#   maintainer-tools/skill-evals/run-all.sh              # every case
#   maintainer-tools/skill-evals/run-all.sh 'choose-*'   # only cases whose name matches
#   RUNS=2 WITHOUT=no maintainer-tools/skill-evals/run-all.sh finds-every-kind
#                                  # a short tuning run: two runs, with the skills only, to compare cost and turns
#   MODEL=haiku RUNS=2 WITHOUT=no maintainer-tools/skill-evals/run-all.sh finds-every-kind
#                                  # the same with a smaller model
#
# Run it in your own terminal, not inside an AI assistant's sandbox: the eval starts its own sessions. It spends
# tokens on your account, or your plan's usage on a Claude subscription; MAX_COST_USD (default 60) is a hard ceiling
# on the cost the eval estimates at API prices. Needs claude and jq. The full results stay in
# .github/evals/results/, which isn't committed. Each run's workspace is kept in the system's temporary folder, so
# its files can be checked against the schemas. Review the page, then push with maintainer-tools/sync/sync.sh.
set -uo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
# run-baseline.sh names the results file itself (OUT_JSON) and writes one page for all cases (NO_PAGE=yes).
json="${OUT_JSON:-$root/.github/evals/results/$stamp.json}"
mkdir -p "$root/.github/evals/results"

options=()
if [ "$#" -gt 0 ]; then options+=(--case "$1"); fi
if [ -n "${RUNS:-}" ]; then options+=(--runs "$RUNS"); fi
if [ "${WITHOUT:-yes}" = "no" ]; then options+=(--ablation none); fi
# Sonnet by default, so results stay comparable from one run to the next; MODEL=default uses Claude Code's own default.
model="${MODEL:-sonnet}"
if [ "$model" != "default" ]; then options+=(--model "$model"); fi

echo "== Running the skill evals with ${model}; full results go to $json"
cd "$root/.github" || exit 1
claude plugin eval . ${options[@]+"${options[@]}"} --scaffold --trust-plugin --allow-tools Bash Write Edit \
  --no-publish --keep-temp --max-cost-usd "${MAX_COST_USD:-60}" --json "$json"
status=$?
# Exit 1 means a case scored below 1.0: a result to record, not a failure of the run.
if [ ! -s "$json" ]; then
  echo "No results were written (exit $status)"
  exit "$status"
fi

# The pattern checks can't tell whether a file matches its schema, so every file a run wrote in testing/ is checked
# against the toolkit's schemas too. --keep-temp keeps each run's workspace; it is found from the run's trace.
workspaces="$json.workspaces.tsv"
: > "$workspaces"
jq -r '.cases[] | .dir as $d | .arms | to_entries[] | .key as $arm | .value | to_entries[] |
  [$d, $arm, (.key | tostring), (.value.tracePath // "")] | @tsv' "$json" |
while IFS=$'\t' read -r dir arm run trace; do
  workspace=""
  if [ -n "$trace" ]; then
    base="$(dirname "$(dirname "$trace")")"
    testing="$(find "$base" -maxdepth 4 -type d -name testing ! -path '*/out/*' 2>/dev/null | head -1)"
    if [ -n "$testing" ]; then workspace="$(dirname "$testing")"; fi
  fi
  printf '%s\t%s\t%s\t%s\n' "$dir" "$arm" "$run" "$workspace" >> "$workspaces"
done
found="$(cut -f4 "$workspaces" | grep -v '^$' | paste -sd: -)"
if [ -n "$found" ]; then
  "$root/gradlew" -q -p "$root" :maintainer-tools:repo-checks:validateSkillOutput \
    -PoutputReport="$json.shape.tsv" -Pworkspaces="$found" || echo "The schema check didn't run"
fi

if [ "${NO_PAGE:-no}" != "yes" ]; then
  "$root/maintainer-tools/skill-evals/write-results-page.sh" "$json"
fi
