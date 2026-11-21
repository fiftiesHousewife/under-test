#!/usr/bin/env bash
# Tests the lesson video helpers (lessons/_shared/callout.sh) and the render script (lessons/_shared/render.sh) in a few
# seconds, using a stand-in for VHS, so a broken helper is found before a real recording hangs on it.
# Run from the repository root:  bash lessons/_shared/video-tools/test-video-helpers.sh
set -uo pipefail
cd "$(dirname "$0")/../../.."
FAILURES=0
WORK="$(mktemp -d "${TMPDIR:-/tmp}/video-helpers-test.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

expect() { # expect "<what>" "<text>" "<must contain>"
  if [[ "$2" == *"$3"* ]]; then echo "ok   $1"; else echo "FAIL $1: expected to contain [$3], got [$2]"; FAILURES=$((FAILURES + 1)); fi
}
plain() { sed -E $'s/\x1b\\[[0-9;]*[A-Za-z]//g; s/\r//g'; }

# --- callout.sh -------------------------------------------------------------------------------------------------
source lessons/_shared/callout.sh
expect "callout draws a box round its message" "$(callout 'Five of thirteen' | plain)" "│ Five of thirteen │"
expect "note prints its text" "$(note 'an aside' | plain)" "an aside"

export TYPE_DELAY=0
OUT="$(NOTE_INTERVAL=1 run_with_notes 'sleep 2.5; echo RESULT-LINE' '# first note' '# second note' '# never shown' | plain)"
expect "run_with_notes shows the command as if typed" "$OUT" '$ sleep 2.5; echo RESULT-LINE'
expect "run_with_notes shows notes while the command runs" "$OUT" "# second note"
expect "run_with_notes prints the command's output" "$OUT" "RESULT-LINE"
[[ "$OUT" != *"never shown"* ]] && echo "ok   run_with_notes skips notes once the command has finished" \
  || { echo "FAIL run_with_notes printed a note after the command finished"; FAILURES=$((FAILURES + 1)); }
OUT="$(NOTE_INTERVAL=1 run_with_notes 'echo to-stderr >&2' | plain)"
expect "run_with_notes includes the error stream" "$OUT" "to-stderr"
OUT="$(NOTE_INTERVAL=1 run_with_notes 'read -r line; echo "read-status-$?"' | plain)"
expect "run_with_notes gives the command no terminal input" "$OUT" "read-status-1"

# Inside VHS the helpers run in an interactive shell on a real terminal. There, a background job that reads the
# terminal is stopped by the shell and never finishes, and job messages like "[1] 1234" appear on screen.
in_terminal() { # runs a command in an interactive bash on a pseudo-terminal, as VHS does
  if script --version >/dev/null 2>&1; then script -qec "bash --norc -i -c '$1'" /dev/null
  else script -q /dev/null bash --norc -i -c "$1"; fi
}
if command -v script >/dev/null && [[ "$(in_terminal 'echo TERMINAL-OK' 2>&1)" == *TERMINAL-OK* ]]; then
  OUT="$(in_terminal 'source lessons/_shared/callout.sh; NOTE_INTERVAL=1 TYPE_DELAY=0 run_with_notes "read -r x; echo READ-FINISHED" "# a note"' 2>&1 | plain)"
  expect "run_with_notes finishes in an interactive terminal when the command reads input" "$OUT" "READ-FINISHED"
  [[ "$OUT" != *"Stopped"* && "$OUT" != *"[1]"* ]] && echo "ok   run_with_notes shows no job messages in a terminal" \
    || { echo "FAIL run_with_notes showed job messages: [$OUT]"; FAILURES=$((FAILURES + 1)); }
else
  echo "skip terminal tests: no pseudo-terminal available here (needs the script command and a terminal)"
fi

# Long typed commands wrap over several rows; all of them must be erased.
expect "a short typed command takes one row" "rows $(COLUMNS=80 _typed_rows callout 'short')" "rows 1"
expect "a typed command wider than the terminal takes more rows" "rows $(COLUMNS=20 _typed_rows callout 'abcdefghij')" "rows 2"
ERASES="$(COLUMNS=20 callout 'abcdefghij' | grep -o $'\x1b\\[1A' | wc -l | tr -d ' ')"
expect "callout erases every row its typed command took" "erases $ERASES" "erases 2"

# show: part of a file, numbered, found by part of its name.
printf 'one\ntwo\nthree\nfour\n' >"$WORK/sample.txt"
OUT="$(show "$WORK/sample.txt" 2 3 | plain)"
expect "show names the file" "$OUT" "── sample.txt ──"
expect "show numbers the lines it prints" "$OUT" "  2  two"
[[ "$OUT" != *"four"* ]] && echo "ok   show stops at the last line asked for" \
  || { echo "FAIL show printed past the last line"; FAILURES=$((FAILURES + 1)); }
mkdir -p "$WORK/repo/lessons/x" "$WORK/repo/build-logic" "$WORK/repo/gradle"
printf 'test\n' >"$WORK/repo/lessons/x/CalcStrongTest.java"; printf 'code\n' >"$WORK/repo/lessons/x/Calc.java"
expect "show prefers an exact file name to a partial match" "$(cd "$WORK/repo" && show Calc | plain)" "── Calc.java ──"
expect "show uses a label when given one" "$(show "$WORK/sample.txt" 1 1 'Build settings' | plain)" "── Build settings ──"

# --- render.sh, with a stand-in for VHS ----------------------------------------------------------------------------
# GRADLEW=true stands in for Gradle too, so the test never stops the Gradle process that may be running this build.
mkdir -p "$WORK/bin"
cat >"$WORK/bin/vhs" <<'STANDIN'
#!/usr/bin/env bash
printf 'Output lessons/x/media/x.gif\nHide\nWait+Screen 600s /SETUP-2-DONE/\nShow\nType # A narration line.\n'
printf 'Type 1ms run_with_notes "./gradlew pitest --rerun"\nWait+Screen 300s /Killed/\n'
[ "${STANDIN_FAIL:-}" = 1 ] && { echo "Error: timeout waiting for Killed"; exit 1; }
sleep "${STANDIN_PAUSE:-0}"
printf 'Type 1ms callout x\nCreating lessons/x/media/x.gif...\n'
STANDIN
chmod +x "$WORK/bin/vhs"

OUT="$(GRADLEW=true PATH="$WORK/bin:$PATH" STANDIN_PAUSE=22 lessons/_shared/render.sh mutation-testing --no-open 2>&1)"; STATUS=$?
expect "render reports set-up" "$OUT" "setting up off-camera"
expect "render reports each narration line" "$OUT" "A narration line."
expect "render reports PIT" "$OUT" "running PIT"
expect "render reports a long quiet step" "$OUT" "still working"
expect "render reports callouts" "$OUT" "callout"
expect "render finishes" "$OUT" "done"
expect "render exits 0 on success" "status $STATUS" "status 0"

OUT="$(GRADLEW=true PATH="$WORK/bin:$PATH" STANDIN_FAIL=1 lessons/_shared/render.sh mutation-testing --no-open 2>&1)"; STATUS=$?
expect "render says when it fails" "$OUT" "Rendering failed"
expect "render shows the end of the VHS log on failure" "$OUT" "timeout waiting for Killed"
[ "$STATUS" -ne 0 ] && echo "ok   render exits non-zero on failure" \
  || { echo "FAIL render exited 0 after VHS failed"; FAILURES=$((FAILURES + 1)); }

if [ "$FAILURES" -gt 0 ]; then echo "$FAILURES video helper test(s) failed"; exit 1; fi
echo "All video helper tests passed."
