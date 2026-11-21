# Strengthen tests until PIT catches the planted bugs

Use after discovery has shown, with PIT, that the tests in some code can't be trusted: line coverage is high, but planted
bugs survive. Work on one class or package at a time, starting with the code that matters most.

1. Run PIT on the code in question: `./gradlew pitest` (the build conventions print a summary when it finishes).
2. Read the summary's **Missed** list. For each planted bug it shows the line it changed, what changed, and which tests
   ran and still passed.
3. For each missed bug, write or improve **one** test so that it fails with that bug in place:
   - check the exact value, not just "greater than zero" or "not null";
   - test both sides of every boundary (for `total >= 50`: 49 and 50);
   - check results the code returns or writes, not only that it ran without an error;
   - several checks in one test go in `assertAll(...)`.
4. Rerun PIT. Repeat until nothing important is missed.
5. Stop when the remaining survivors are not worth a test (logging, for example). Say which you left, and why, in the
   pull request.

Rules:
- Don't change the code under test to make a test pass. If a test shows the code is wrong, record it as an open
  question for the Application Owner and keep a test that pins today's behaviour.
- Don't game the score: never delete or loosen code, and never exclude classes, just to make survivors disappear.
- Every new test passes `./gradlew check`.

Why a prompt and not a skill: the build's summary already gives everything needed, so a short prompt does the job
without adding to every session.
