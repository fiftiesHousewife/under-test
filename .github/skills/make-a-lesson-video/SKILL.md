---
name: make-a-lesson-video
description: Write, check and render the short terminal video for a lesson (lessons/<id>/media/<id>.tape and its narration), keeping it under ten minutes and making sure the recording never hangs. Use when a lesson needs its video, or a video needs changing or fixing.
---

# Making a lesson video

A lesson video shows one technique working, in the terminal, from a script. It is regenerated from the script, never
edited by hand. The model is `lessons/mutation-testing/media/mutation-testing.tape`.

## Keep it short

- **Ten minutes is the ceiling, not the goal.** Aim for two to five minutes. If a video is heading past ten, it is two
  videos: split it, or move detail into the lesson's README.
- **One idea per video.** For example, "same coverage, different strength" is one idea. A video teaches the idea; the
  README and exercise teach everything around it.
- **Shape:** the problem (one or two narration lines), the weak or "before" state, the result, the fix or "after"
  state, the result, and one closing callout that states the lesson. Nothing else.
- **Every second earns its place.** Pauses after a narration line: 2 to 4 seconds. After a result: about 1.5 seconds,
  then a callout held for 4 to 5 seconds. No pause longer than 5 seconds on camera.
- **Hide everything that isn't the idea:** set-up, downloads, compiling and warm-up run off-camera (`Hide` ... `Show`).
- **Only code, build files and real results on screen.** No `grep`, `sed` or other plumbing. If a tool's output is
  too long to read, make the build print a short, meaningful summary instead (as `mutationSummary` does for PIT), so
  the same output helps people outside the video too.
- **Show files without the command that printed them:** draw code panels and narration off-camera with `show` and
  `note`, which erase their own command line.
- **Slow steps get notes, not silence:** run anything that takes more than a few seconds with `run_with_notes`, which
  shows short notes on what is happening while it works.

## Look

- **Full HD:** `Set Width 1920`, `Set Height 1080`, `Set FontSize 20`. Smaller sizes look blurry when played full screen.
- **Colours carry meaning:** narration (`note`) in cyan, file headers (`show`) in magenta, callouts in a yellow box,
  code and build output in the terminal's normal colour.
- **Space separates kinds of text:** `show` and `callout` start with a blank line, so captions, code and results never
  run together.
- **Each scene fits on one screen** (about 36 rows by 150 columns at this size). Keep build output to lines that fit.

## Write the script

1. Copy the model script and keep its house style: `Require` lines, the `Set` block, `Env LESSON "<id>"`, then
   `Source lessons/_shared/setup.tape`.
2. Narration appears as `note` lines drawn off-camera; keep each under one terminal row.
3. Code panels: `show <file or part of its name> <first line> <last line> [label]`, drawn off-camera. Start below the
   `package` line, and label build files by what they are, so long package and organisation names stay off screen.
4. Draw callouts off-camera: `Hide`, ``Type@1ms `callout "..."` ``, `Enter`, `Show`.
5. Mark each scene with a comment line `# ---- Scene N: title ----`, and write the narration file
   (`media/<id>.narration.md`) as a numbered list with **one item per scene**. Captions and voiceover come from it.
6. Run slow commands and every `Wait` off-camera (`Hide`, command, `Wait+Screen`, `Show`), so the command and its result
   appear together. Then the video's timing depends only on its pauses, and captions and voice can be timed exactly.

## Rules that stop a recording from hanging

Each of these cost a failed render once. The video checks in `./gradlew check` catch the first four.

| Rule | Why |
|---|---|
| Every `Wait` is `Wait+Screen` with a pattern | A plain `Wait` reads only the last line, which by then is usually the next prompt |
| A `Wait` pattern must not match text typed before it | The typed command is on screen too, so the wait ends at once (compute the marker, e.g. `SETUP-$((1+1))-DONE`) |
| A task whose output you wait for always runs (`outputs.upToDateWhen { false }`, or `--rerun`) | A task skipped as up to date prints nothing, so the recording waits for output that never comes |
| With `-q`, wait only for output the build prints at quiet level (as `mutationSummary` does) | Gradle's quiet mode hides normal task output |
| Slow commands go through `run_with_notes` | It runs them with no terminal input; a background job that reads the terminal is stopped by the shell |
| Don't run other Gradle builds in the repo while rendering | The recording can join a Gradle background process started elsewhere; `render.sh` stops them before it starts |
| Each scene fits on one screen; clear off-camera between scenes (`Hide`, `Type "clear"`, `Enter`, `Show`) | `Wait+Screen` can't see text printed after the screen has scrolled |
| Paths in `Output` and `Screenshot` are relative | VHS rejects paths that start with `/` |

## Captions

`./gradlew :lessons:video-tools:buildLessonCaptions -Plesson=<id>` writes `<id>.vtt` and `<id>.srt` next to the script.
It times each scene from the script's pauses and splits its narration into short cues. It fails if a `Wait` is on
camera or if the narration has a different number of items from the script's scenes.

## Check, render, look

1. `./gradlew :lessons:video-tools:check` checks the script and the shared helpers.
2. `lessons/_shared/render.sh <id>` renders it, with timed progress and a heartbeat during slow steps. On failure it
   shows the end of the VHS log.
3. If a render stalls, don't guess: copy the script, replace the stuck `Wait` with `Sleep 60s`, render that, and look at
   the last frame (`ffmpeg -sseof -0.1 -i <gif> -frames:v 1 frame.png`).
4. Watch the whole video once before calling it done. Check its length against the ten-minute ceiling.

## Words
Follow `GLOSSARY.md`. Narration and callouts are plain English: say "planted bugs", not "mutants", unless the lesson
has just explained the term.
