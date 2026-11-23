#!/usr/bin/env bash
# Keeps a compact summary of one case's eval results in the repo, so results survive after .github/evals/results/
# (which isn't committed) is cleared:
#
#   maintainer-tools/skill-evals/keep-summary.sh .github/evals/results/baseline/<case>.json
#
# Writes docs/skill-evaluations/results/<case>.json: per run, the score, cost, turns, time and failed checks, and the
# schema check's result where run-all.sh made one. Needs jq.
set -euo pipefail

json="$1"
root="$(cd "$(dirname "$0")/../.." && pwd)"
out="$root/docs/skill-evaluations/results"
mkdir -p "$out"
shape="$json.shape.tsv"
workspaces="$json.workspaces.tsv"

# workspace -> problem count, then case/arm/run -> problem count
shapes="{}"
if [ -s "$shape" ] && [ -s "$workspaces" ]; then
  shapes="$(awk -F'\t' 'NR == FNR { n[$1] = $2; next } $4 != "" && ($4 in n) { printf "%s\t%s\t%s\t%s\n", $1, $2, $3, n[$4] }' \
    "$shape" "$workspaces" | jq -R -s 'split("\n") | map(select(length > 0) | split("\t")) |
    map({key: "\(.[0])|\(.[1])|\(.[2])", value: (.[3] | tonumber)}) | from_entries')"
fi

for name in $(jq -r '.cases[].dir | split("/") | last' "$json"); do
  jq --argjson shapes "$shapes" --arg name "$name" '
    def r2: (. * 100 | round) / 100;
    .claudeVersion as $v | .cases[] | select((.dir | split("/") | last) == $name) | .dir as $d |
    {
      case: $name,
      skill: ($d | split("/") | .[-2]),
      claude_code: $v,
      runs_per_arm: (.arms.with | length),
      arms: (.arms | with_entries(.key as $arm | .value |= (to_entries | map({
        run: (.key + 1),
        score: (.value.score | r2),
        cost_usd: ((.value.costUsd // 0) | r2),
        turns: .value.turns,
        seconds: ((.value.durationSeconds // 0) | round),
        failed_checks: [.value.graders[]? | select(.passed == false) | .name],
        schema_problems: $shapes["\($d)|\($arm)|\(.key)"],
        error: .value.error
      }))))
    }' "$json" > "$out/$name.json"
  echo "== Kept $out/$name.json"
done
