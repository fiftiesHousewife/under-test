#!/usr/bin/env bash
# The baseline run of every skill eval: each case in .github/evals, one at a time, five runs with the toolkit's
# skills and five without, with Sonnet, then one results page, docs/skill-evaluations/eval-results.md, for them all.
# Start it in your own terminal, from anywhere, and leave it:
#
#   maintainer-tools/skill-evals/run-baseline.sh
#
# It goes case by case so a usage limit stops only the cases still to run. Run it again and it carries on with
# those, keeping the cases already done; FRESH=yes starts again from the beginning. RUNS, MODEL and MAX_COST_USD
# (the ceiling for each case, default 15) are passed on to run-all.sh. Its progress is logged to
# .github/evals/results/baseline/run.log. It first checks every case's set-up (check-cases.sh) and stops if one
# fails. After each case it keeps a summary in docs/skill-evaluations/results/ (keep-summary.sh) and copies the runs'
# traces and files into .github/evals/results/baseline/kept/ (keep-traces.sh). Everything else it writes stays in
# .github/evals/results/, which isn't committed, except the results page.
set -uo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
here="$root/maintainer-tools/skill-evals"
out="$root/.github/evals/results/baseline"
if [ "${FRESH:-no}" = "yes" ] && [ -d "$out" ]; then
  mv "$out" "$out.before-$(date -u +%Y%m%dT%H%M%SZ)"
fi
mkdir -p "$out"
log="$out/run.log"
exec > >(tee -a "$log") 2>&1

missing=""
for tool in claude jq git; do
  command -v "$tool" >/dev/null || missing="$missing $tool"
done
if [ -n "$missing" ]; then
  echo "Missing:$missing. Install them and run this again."
  exit 1
fi
jdk11="${EVAL_JDK11_HOME:-$(/usr/libexec/java_home -v 11 2>/dev/null || true)}"
if [ -z "$jdk11" ]; then
  echo "No JDK 11 found: the measure-a-repo case will fail to set up. Set EVAL_JDK11_HOME, or carry on without it."
fi

# A case broken by its set-up would spend usage for nothing, so every case's set-up is tried first.
if ! "$here/check-cases.sh"; then
  echo "Fix the cases above, then run this again."
  exit 1
fi

cases="$(find "$root/.github/evals" -mindepth 3 -maxdepth 3 -name case.yaml ! -path '*/results/*' | sort)"
echo "== $(date -u '+%H:%M') UTC: baseline of $(echo "$cases" | wc -l | tr -d ' ') cases, with ${MODEL:-sonnet}"

for case_file in $cases; do
  name="$(basename "$(dirname "$case_file")")"
  json="$out/$name.json"
  if [ -s "$json" ]; then
    echo "== $name: already done, kept"
    continue
  fi
  echo "== $(date -u '+%H:%M') UTC: $name"
  # The eval wants a results file ending .json, so a case still running writes <case>.part.json.
  part="$out/$name.part.json"
  # A case the eval's sandbox can't run says so in runs-outside-eval.txt, and runs without the eval.
  if [ -f "$(dirname "$case_file")/runs-outside-eval.txt" ]; then
    OUT_JSON="$part" "$here/run-outside-eval.sh" "$name"
  else
    OUT_JSON="$part" NO_PAGE=yes MAX_COST_USD="${MAX_COST_USD:-15}" "$here/run-all.sh" "$name"
  fi
  if [ -s "$part" ] && [ "$(jq '[.cases[].arms[][] | select(.error == null)] | length' "$part")" -gt 0 ]; then
    for extra in workspaces.tsv shape.tsv; do
      if [ -f "$part.$extra" ]; then mv "$part.$extra" "$json.$extra"; fi
    done
    mv "$part" "$json"
    echo "== $name: done"
    # A summary kept in the repo, and the traces and written files copied out of the temporary folder.
    "$here/keep-summary.sh" "$json" || echo "== $name: the summary wasn't kept"
    "$here/keep-traces.sh" "$json" > /dev/null || echo "== $name: the traces weren't kept"
  else
    echo "== $name: no run finished (a usage limit, or a set-up failure: see above). Run this again later."
  fi
done

done_files="$(find "$out" -maxdepth 1 -name '*.json' ! -name '*.part.json' ! -name 'all.json' | sort)"
if [ -z "$done_files" ]; then
  echo "No case finished, so no results page."
  exit 1
fi
all="$out/all.json"
# One results file for every case done: their cases joined, their costs added, the rest from the first.
jq -s '.[0] + {cases: (map(.cases) | add), costUsd: (map(.costUsd) | add)}' $done_files > "$all"
: > "$all.workspaces.tsv"
: > "$all.shape.tsv"
for f in $done_files; do
  if [ -f "$f.workspaces.tsv" ]; then cat "$f.workspaces.tsv" >> "$all.workspaces.tsv"; fi
  if [ -f "$f.shape.tsv" ]; then cat "$f.shape.tsv" >> "$all.shape.tsv"; fi
done
"$here/write-results-page.sh" "$all"

still="$(for case_file in $cases; do n="$(basename "$(dirname "$case_file")")"; [ -s "$out/$n.json" ] || echo "$n"; done)"
if [ -n "$still" ]; then
  echo "== Still to run: $(echo "$still" | tr '\n' ' '). Run this script again when your usage allows."
else
  echo "== Every case done. Review docs/skill-evaluations/eval-results.md, then push with maintainer-tools/sync/sync.sh."
fi
