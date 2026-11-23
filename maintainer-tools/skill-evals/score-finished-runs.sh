#!/usr/bin/env bash
# Scores the runs of an eval round that have already finished, while the round is still going, with the case's own
# checks (grade.py): claude plugin eval only scores once every run is done.
#
#   maintainer-tools/skill-evals/score-finished-runs.sh <case folder> [<since, as HH:MM, local time>]
#   e.g. maintainer-tools/skill-evals/score-finished-runs.sh .github/evals/find-test-anti-patterns/counts-every-kind 19:27
#
# Each finished run's workspace is kept in /tmp/e-*/ and sealed (mode 000); like run-all.sh, this opens it with chmod
# 700 to read it. Nothing in it is run. A run that loaded the skill is "with", otherwise "without".
set -uo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$root/${1:?usage: score-finished-runs.sh <case folder> [HH:MM]}"
since="${2:-00:00}"
for kept in $(ls -dtr /private/tmp/e-*/ 2>/dev/null); do
  trace="$kept/out/trace.jsonl"
  [ -f "$trace" ] || continue
  when="$(stat -f '%Sm' -t '%H:%M' "$trace")"
  if [[ "$when" < "$since" ]]; then continue; fi
  chmod 700 "$kept" "$kept/sealed" 2>/dev/null || true
  find "$kept/sealed" -type d -exec chmod u+rx {} + 2>/dev/null || true
  workspace="$(find "$kept" -maxdepth 7 -type d -name testing ! -path '*/out/*' 2>/dev/null | head -1)"
  [ -n "$workspace" ] || continue
  workspace="$(dirname "$workspace")"
  arm="without"; grep -q '"name":"Skill"' "$trace" && arm="with"
  last="$(mktemp)"
  python3 -I -c '
import json, sys
text = ""
for line in open(sys.argv[1]):
    try: e = json.loads(line)
    except ValueError: continue
    m = e.get("message") or {}
    if m.get("role") == "assistant" and isinstance(m.get("content"), list):
        t = "".join(c.get("text", "") for c in m["content"] if c.get("type") == "text")
        if t: text = t
print(text)' "$trace" > "$last"
  python3 -I "$root/maintainer-tools/skill-evals/grade.py" "$case_dir" "$workspace" "$last" | python3 -I -c '
import json, sys
checks = json.load(sys.stdin)
failed = [c["name"] for c in checks if not c["passed"]]
print(f"{sys.argv[1]:8} {sys.argv[2]}  score {1 - len(failed) / len(checks):.2f}  failed: {failed or chr(45)}")' "$arm" "$when"
  rm -f "$last"
done
