# Without PMD

Read this only when no `pmd` command is available. These searches stand in for PMD's rules; they match text, not
Java's structure, so they miss more and mistake more. Say in the report that PMD wasn't used. Read only what they find.

```bash
grep -rnE -A2 '^\s*@(Ignore|Disabled)\b' --include='*.java' <test folders>        # disabled, or never-runs with no test annotation above
grep -rnE '//\s*@(Test|ParameterizedTest|RepeatedTest|TestFactory)' --include='*.java' <test folders>   # never-runs
grep -rnE -B2 'public void test[A-Za-z0-9_]*\(' --include='*.java' <test folders>   # never-runs, outside JUnit 3 classes
grep -rnE 'Thread\.sleep|TimeUnit\.[A-Z]+\.sleep' <test folders>                         # sleeps
grep -rnE '@(FixMethodOrder|TestMethodOrder)' <test folders>                             # order-dependent
grep -rcE '@Mock\b|@MockBean\b|[^A-Za-z.]mock\(|Mockito\.mock\(' --include='*.java' <test folders>   # mocks-everything: read files with 5 or more
grep -rnE -A3 'catch *\((final )?[A-Za-z.]*(Exception|AssertionError|Error|Throwable)[ |A-Za-z.]* [A-Za-z_]+\) *\{' --include='*.java' <test folders>   # swallows-failures: read each try and catch
grep -rnE 'assertNotNull|assertNull|assertTrue\(true\)|isNotNull\(\)|assertThat\([^,;.()]*(\([^,;.()]*\))?\) *;|verify\([A-Za-z0-9_]+\) *;|expected *= *(Exception|Throwable)\.class' --include='*.java' <test folders>   # weak assertions
grep -rLE 'assert|verify\(|fail\(|andExpect|should' --include='*Test*.java' <test folders>   # files with no assertion at all
```

For `no-real-assertion`, read the tests in the files the last two searches find, and in files with more tests than
assertion lines. A call to a method in the test code that itself asserts (`checkTotals(order, 1000)`) counts as an
assertion: search for its definition before counting the test. For `copy-pasted`, compare tests within each class and
the classes found under more than one folder, and say that copying between other classes wasn't checked.
