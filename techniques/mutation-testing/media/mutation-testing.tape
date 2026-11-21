# Terminal video for the mutation testing lesson. Render from the repository root:
#   vhs techniques/mutation-testing/media/mutation-testing.tape
# VHS: https://github.com/charmbracelet/vhs (MIT licence). Videos are regenerated from this script, never edited by hand.

Output techniques/mutation-testing/media/mutation-testing.gif
Output techniques/mutation-testing/media/mutation-testing.mp4

Set Shell "bash"
Set FontSize 18
Set Width 1280
Set Height 720
Set Padding 24
Set TypingSpeed 35ms
Set Theme "Builtin Dark"

# Warm up Gradle off-camera so the video shows only the interesting part.
Hide
Type "export PS1='$ ' && ./gradlew -q :techniques:mutation-testing:testClasses 2>/dev/null; clear"
Enter
Wait@180s /\$ $/
Show

Type "# Two test suites. Both run every line of DiscountCalculator: 100% line coverage."
Enter
Sleep 1.5s
Type "# Mutation testing (PIT) plants 13 small bugs and checks whether the tests notice."
Enter
Sleep 2s

Type "# A weak test: it passes for ANY positive discount."
Enter
Type "grep -n -A1 'Weak:' techniques/mutation-testing/example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorWeakTest.java | head -2"
Enter
Sleep 3s

Type "# Run PIT against the weak suite..."
Enter
Type "./gradlew -q :techniques:mutation-testing:pitest -Psuite=weak 2>/dev/null | grep 'Generated 13'"
Enter
Wait@180s /Killed \d+ \(\d+%\)/
Sleep 3s

Type "# Only 5 of 13 planted bugs were caught. Now the strong suite, same coverage:"
Enter
Type "grep -n -A3 'assertAll(' techniques/mutation-testing/example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorStrongTest.java | head -4"
Enter
Sleep 3s

Type "./gradlew -q :techniques:mutation-testing:pitest 2>/dev/null | grep 'Generated 13'"
Enter
Wait@180s /Killed 13 \(100%\)/
Sleep 2s

Type "# All 13 caught. Coverage said both suites were equal; mutation testing shows they are not."
Enter
Sleep 4s
