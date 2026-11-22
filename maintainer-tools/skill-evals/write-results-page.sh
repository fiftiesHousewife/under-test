#!/usr/bin/env bash
# Turns one claude plugin eval result file into docs/skill-evaluations/eval-results.md:
#
#   maintainer-tools/skill-evals/write-results-page.sh .github/evals/results/<run>.json [page]
#
# run-all.sh calls it after each run of the evals. Needs jq.
set -euo pipefail

json="$1"
root="$(cd "$(dirname "$0")/../.." && pwd)"
page="${2:-$root/docs/skill-evaluations/eval-results.md}"

commit="$(git -C "$root" rev-parse --short HEAD)"
dirty=""
if [ -n "$(git -C "$root" status --porcelain -- .github/skills .github/evals)" ]; then
  dirty=" (with uncommitted changes to the skills or the cases)"
fi

# Files in the right shape: from run-all.sh's schema check, when it ran. One line per case and arm: ok and checked.
workspaces="$json.workspaces.tsv"
shape="$json.shape.tsv"
shapes=""
shape_problems=""
if [ -s "$workspaces" ] && [ -s "$shape" ]; then
  shapes="$(awk -F'\t' 'NR == FNR { n[$1] = $2; next }
    $4 != "" && ($4 in n) { key = $1 "\t" $2; checked[key]++; if (n[$4] == 0) ok[key]++ }
    END { for (k in checked) print k "\t" (ok[k] + 0) "\t" checked[k] }' "$shape" "$workspaces")"
  shape_problems="$(awk -F'\t' 'NR == FNR { if ($2 > 0) p[$1] = $3; next }
    $2 == "with" && ($4 in p) { split($1, d, "/"); print "* " d[length(d) - 1] " / `" d[length(d)] "`, run " ($3 + 1) ": " p[$4] }' \
    "$shape" "$workspaces")"
fi

rows="$(jq -r '
  def mean(f): if length == 0 then 0 else (map(f) | add) / length end;
  def r2: (. * 100 | round) / 100;
  .cases[] |
  (.dir | split("/")) as $p |
  (.arms.with // []) as $w | (.arms.without // []) as $o |
  "\(.dir)\t| \($p[-2]) | `\($p[-1])` | \($w | length) | \($w | mean(.score) | r2) (\($w | map(.score) | min // 0 | r2)) | \($o | mean(.score) | r2) | $\($w | mean(.costUsd) | r2) / $\($o | mean(.costUsd) | r2) | \($w | mean(.turns) | round) / \($o | mean(.turns) | round) | \($w | mean(.durationSeconds) | round) s / \($o | mean(.durationSeconds) | round) s |"
' "$json" | while IFS=$'\t' read -r dir row; do
  w="$(printf '%s\n' "$shapes" | awk -F'\t' -v d="$dir" '$1 == d && $2 == "with" { print $3 " of " $4 }')"
  o="$(printf '%s\n' "$shapes" | awk -F'\t' -v d="$dir" '$1 == d && $2 == "without" { print $3 " of " $4 }')"
  echo "$row ${w:-not checked} / ${o:-not checked} |"
done)"

failed="$(jq -r '
  .cases[] | (.dir | split("/")) as $p |
  [.arms.with[]? | .graders[]? | select(.passed == false) | .name] | group_by(.) | .[] |
  "* \($p[-2]) / `\($p[-1])`: `\(.[0])`, in \(length) run(s)"
' "$json")"

errors="$(jq -r '
  .cases[] | (.dir | split("/")) as $p | .arms | to_entries[] | .key as $arm | .value[] |
  select(.error != null) | "* `\($p[-1])`, \($arm): \(.error)"
' "$json")"

{
  echo "# Skill eval results"
  echo
  echo "Made by [run-all.sh](../../maintainer-tools/skill-evals/run-all.sh) from the cases in"
  echo "[.github/evals/](../../.github/evals/README.md), at toolkit commit \`$commit\`$dirty, with Claude Code"
  echo "$(jq -r '.claudeVersion' "$json"), model ${MODEL:-sonnet}. Each case ran several times with the toolkit's skills and as many times"
  echo "without them, each run in a fresh session. A run's score is the share of its checks passed; a case passes"
  echo "when every run with the skills scores 1. Every file a run wrote in \`testing/\` is also checked against"
  echo "the toolkit's schemas."
  echo
  echo "| Skill | Case | Runs | With: mean score (lowest) | Without: mean score | Mean cost per run, with / without | Mean turns, with / without | Mean time, with / without | Files in the right shape, with / without |"
  echo "|---|---|---|---|---|---|---|---|---|"
  echo "$rows"
  echo
  echo "## Checks that failed with the skills"
  echo
  if [ -n "$failed" ]; then echo "$failed"; else echo "None."; fi
  if [ -n "$shape_problems" ]; then
    echo
    echo "## Files in the wrong shape, with the skills"
    echo
    echo "The first problem in each run whose files don't match the toolkit's schemas."
    echo
    echo "$shape_problems"
  fi
  if [ -n "$errors" ]; then
    echo
    echo "## Runs that didn't start or finish"
    echo
    echo "$errors"
  fi
  echo
  echo "Total cost of this run of the evals: \$$(jq -r '.costUsd * 100 | round / 100' "$json")."
} > "$page"

echo "== Wrote $page"
