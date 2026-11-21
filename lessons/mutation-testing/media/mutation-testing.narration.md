# Narration: mutation testing

One line per scene. Captions and the voiceover are generated from this file; the video script is
[mutation-testing.tape](mutation-testing.tape).

1. **Why.** Mutation testing asks whether your tests check the code they run, or only run it. Line coverage counts the
   lines a test ran; it cannot tell whether any test checked the result. PIT plants one small bug at a time, reruns the
   tests, and counts the bugs they catch.
2. **The build.** PIT is one Gradle plugin, applied to every repo by the toolkit's build conventions, with its versions
   in the version catalogue. This lesson adds one switch to choose which of its two test suites PIT uses.
3. **The code under test.** A discount of 5% from 50 and 10% from 100, plus 2% more for loyal customers.
4. **The weak tests.** Every line of the calculator runs, so line coverage is 100%. The comments say what each test
   fails to check.
5. **PIT on the weak tests.** `./gradlew -q :lessons:mutation-testing:pitest -Psuite=weak`. The build prints a summary:
   100% line coverage, but only 5 of 13 planted bugs caught. For every bug it shows the line it changed and which tests
   ran: the ones that failed, or the ones that still passed. On line 24, `>= 50` became `> 50`, so an order of exactly
   50 loses its discount, and no test tries 50.
6. **The strong tests.** They check both sides of every boundary, with exact values.
7. **PIT on the strong tests.** `./gradlew -q :lessons:mutation-testing:pitest`. The same 100% line coverage, and all 13
   planted bugs caught. Only mutation testing shows which tests catch bugs.
