---
name: find-meaningless-and-unreliable-tests
description: Find a repo's meaningless tests (they never run, can't fail, or check only their mocks) and unreliable tests (they sleep, or depend on the order tests run in), by searching the test code with PMD and reading only what it finds; record each in testing/tests.yaml and summarise them in testing/assessment.yaml. Use in discovery, or when asked how much a repo's existing tests can be trusted.
---

# Finding meaningless and unreliable tests

**Where the toolkit's files are:** this skill's links work wherever it is: in the toolkit's own repo they are relative to it, and when APM installs the toolkit in a repo it rewrites them to the toolkit's folder under `apm_modules/`. Where a command names `<toolkit>`, that is the toolkit's root: the repo root in the toolkit itself, otherwise `"$(dirname "$(find apm_modules -path '*/.github/skills/find-meaningless-and-unreliable-tests/SKILL.md' | head -1)")/../../.."`.

Discovery keeps three lists of tests apart, each with one owner
([why](../../../docs/decisions/0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)).
This skill writes two of them; tests that reach external systems are the external systems list skill's, and this one
never looks for them.

* **Meaningless tests** pass whatever the code does: they never run, can't fail, or check only their mocks.
  Measurement's planted bugs confirm or clear them.
* **Unreliable tests** may give a different answer on another run: they sleep, or depend on the order tests run in.
  Measurement's repeats in varied orders confirm or clear them.

Write two files: each test found in `testing/tests.yaml` ([schema](../../../schema/tests.schema.json)), and a summary
in the `meaningless_tests` and `unreliable_tests` sections of `testing/assessment.yaml`
([schema](../../../schema/assessment.schema.json)). Both, every time. Read code only: **never** build, test or run the
repo, or change or delete a test
([why](../../../decision-guides/0059-meaningless-and-unreliable-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)).

Never copy a secret's value (a password, key or token met in code, settings or a report) into a file you write or
your reply: point at its file and line instead
([why](../../../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

## 0. Read what applies

Find out which of these the repo has, and read the file for each one that applies, now, before searching. Read no
other.

| When | Read |
|---|---|
| The build has more than one module | [modules.md](modules.md), first |
| It builds with Maven (a `pom.xml`, no Gradle build file) | [maven.md](maven.md) |
| The test folders hold `.feature` files | [cucumber.md](cucumber.md) |

```bash
ls settings.gradle* build.gradle* pom.xml 2>/dev/null; grep -lE '^\s*include|<modules>' settings.gradle* pom.xml 2>/dev/null
find <test folders> -name '*.feature' | head -1
```

**PMD is required** ([why](../../../docs/decisions/0067-find-test-anti-patterns-needs-pmd-and-installs-it-when-it-is-missing.md)).
Check for it on the path, or in `.pmd/`:

```bash
(pmd --version || .pmd/pmd --version) 2>/dev/null | grep -m1 '^PMD '
```

If that prints nothing, install it into `.pmd/` with the toolkit's
[pmd-install](../../../tools/meaningless-and-unreliable-tests/pmd-install/build.gradle), which needs a JDK and the
organisation's package repository, keep it out of git, and check again:

```bash
<this skill's folder>/../../../gradlew -q -p <this skill's folder>/../../../tools/meaningless-and-unreliable-tests/pmd-install installPmd -Pinto="$PWD/.pmd"
echo '.pmd/' >> .git/info/exclude
```

If it still prints nothing, **stop and write nothing**: tell the person PMD is needed, and how to install it.

## With under-test-tools: only what needs judgement

If the organisation profile names `tools.under_test_tools_jar`, or `$UNDER_TEST_TOOLS_JAR` is set,
[under-test-tools](https://github.com/fiftiesHousewife/under-test-tools) does steps 1 to 5 except the `other-...` kinds,
and PMD needn't be installed ([why](../../../docs/decisions/0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)):

```bash
java -jar "$UNDER_TEST_TOOLS_JAR" meaningless-and-unreliable --repo . [--module <folder>]... \
  --rules <this skill's folder>/../../../tools/meaningless-and-unreliable-tests/rules.pmd.xml --version <toolkit version>
```

It writes `testing/tests.yaml` and the two sections and their decisions in `testing/assessment.yaml` exactly as the
steps below say. Then do only what it leaves:

1. The `other-...` kinds, for the tests you read: add each to its test's `meaningless` in `testing/tests.yaml`,
   keeping what the tool wrote.
2. Run it again with `--summary-only`, which reworks the summaries and decisions from the list.
3. Report, as step 6 says.

Without the tool, follow steps 1 to 6.

## 1. List the tests

Search; don't read every file. Test code is each module's `src/test/`, `src/integrationTest/` and any other test
source set the build names, with its resources, and any other `src/<name>/java` folder except `src/main/`: one the build
doesn't name holds tests that never run. With Gradle, every class in a test source set runs, whatever its name,
unless its test task's `include` or `exclude` filters leave it out. Use `grep -rn` (or the Grep tool with line numbers): a test's
**line** always comes from a search, never from counting lines while reading, and its **path** is from the repo root.

| A test is | Its line |
|---|---|
| A method marked `@Test`, `@ParameterizedTest`, `@RepeatedTest` or `@TestFactory` | The line with its name, not its annotation: the first method line after the annotation |
| A public `void test...()` in a class extending `TestCase`, directly or through a superclass, including Spring's JUnit 3 base classes (`AbstractDependencyInjectionSpringContextTests`, `AbstractTransactionalSpringContextTests`, `AbstractJpaTests` and the like) | The line with its name |

```bash
grep -rnE -A3 '@(Test|ParameterizedTest|RepeatedTest|TestFactory)\b' --include='*.java' <test folders> \
  | grep -E -- '-[0-9]+-[[:space:]]*(public |protected |private |static |final )*[A-Za-z0-9_<>]+ +[A-Za-z0-9_]+ *\('   # one line per test: path-line-method
grep -rlE 'extends (junit\.framework\.)?TestCase' --include='*.java' <test folders>   # then, in each file found:
grep -nE 'public void test[A-Za-z0-9_]*\(' <file>
```

Also list what looks like a test but **never runs**; it counts only under `never-runs`, never under any other
kind:

* a method marked `@Ignore` or `@Disabled` with no test annotation (one with a test annotation is `disabled`);
* a method whose test annotation is commented out (`// @Test`);
* a `public void test...()` method, or a public no-argument method in a class of tests, with no test annotation and
  not a JUnit 3 test, **that nothing in its class calls** (one that a test calls is a helper, and runs);
* in a JUnit 5 or 6 class (one importing `org.junit.jupiter`), a test method that is `private` or `static`, or returns
  a value (anything but `void`, except a `@TestFactory`): JUnit skips it without a word;
* every test in a folder the build doesn't name as a test source set;
* with Maven, every test in a class the test runner doesn't pick up ([maven.md](maven.md)).

Its line is the line with the method's name. PMD finds the cases in Java code (step 2); these find the rest:

```bash
find . -type d -path '*/src/*/java' -not -path '*/src/main/*'                         # compare with the build's source sets
grep -nE 'sourceSets|exclude|include' build.gradle* */build.gradle*                       # Gradle: the test source sets and filters
```

## 2. Count

A test counts once under each kind it shows; a disabled test counts under `disabled` only, and one that never runs
under `never-runs` only. The lists are closed.
Look only at the test's own body and the `@Before`/`@BeforeEach` methods declared in its class: don't follow helper
methods or superclasses, except that a call to a helper in the test code that itself asserts counts as an assertion.
PMD finds the candidates. **Never print a whole test file, or loop over test files printing them**: on a real repo that
is thousands of lines read for nothing. Read only the tests a hit points at, and of each only its method: from its line
in the step 1 listing to the line before the next test's (`sed -n '<line>,<next line - 1>p' <file>`). For a hit on a
class's line, read only its fields and set-up methods (`grep -nE '@(Before|BeforeEach|Mock|MockBean)|private .*=' <file>`).
Feature files can be read whole.

| List | `kind` | A test counts when |
|---|---|---|
| meaningless | `never-runs` | It looks like a test but never runs (step 1). |
| meaningless | `disabled` | It or its class has `@Ignore` or `@Disabled`; a Cucumber scenario counts too, by its tag ([cucumber.md](cucumber.md)). |
| meaningless | `no-real-assertion` | Its body has no assertion, or only `assertNotNull`, `assertTrue(true)`, `isNotNull()`, a bare `assertThat(x);` with nothing after it, a bare `verify(mock);`, or `expected = Exception.class` or `Throwable.class`. `assertNull`, `verify(...)`, `fail(...)`, `@Test(expected = ...)`, `assertThrows` and `@Rule ExpectedException` are real, and so is a call to a method in the test's class that itself asserts; a helper in another class counts only by its name (`check...`, `verify...`, `assert...`). |
| meaningless | `swallows-failures` | Its body catches an exception around the code it tests and does nothing that fails: the catch block is empty, or only logs or prints. Or it catches `AssertionError`, `Error` or `Throwable` and neither records the exception, rethrows it nor fails, which swallows its own failures. **Not** the expected-exception idiom: a `try` whose last statement is `fail(...)`, with a catch of the expected exception that is empty or checks it. |
| meaningless | `mocks-everything` | Its class has five or more mocks in total: `@Mock` and `@MockBean` fields, and `mock(` and `Mockito.mock(` calls (a field set by `mock(` counts once; `@Spy` doesn't count). |
| meaningless | `other-...` | It can't catch a bug for a reason the list misses: an expected value bent to pass (`size() + 1`), a server on `localhost` nothing starts, a word in the test's name that an asserted expected value contradicts, set-up copied from another test and never changed. Only these four, with a fixed id: `other-bent-expected-value`, `other-server-nothing-starts`, `other-name-does-not-match-assertions`, `other-copied-setup-unchanged`. Anything else you notice goes in the report, not the file. |
| unreliable | `sleeps` | Its body, or a `@Before`/`@BeforeEach` method of its class (then every test in the class), calls `Thread.sleep` or `TimeUnit.<unit>.sleep`. |
| unreliable | `order-dependent` | Its class has `@FixMethodOrder` or `@TestMethodOrder`, whatever its argument. |

**PMD** finds the Java kinds, with the toolkit's rules
([rules.pmd.xml](../../../tools/meaningless-and-unreliable-tests/rules.pmd.xml)). Use the `pmd` command found in step 0
(`pmd`, or `.pmd/pmd`). Run it once over the test folders:

```bash
pmd check --no-progress --no-fail-on-violation -f csv -d <test folders> -R <this skill's folder>/../../../tools/meaningless-and-unreliable-tests/rules.pmd.xml
```

Each hit's rule name starts with its kind (`no_real_assertion__...` is `no-real-assertion`). Give each hit to its test:
the test whose method holds the hit's line, or, for a hit on a class's line, every test in the class. Then check two
kinds of hit before counting them: a `never_runs__DetachedTest` hit whose class has a superclass in the repo that
extends `TestCase` or one of Spring's JUnit 3 base classes is a real test, so drop it; and read each
`swallows_failures__` hit's try and catch against the rule above. `other-...` has no search: look for it only in the
tests you read for the other kinds.

The same problems go by other names in the research and in tools such as tsDetect and Sonar, worth knowing when
comparing: `never-runs` is an unknown or commented-out test; `disabled` an ignored test; `no-real-assertion` an
assertion-free, empty or unchecked test; `swallows-failures` an exception-catching test; `mocks-everything` excessive
mocking; `sleeps` a sleepy test; `order-dependent` interacting tests. The five-mock threshold for `mocks-everything` has
no published basis: the report gives each counted class's number of mocks, so the threshold can be judged against the
repo.

## 3. Write each test found to testing/tests.yaml

The example below shows every field; there's no need to read the schemas. The list is shared: other skills record their
own findings about the same tests
([why](../../../docs/decisions/0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md)).
In `testing/tests.yaml`, this skill owns only `found_by.find-meaningless-and-unreliable-tests` and each entry's
`meaningless` and `unreliable`; never change anything else.

* Each test counted under any kind has an entry, found by its `test`: `<fully qualified class>.<method>`, as JUnit's
  reports name it, always in double quotes (a scenario's name holds a `:`). Add an entry if there is none; set its `at`
  to `"path:line"` from the step 1 listing (the method's line: never an annotation's, and never a hit's). Set
  `meaningless` to the meaningless kinds it counts under and `unreliable` to the unreliable ones, each in the table's
  order, leaving out a list that would be empty.
* From every other entry, remove `meaningless` and `unreliable`; an entry left with only `test` and `at` goes.
* Set `found_by.find-meaningless-and-unreliable-tests` to the toolkit `version` and the repo `commit`, as for the
  summary. Keep entries sorted by `test`.
* No file yet: create it with `# yaml-language-server: $schema=<path>` (as for the assessment file, with
  `schema/tests.schema.json`), `schema: tests/1`, then `found_by` and `tests`.

```yaml
# yaml-language-server: $schema=<path to the toolkit's schema/tests.schema.json>
schema: tests/1
found_by:
  find-meaningless-and-unreliable-tests: {version: unreleased, commit: "1a2b3c4"}
tests:
  - test: "com.example.orders.OrderServiceTest.waitsForTheQueue"
    at: "src/test/java/com/example/orders/OrderServiceTest.java:41"
    meaningless: [no-real-assertion]
    unreliable: [sleeps]
```

## 4. Summarise them in testing/assessment.yaml

* Work the summaries out from `testing/tests.yaml`: `meaningless_tests` over every entry's `meaningless`,
  `unreliable_tests` over every entry's `unreliable`. A finding for each kind with at least one test, keys in this
  order: `id` (the kind, or `other-...`), `kind` (`other` for an `other-...`), `tests` (the count), `examples`.
  Findings sorted by `id`; a section with none has `findings: []`.
* `examples`: one line, the first three counted tests sorted by path (byte order) then by line as a number, as quoted
  `"path:line"`: each test's `at`, never the line a hit was on.
* `found_by`, the same in both: `tool: find-meaningless-and-unreliable-tests`; `version`: the organisation profile's
  `toolkit.version` if you have it, else `unreleased`; `commit`: `git rev-parse --short HEAD` in the repo, in double
  quotes (no git repository: stop and say so).
* Double-quote any text value that starts with a digit or contains `:` or `#`; numbers such as `tests` stay bare.

```yaml
meaningless_tests:
  found_by: {tool: find-meaningless-and-unreliable-tests, version: unreleased, commit: "1a2b3c4"}
  findings:
    - id: disabled
      kind: disabled
      tests: 4
      examples: ["src/test/java/com/example/orders/OrderServiceTest.java:35", "src/test/java/com/example/orders/RefundTest.java:13", "src/test/java/com/example/orders/RefundTest.java:18"]
unreliable_tests:
  found_by: {tool: find-meaningless-and-unreliable-tests, version: unreleased, commit: "1a2b3c4"}
  findings: []
```

Replace each section in place; with none, insert them, `meaningless_tests` first, before `obstacles`, else before
`techniques`, else before `decisions`, else at the end, with no blank line between sections. Leave the first line and
all other sections as they are. No file yet: create it with `# yaml-language-server: $schema=<path>` (relative to the
toolkit's `schema/assessment.schema.json` where it is installed with the repo, otherwise
`https://raw.githubusercontent.com/fiftiesHousewife/under-test/main/schema/assessment.schema.json`), `schema:
assessment/1`, `repo: {name: <the repo's folder name>}`, then the sections.

## 5. Propose decisions

Under `decisions:` (added at the end of the file if missing), keyed `meaningless/<id>` or `unreliable/<id>`:

* existing, and its id is no longer a finding: set `state: stale`, nothing else;
* `stale`, and its id is a finding again: set `state: proposed`, nothing else;
* existing otherwise, whatever its state: leave it;
* missing: append, in finding order (meaningless first), `state: proposed`, `drafted_by: ai`, `choice:` from the
  table. Only `other-name-does-not-match-assertions` gets, instead of `choice:`, exactly
  `question: "Should these tests check what their names say, or what their assertions check?"`.

```yaml
decisions:
  meaningless/disabled:
    state: proposed
    drafted_by: ai
    choice: "Application Owner decides: re-enable, or delete once the approval-test baseline exists"
  unreliable/sleeps:
    state: proposed
    drafted_by: ai
    choice: fixed in the fix-flaky-tests workstream
```

| Kind | `choice` |
|---|---|
| `disabled` | `"Application Owner decides: re-enable, or delete once the approval-test baseline exists"` |
| `never-runs` | `"Application Owner decides: make it a real test, or delete once the approval-test baseline exists"` |
| `no-real-assertion`, `swallows-failures`, `mocks-everything`, `other-...` | `fixed in the strengthen-tests workstream` |
| `sleeps`, `order-dependent` | `fixed in the fix-flaky-tests workstream` |

## 6. Report

Briefly: the total number of tests; how many are meaningless and how many unreliable, each kind's count and examples;
disabled tests, and tests that never run, need the Application Owner (say how many of those that never run are in
classes the build excludes on purpose, such as functional tests that need the network: often the tests repair pairs,
which need a scheduled run rather than deleting); read coverage and planted-bug results with these
in mind (a test with no real assertion adds coverage but catches nothing); and anything the searches couldn't settle.
