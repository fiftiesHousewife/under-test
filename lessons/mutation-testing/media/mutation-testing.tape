# Terminal video for the mutation testing lesson. Render from the repository root with:
#   lessons/_shared/render.sh mutation-testing
# VHS: https://github.com/charmbracelet/vhs (MIT licence). Videos are regenerated from this script, never edited by hand.
# Follows the make-a-lesson-video skill: one idea, short, only code, build files and real results on screen.

Output lessons/mutation-testing/media/mutation-testing.gif
Output lessons/mutation-testing/media/mutation-testing.mp4

# Fail early, with a clear message, if a needed program is missing.
Require java
Require git

# House style: keep these the same in every lesson's script.
Set Shell "bash"
Set FontSize 20
Set Width 1920
Set Height 1080
Set Padding 24
Set Theme "Builtin Dark"
Set TypingSpeed 40ms
Set WindowBar Colorful
Set CursorBlink false

Env LESSON "mutation-testing"
Source lessons/_shared/setup.tape

# ---- Scene 1: why ----
Hide
Type@1ms `note "Mutation testing: do your tests CHECK the code they run, or only run it?"`
Enter
Type@1ms `note "Line coverage counts the lines a test ran. It cannot tell whether any test checked the result."`
Enter
Type@1ms `note "PIT plants one small bug at a time (a mutation), reruns the tests, and counts the bugs they catch."`
Enter
Show
Sleep 8s

# ---- Scene 2: the build ----
Hide
Type "clear"
Enter
Type@1ms `note "The build: one Gradle plugin, applied to every repo by the toolkit's build conventions."`
Enter
Type@1ms `show java-conventions 31 31 "build conventions: plugins"`
Enter
Type@1ms `show java-conventions 271 279 "build conventions: PIT settings"`
Enter
Type@1ms `show libs.versions.toml 19 20 "gradle/libs.versions.toml"`
Enter
Type@1ms `note "This lesson adds one switch, to choose which of its two test suites PIT uses:"`
Enter
Type@1ms `show lessons/mutation-testing/example/build.gradle.kts 10 19 "lesson build file"`
Enter
Show
Sleep 12s

# ---- Scene 3: the code under test ----
Hide
Type "clear"
Enter
Type@1ms `note "The code under test: a discount at 50 and at 100, plus 2% more for loyal customers."`
Enter
Type@1ms `show DiscountCalculator 17 39`
Enter
Show
Sleep 9s

# ---- Scene 4: the weak tests ----
Hide
Type "clear"
Enter
Type@1ms `note "The weak tests. Every line of the calculator runs, so line coverage is 100%."`
Enter
Type@1ms `note "Each comment says what the test fails to check."`
Enter
Type@1ms `show DiscountCalculatorWeakTest 18 39`
Enter
Show
Sleep 12s

# ---- Scene 5: PIT on the weak tests ----
# PIT runs off-camera; its command and result appear together, so the video's timing depends only on its pauses.
Hide
Type "clear"
Enter
Type@1ms `note "Run PIT against the weak tests. For every planted bug it shows which tests ran, and whether one failed."`
Enter
Type "./gradlew -q :lessons:mutation-testing:pitest -Psuite=weak"
Enter
Wait+Screen@300s /Result: the tests caught \d+ of \d+/
Show
Sleep 9s
Hide
Type@1ms `callout "Line 24: with >= 50 changed to > 50, an order of exactly 50 loses its discount. No test tries 50."`
Enter
Show
Sleep 7s

# ---- Scene 6: the strong tests ----
Hide
Type "clear"
Enter
Type@1ms `note "The strong tests check both sides of every boundary, with exact values."`
Enter
Type@1ms `show DiscountCalculatorStrongTest 18 40`
Enter
Show
Sleep 11s

# ---- Scene 7: PIT on the strong tests ----
Hide
Type "clear"
Enter
Type@1ms `note "Run PIT against the strong tests:"`
Enter
Type "./gradlew -q :lessons:mutation-testing:pitest"
Enter
Wait+Screen@300s /Result: the tests caught 13 of 13/
Show
Sleep 7s
Hide
Type@1ms `callout "Same 100% line coverage. Only mutation testing shows which tests catch bugs."`
Enter
Show
Sleep 6s
