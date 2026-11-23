#!/usr/bin/env bash
# Runs one skill eval case without claude plugin eval, for a case the eval's sandbox can't run: measure-a-repo's
# measures-five-runs, whose Gradle build needs local ports, which the eval's sessions may not bind, and settings no
# eval case can give (see docs/skill-evaluations/baseline-report.md). Start it in your own terminal:
#
#   maintainer-tools/skill-evals/run-outside-eval.sh measures-five-runs
#   RUNS=2 WITHOUT=no maintainer-tools/skill-evals/run-outside-eval.sh measures-five-runs   # a short tuning run
#
# It does what the eval does, with the case's own files: a clean copy of the toolkit (copy-toolkit.sh); for each run a
# fresh workspace set up by the case's scaffold.sh; the case's prompt run with `claude -p`, with the copy loaded as a
# plugin, or for the runs without the skills, without it; then the case's own checks (grade.py) and the schema check.
# Both kinds of run load only project settings (--setting-sources project; the workspace has none), so your own
# settings, installed plugins and hooks are left out of both. (--safe-mode would also leave out the toolkit's skills.)
# Each run's Bash commands stay in Claude Code's sandbox, allowed only what the build needs: binding local ports, and
# reaching Maven Central and the Gradle plugin portal for the build's dependencies. Every run of the repo's code is
# still under the airgap agent, as the prompt says.
#
# Writes the eval's own results format, so keep-summary.sh, keep-traces.sh and write-results-page.sh read it:
# OUT_JSON, default .github/evals/results/<time>-<case>.json, with .workspaces.tsv and .shape.tsv beside it, and each
# run's trace in <OUT_JSON without .json>.traces/. RUNS defaults to the case's runs, MODEL to sonnet. Needs claude, jq,
# python3 and a JDK 11 (found by /usr/libexec/java_home -v 11, or named by EVAL_JDK11_HOME). Spends your usage.
set -uo pipefail

name="${1:?Name the case, for example measures-five-runs}"
root="$(cd "$(dirname "$0")/../.." && pwd)"
here="$root/maintainer-tools/skill-evals"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
json="${OUT_JSON:-$root/.github/evals/results/$stamp-$name.json}"
traces="${json%.json}.traces"
mkdir -p "$(dirname "$json")" "$traces"

case_dir="$(find "$root/.github/evals" -mindepth 2 -maxdepth 2 -type d -name "$name" ! -path '*/results/*' | head -1)"
if [ -z "$case_dir" ]; then
  echo "No case named $name in .github/evals"
  exit 1
fi
skill="$(basename "$(dirname "$case_dir")")"
for tool in claude jq python3; do
  command -v "$tool" >/dev/null || { echo "Missing: $tool"; exit 1; }
done
jdk11="${EVAL_JDK11_HOME:-$(/usr/libexec/java_home -v 11 2>/dev/null || true)}"
if [ -z "$jdk11" ] || [ ! -x "$jdk11/bin/java" ]; then
  echo "No JDK 11 found: set EVAL_JDK11_HOME"
  exit 1
fi
export EVAL_JDK11_HOME="$jdk11"

if ! "$here/check-cases.sh" "$name"; then
  exit 1
fi
copy="$("$here/copy-toolkit.sh")" || exit 1
copied_case="$copy/evals/$skill/$name"

# The prompt's front matter: runs, max_turns, timeout_seconds, allowed_tools; the prompt is the text after it.
prompt_file="$copied_case/prompt.md"
field() { awk -v k="$1" 'NR > 1 && /^---/ { exit } NR > 1 { split($0, a, ":"); if (a[1] == k) { sub(/^[^:]*:[ \t]*/, ""); print } }' "$prompt_file"; }
prompt="$(awk 'NR == 1 && /^---/ { inside = 1; next } inside && /^---/ { inside = 0; next } !inside' "$prompt_file")"
runs="${RUNS:-$(field runs)}"
runs="${runs:-5}"
timeout_seconds="$(field timeout_seconds)"
timeout_seconds="${timeout_seconds:-1800}"
tools="$(field allowed_tools | tr -d '[]' | tr ',' ' ')"
tools="${tools:-Read Glob Grep Write Edit Bash Skill}"
model="${MODEL:-sonnet}"
model_option=()
if [ "$model" != "default" ]; then model_option=(--model "$model"); fi

# Claude Code's sandbox for each run's Bash commands, with only what a Gradle build needs added.
settings='{"sandbox": {"enabled": true, "autoAllowBashIfSandboxed": true,
  "network": {"allowLocalBinding": true,
    "allowedDomains": ["repo.maven.apache.org", "repo1.maven.org", "plugins.gradle.org", "plugins-artifacts.gradle.org"]}}}'

# A case whose build can't start even in that sandbox (Gradle 6.9 fails at start-up with "Operation not permitted")
# says `sandbox: off` in its runs-outside-eval.txt. Its runs' Bash commands then run without the sandbox: each run is
# still a fresh temporary workspace with only the case's tools, and the repo's tests still run under the airgap agent,
# but the session's shell can read whatever you can.
marker="$case_dir/runs-outside-eval.txt"
if [ -f "$marker" ] && grep -q '^sandbox: off$' "$marker"; then
  settings='{"sandbox": {"enabled": false}}'
  echo "== $name: its runs' commands run without Claude Code's sandbox, as its runs-outside-eval.txt says"
fi

arms="with without"
if [ "${WITHOUT:-yes}" = "no" ]; then arms="with"; fi
workspaces="$json.workspaces.tsv"
: > "$workspaces"
results="$(mktemp "${TMPDIR:-/tmp}/under-test-results.XXXXXX")"

run_one() {
  arm="$1"
  run="$2"
  workspace="$(mktemp -d "${TMPDIR:-/tmp}/under-test-run.XXXXXX")"
  trace="$traces/$arm-$((run + 1)).jsonl"
  if ! (cd "$workspace" && bash "$copied_case/scaffold.sh" > "$workspace.scaffold.log" 2>&1); then
    jq -n --arg e "set-up failed: $(tail -3 "$workspace.scaffold.log")" '{score: 0, error: $e, graders: []}'
    return
  fi
  plugin=()
  if [ "$arm" = "with" ]; then plugin=(--plugin-dir "$copy"); fi
  # The sandbox sends the session's network through a proxy named in HTTPS_PROXY, which Java ignores, so Gradle reads
  # it from there into its own settings, in the run's Gradle home outside the repo. Nothing is written with the
  # proxy's password in it.
  mkdir -p "$workspace/.gradle-home/init.d"
  cat > "$workspace/.gradle-home/init.d/use-the-sandbox-proxy.gradle" <<'GRADLE'
def proxy = System.getenv('HTTPS_PROXY') ?: System.getenv('https_proxy')
if (proxy) {
    def uri = new URI(proxy)
    ['http', 'https'].each { scheme ->
        System.setProperty("${scheme}.proxyHost", uri.host)
        System.setProperty("${scheme}.proxyPort", String.valueOf(uri.port))
        if (uri.userInfo) {
            def (user, password) = uri.userInfo.split(':', 2) as List
            System.setProperty("${scheme}.proxyUser", URLDecoder.decode(user, 'UTF-8'))
            System.setProperty("${scheme}.proxyPassword", URLDecoder.decode(password ?: '', 'UTF-8'))
        }
    }
    System.setProperty('http.nonProxyHosts', 'localhost|127.0.0.1')
}
GRADLE
  # The run's own Gradle home and JDK, inside its workspace, the same for both kinds of run.
  (cd "$workspace" && JAVA_HOME="$jdk11" PATH="$jdk11/bin:$PATH" GRADLE_USER_HOME="$workspace/.gradle-home" \
    claude -p "$prompt" --setting-sources project ${plugin[@]+"${plugin[@]}"} ${model_option[@]+"${model_option[@]}"} \
    --settings "$settings" --allowedTools $tools --permission-mode dontAsk --no-session-persistence \
    --output-format stream-json --verbose > "$trace" 2> "$trace.err") &
  pid=$!
  # The watchdog's output goes nowhere: otherwise its sleep holds this function's output open, and the caller waits
  # out the whole timeout.
  ( sleep "$timeout_seconds" && kill "$pid" ) > /dev/null 2>&1 &
  watchdog=$!
  wait "$pid"
  kill "$watchdog" 2>/dev/null
  wait "$watchdog" 2>/dev/null
  result="$(grep '"type":"result"' "$trace" | tail -1)"
  printf '%s' "$(printf '%s' "$result" | jq -r '.result // ""' 2>/dev/null)" > "$workspace.last-message.txt"
  graders="$(python3 -I "$here/grade.py" "$copied_case" "$workspace" "$workspace.last-message.txt")"
  printf '%s\t%s\t%s\t%s\n' "$case_dir" "$arm" "$run" "$workspace" >> "$workspaces"
  jq -n --argjson g "$graders" --argjson r "${result:-null}" --arg t "$trace" '{
    score: (if ($g | length) == 0 then 0 else ([$g[] | select(.passed)] | length) / ($g | length) end),
    turns: ($r.num_turns // null), costUsd: ($r.total_cost_usd // null),
    durationSeconds: (if $r.duration_ms then $r.duration_ms / 1000 else null end),
    graders: $g, tracePath: $t,
    error: (if $r == null then "no result: timed out or failed to start" elif $r.is_error then ($r.result // "error") else null end)
  }'
}

echo "== $(date -u '+%H:%M') UTC: $name outside the eval, $runs run(s) per arm ($arms), with $model"
for arm in $arms; do
  for run in $(seq 0 $((runs - 1))); do
    echo "== $arm, run $((run + 1))"
    run_one "$arm" "$run" | jq -c --arg a "$arm" '{arm: $a, result: .}' >> "$results"
    jq -r 'select(.arm) | "   score \(.result.score * 100 | round / 100), \(.result.turns // "?") turns, $\(.result.costUsd // 0 | . * 100 | round / 100)\(if .result.error then ", " + .result.error else "" end)"' <(tail -1 "$results")
  done
done

jq -s --arg dir "$case_dir" --arg v "$(claude --version 2>/dev/null)" '{
  claudeVersion: $v, runner: "run-outside-eval.sh",
  costUsd: (map(.result.costUsd // 0) | add),
  cases: [{dir: $dir, arms: (group_by(.arm) | map({key: .[0].arm, value: map(.result)}) | from_entries)}]
}' "$results" > "$json"
echo "== Wrote $json"

found="$(cut -f4 "$workspaces" | grep -v '^$' | paste -sd: -)"
if [ -n "$found" ]; then
  "$root/gradlew" -q -p "$root" :maintainer-tools:repo-checks:validateSkillOutput \
    -PoutputReport="$json.shape.tsv" -Pworkspaces="$found" || echo "The schema check didn't run"
fi
echo "== To keep it: $here/keep-summary.sh $json; $here/keep-traces.sh $json"
