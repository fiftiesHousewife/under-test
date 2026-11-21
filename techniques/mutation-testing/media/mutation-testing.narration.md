# Mutation testing: two suites, same coverage, very different strength

Here are two test suites for the same discount calculator. Both of them run every line of the code, so line coverage
says they are equally good.

Mutation testing checks that claim. A tool called PIT plants thirteen small bugs in the code, one at a time, and runs
the tests against each one. A good test suite should notice every planted bug.

First, look at a test from the weak suite. It only checks that the discount is more than zero, so a wrong percentage
would still pass.

```console
$ grep -n -A1 'Weak:' techniques/mutation-testing/example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorWeakTest.java | head -2
```

Now run PIT against the weak suite.

```console
$ ./gradlew -q :techniques:mutation-testing:pitest -Psuite=weak 2>/dev/null | grep 'Generated 13'
```

Only five of the thirteen planted bugs were caught. The other eight would slip through, even with full line coverage.

The strong suite checks exact values on both sides of every boundary, and wraps several checks together so that every
failure is reported.

```console
$ grep -n -A3 'assertAll(' techniques/mutation-testing/example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorStrongTest.java | head -4
```

Run PIT against the strong suite.

```console
$ ./gradlew -q :techniques:mutation-testing:pitest 2>/dev/null | grep 'Generated 13'
```

All thirteen caught. Coverage told us the two suites were the same. Mutation testing shows they are not.
