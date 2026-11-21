#!/usr/bin/env bash
# Render one lesson's terminal video, showing brief progress instead of VHS's full log.
#   lessons/_shared/render.sh mutation-testing          # renders and opens the GIF
#   lessons/_shared/render.sh mutation-testing --no-open
# Progress shows each stage and narration line with the elapsed time, and says when a step is taking a while. The full
# VHS log is kept in a temporary file and shown (last lines) only if rendering fails.
#
# VHS runs in the foreground: run as a background job of this script, its recording inherited background-job signal and
# input handling, and the second PIT run never finished on screen. Only the progress display and heartbeat run in the
# background.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"
LESSON="${1:?usage: lessons/_shared/render.sh <lesson-id> [--no-open]}"
TAPE="lessons/$LESSON/media/$LESSON.tape"
LOG="${TMPDIR:-/tmp}/vhs-$LESSON-$$"
RAW="$LOG.raw"
GRADLEW="${GRADLEW:-./gradlew}" # tests replace Gradle with a stand-in
command -v vhs >/dev/null || { echo "VHS is not installed (brew install vhs)" >&2; exit 1; }
START=$SECONDS

say() { printf '[%3ss] %s\n' "$((SECONDS - START))" "$1"; }

progress() {
  local set_up=0 line
  while IFS= read -r line; do
    case "$line" in
      Hide*) [ "$set_up" = 0 ] && say "setting up off-camera (Gradle, plugins, compiling)" ;;
      "Type 1ms callout "*|"Type callout "*) say "  callout" ;;
      Show*) [ "$set_up" = 0 ] && say "recording"; set_up=1 ;;
      "Type # "*) [ "$set_up" = 1 ] && say "  ${line#Type # }" ;;
      Type*run_with_notes*pitest*|Type*./gradlew*pitest*) say "  running PIT (narrated while it works)" ;;
      Wait*) [ "$set_up" = 1 ] && say "  waiting for the result" ;;
      Output*) say "will write ${line##* }" ;;
      *"Creating "*) say "writing ${line##* }" ;;
    esac
  done
}

# Says the render is still working whenever VHS has printed nothing for 20 seconds.
heartbeat() {
  local last=0 quiet=0 size
  while sleep 1; do
    size=$(wc -c <"$RAW")
    if [ "$size" = "$last" ]; then quiet=$((quiet + 1)); else quiet=0 last=$size; fi
    if [ "$quiet" -gt 0 ] && [ $((quiet % 20)) = 0 ]; then say "    ...still working (${quiet}s since the last step)"; fi
  done
}

echo "Rendering $LESSON"
# Start with no Gradle background processes, so the recording never joins one started elsewhere (for example inside a
# sandbox, where PIT's helper processes cannot connect). Don't run other Gradle builds in this repo while rendering.
"$GRADLEW" --stop >/dev/null 2>&1 || true

: >"$RAW"
rm -f "$LOG.fifo" && mkfifo "$LOG.fifo"
progress <"$LOG.fifo" &
PROGRESS_PID=$!
tail -n +1 -f "$RAW" >"$LOG.fifo" &
TAIL_PID=$!
heartbeat &
HEARTBEAT_PID=$!

vhs "$TAPE" >"$RAW" 2>&1
STATUS=$?

kill "$HEARTBEAT_PID" 2>/dev/null
sleep 1
kill "$TAIL_PID" 2>/dev/null
wait "$PROGRESS_PID" 2>/dev/null
rm -f "$LOG.fifo"

if [ "$STATUS" -ne 0 ]; then
  echo "Rendering failed. Last lines of the VHS log ($RAW):" >&2
  tail -20 "$RAW" >&2
  exit "$STATUS"
fi
say "done"
ls -1 "lessons/$LESSON/media/$LESSON".{gif,mp4} 2>/dev/null | sed 's/^/  /'
[ "${2:-}" = "--no-open" ] || open "lessons/$LESSON/media/$LESSON.gif"
