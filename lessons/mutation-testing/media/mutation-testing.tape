# Terminal video for the mutation testing lesson. Render from the repository root:
#   vhs lessons/mutation-testing/media/mutation-testing.tape
# VHS: https://github.com/charmbracelet/vhs (MIT licence). Videos are regenerated from this script, never edited by hand.

Output lessons/mutation-testing/media/mutation-testing.gif
Output lessons/mutation-testing/media/mutation-testing.mp4

# Fail early, with a clear message, if a needed program is missing.
Require java
Require git
Require grep

# House style: keep these the same in every lesson's script.
# Narration lines are typed as shell comments; callouts are drawn off-camera with lessons/_shared/callout.sh.
Set Shell "bash"
Set FontSize 20
Set Width 1280
Set Height 720
Set Padding 24
Set Theme "Builtin Dark"
Set TypingSpeed 40ms
Set WindowBar Colorful
Set CursorBlink false

Env LESSON "mutation-testing"
Source lessons/_shared/setup.tape

Type "# Two test suites. Both run every line of DiscountCalculator: 100% line coverage."
Enter
Sleep 2s
Type "# PIT plants 13 small bugs, one at a time, and checks whether the tests notice."
Enter
Sleep 2.5s

Type "# A weak test: it passes for ANY positive discount."
Enter
Type "grep -n --color=always -A1 'Weak:' lessons/mutation-testing/example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorWeakTest.java | head -2"
Enter
Sleep 3.5s

Type@70ms "./gradlew -q :lessons:mutation-testing:pitest -Psuite=weak 2>/dev/null | grep --color=always 'Killed [0-9]* ([0-9]*%)'"
Enter
Wait@300s /Killed \d+ \(\d+%\)/
Sleep 1.5s
Hide
Type@1ms "callout 'Only 5 of 13 planted bugs caught - despite 100% line coverage'"
Enter
Show
Sleep 4s

Type "# The strong suite checks exact values on both sides of every boundary:"
Enter
Type "grep -n --color=always -A3 'assertAll(' lessons/mutation-testing/example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorStrongTest.java | head -4"
Enter
Sleep 4s

Type@70ms "./gradlew -q :lessons:mutation-testing:pitest 2>/dev/null | grep --color=always 'Killed [0-9]* ([0-9]*%)'"
Enter
Wait@300s /Killed 13 \(100%\)/
Sleep 1.5s
Hide
Type@1ms "callout 'All 13 caught. Coverage said the suites were equal; mutation testing shows they are not.'"
Enter
Show
Sleep 5s
