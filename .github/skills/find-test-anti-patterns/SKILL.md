---
name: find-test-anti-patterns
description: Find anti-patterns in a repo's existing tests, by searching the test code and reading only what the searches find, write every test it finds to testing/anti-pattern-tests.yaml, and summarise them in the anti_patterns section of its testing/assessment.yaml. Use in discovery, or when asked how good a repo's existing tests are.
---

# Finding anti-patterns in existing tests

Write the `anti_patterns` section of `testing/assessment.yaml` ([schema](../../../schema/assessment.schema.json)).
Read code only: **never** build, test or run the repo, or change or delete a test
([why](../../../decision-guides/0059-anti-patterns-in-existing-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)).

## 0. Read what applies

Find out which of these the repo has, and read the file for each one that applies, now, before searching. Read no
other.

| When | Read |
|---|---|
| The build has more than one module | [modules.md](modules.md), first |
| It builds with Maven (a `pom.xml`, no Gradle build file) | [maven.md](maven.md) |
| The test folders hold `.feature` files | [cucumber.md](cucumber.md) |
| A test class names an XML file in `@ContextConfiguration` or `@ImportResource` | [spring-xml.md](spring-xml.md) |

```bash
ls settings.gradle* build.gradle* pom.xml 2>/dev/null; grep -lE '^\s*include|<modules>' settings.gradle* pom.xml 2>/dev/null
find <test folders> -name '*.feature' | head -1
grep -rlE '@(ContextConfiguration|ImportResource)\(.*\.xml' --include='*.java' <test folders>
```

## 1. List the tests

Search; don't read every file. Test code is each module's `src/test/`, `src/integrationTest/` and any other test
source set the build names, with its resources, and any other `src/<name>/java` folder except `src/main/`: one the build
doesn't name holds tests that never run. With Gradle, every class in a test source set runs, whatever its name,
unless its test task's `include` or `exclude` filters leave it out. Use `grep -rn` (or the Grep tool with line numbers): a test's
**line** always comes from a search, never from counting lines while reading, and its **path** is from the repo root.

| A test is | Its line |
|---|---|
| A method marked `@Test`, `@ParameterizedTest`, `@RepeatedTest` or `@TestFactory` | The line with its name, not its annotation: the first `void <name>(` line after the annotation |
| A public `void test...()` in a class extending `TestCase` | The line with its name |

```bash
grep -rnE -A3 '@(Test|ParameterizedTest|RepeatedTest|TestFactory)\b' --include='*.java' <test folders>
grep -rlE 'extends (junit\.framework\.)?TestCase' --include='*.java' <test folders>   # then, in each file found:
grep -nE 'public void test[A-Za-z0-9_]*\(' <file>
```

Also list what looks like a test but **never runs**; it counts only under `never-runs`, never as a test of any other
kind:

* a method marked `@Ignore` or `@Disabled` with no test annotation (one with a test annotation is `disabled`);
* a method whose test annotation is commented out (`// @Test`);
* a `public void test...()` method with no test annotation, in a class that doesn't extend `TestCase`;
* every test in a folder the build doesn't name as a test source set;
* with Maven, every test in a class the test runner doesn't pick up ([maven.md](maven.md)).

Its line is the line with the method's name.

```bash
grep -rnE -A2 '^\s*@(Ignore|Disabled)\b' --include='*.java' <test folders>        # then check for a test annotation above
grep -rnE '//\s*@(Test|ParameterizedTest|RepeatedTest|TestFactory)' --include='*.java' <test folders>
grep -rnE -B2 'public void test[A-Za-z0-9_]*\(' --include='*.java' <test folders>
find . -type d -path '*/src/*/java' -not -path '*/src/main/*'                         # compare with the build's source sets
grep -nE 'sourceSets|exclude|include' build.gradle* */build.gradle*                       # Gradle: the test source sets and filters
```

## 2. Count

A test counts once under each kind it shows; a disabled test counts under `disabled` only, and one that never runs
under `never-runs` only. The lists are closed.
Look only at the test's own body and the `@Before`/`@BeforeEach` methods declared in its class: don't follow helper
methods or superclasses. Each kind has a search; read only the tests and files it finds.

| `kind` | A test counts when |
|---|---|
| `never-runs` | It looks like a test but never runs (step 1). |
| `disabled` | It or its class has `@Ignore` or `@Disabled`. |
| `no-real-assertion` | Its body has no assertion, or only `assertNotNull`, `assertNull`, `assertTrue(true)`, `isNotNull()`. `verify(...)`, `fail(...)`, `@Test(expected = ...)`, `assertThrows` and `@Rule ExpectedException` are real. |
| `sleeps` | Its body, or a `@Before`/`@BeforeEach` method of its class (then every test in the class), calls `Thread.sleep` or `TimeUnit.<unit>.sleep`. |
| `order-dependent` | Its class has `@FixMethodOrder` or `@TestMethodOrder`, whatever its argument. |
| `reaches-external-system` | Its class, or a file it loads, names a host other than `localhost`, `127.0.0.1`, `::1`, `example.com`/`.org`/`.net` and their subdomains, or one ending `.example`, `.test`, `.invalid`, `.localhost`. A host is a name or IP address after `//`, `@` or `=` in a string literal, a properties or YAML value, or an XML attribute or element value. A file it loads includes a Spring XML context ([spring-xml.md](spring-xml.md)). **Never a host:** an XML namespace (`xmlns`, `xmlns:*`), `xsi:schemaLocation` and `xsi:noNamespaceSchemaLocation` values, and a DTD's `PUBLIC` or `SYSTEM` address. Also any test the airgap agent's reports (`build/airgap/*/calls.jsonl`) name as calling a host not excluded here. |
| `mocks-everything` | Its class has five or more mocks in total: `@Mock` and `@MockBean` fields, and `mock(` and `Mockito.mock(` calls (a field set by `mock(` counts once; `@Spy` doesn't count). |
| `copy-pasted` | Ten or more consecutive non-blank lines between its method's braces are the same as another test's once every string, number and character literal is ignored: count every test in the group. Also every test in a test class that has a copy, the same or nearly the same, under another test folder or module. |
| `other` | It can't catch a bug for a reason the list misses: an expected value bent to pass (`size() + 1`), a server on `localhost` nothing starts, a word in the test's name that an asserted expected value contradicts, set-up copied and never changed (only where not already `copy-pasted`). Only these four, one finding each, holding every test that shows it, with a fixed id: `other-bent-expected-value`, `other-server-nothing-starts`, `other-name-does-not-match-assertions`, `other-copied-setup-unchanged`. Anything else you notice goes in the report, not the file. |

The searches, over test code and its resources; read only what they find:

```bash
grep -rnE '@(Ignore|Disabled)\b' --include='*.java' <test folders>                      # disabled
grep -rnE 'Thread\.sleep|TimeUnit\.[A-Z]+\.sleep' <test folders>                         # sleeps
grep -rnE '@(FixMethodOrder|TestMethodOrder)' <test folders>                             # order-dependent
grep -rcE '@Mock\b|@MockBean\b|[^A-Za-z.]mock\(|Mockito\.mock\(' --include='*.java' <test folders>   # mocks-everything: read files with 5 or more
grep -rnE '(//|@|=)([A-Za-z0-9.-]+\.[A-Za-z]{2,}|[0-9]{1,3}(\.[0-9]{1,3}){3})' <test folders>   # reaches-external-system: drop the never-a-host lines
find <test folders> -name '*.java' | sed 's|.*/||' | sort | uniq -d                    # copy-pasted: classes under more than one folder; compare each pair with cmp or diff
grep -rnE 'assertNotNull|assertNull|assertTrue\(true\)|isNotNull\(\)' --include='*.java' <test folders>
```

For `no-real-assertion`, run this skill's [scripts/no-real-assertion.awk](scripts/no-real-assertion.awk) (run it; don't
read it): it prints every test whose body, an empty one included, has no assertion at all. Then read the tests the
last search above finds, for those whose only assertions are weak.

```bash
find <test folders> -name '*.java' | sort | xargs awk -f <this skill's folder>/scripts/no-real-assertion.awk
```

For `copy-pasted`, run PMD's `cpd --minimum-tokens 75 --dir <test folders>` if PMD is installed; otherwise compare
tests within each class, and the classes the search above finds under more than one folder, and say in the report
that copying between other classes wasn't checked. `other` has no search:
look for it only in the tests you read for the other kinds.

## 3. Write the section

* A finding for each kind with at least one test, keys in this order: `id` (the kind, or `other-...`), `kind`,
  `tests` (the count), `examples`. Findings sorted by `id`.
* `examples`: one line, the first three counted tests sorted by path (byte order) then by line as a number, as
  quoted `"path:line"`, with the line found by the search in step 1, even when the problem shows on a later line.
* `found_by`: `tool: find-test-anti-patterns`; `version`: the organisation profile's `toolkit.version` if you have it,
  else `unreleased`; `commit`: `git rev-parse --short HEAD` in the repo, in double quotes (no git repository:
  stop and say so).
* Double-quote any text value that starts with a digit or contains `:` or `#`; numbers such as `tests` stay bare.

```yaml
anti_patterns:
  found_by: {tool: find-test-anti-patterns, version: unreleased, commit: "1a2b3c4"}
  findings:
    - id: disabled
      kind: disabled
      tests: 4
      examples: ["src/test/java/com/example/orders/OrderServiceTest.java:35", "src/test/java/com/example/orders/RefundTest.java:13", "src/test/java/com/example/orders/RefundTest.java:18"]
```

Replace any `anti_patterns` section in place; with none, insert it before `obstacles`, else before `techniques`,
else before `decisions`, else at the end, with no blank line between sections. Leave the first line and all other sections as they are. No file yet:
create it with `# yaml-language-server: $schema=<path>` (relative to the toolkit's `schema/assessment.schema.json`
where it is installed with the repo, otherwise
`https://raw.githubusercontent.com/fiftiesHousewife/under-test/main/schema/assessment.schema.json`), `schema:
assessment/1`, `repo: {name: <the repo's folder name>}`, then the section.

## 3a. List every test found

Later steps work from this list instead of searching again: the stand-ins for each connection, the flaky-test fixes,
and the Application Owner's decisions. Write `testing/anti-pattern-tests.yaml`
([schema](../../../schema/anti-pattern-tests.schema.json)), replacing any earlier one: one entry for every test
counted under any kind, sorted like the examples.

* `at`: `"path:line"`, as in step 1. `name`: `<Class>.<method>`.
* `kinds`: every kind it counts under, with each `other` as its fixed id (`other-bent-expected-value`, ...).
* `reaches`, for `reaches-external-system`: each host (no scheme, port or path), `through` (`code`, `properties`,
  `yaml`, `spring-xml` for a host in a Spring XML context or a file that context loads, or `airgap-report`), and
  `where`, the `path:line` naming it.
* `copy_of`, for `copy-pasted`: the `path:line` of one test it is a copy of.

```yaml
# yaml-language-server: $schema=<path to the toolkit's schema/anti-pattern-tests.schema.json>
schema: anti-pattern-tests/1
found_by: {tool: find-test-anti-patterns, version: unreleased, commit: "1a2b3c4"}
tests:
  - at: "src/test/java/com/example/orders/OrderRepositoryIT.java:13"
    name: OrderRepositoryIT.findsAnOrder
    kinds: [reaches-external-system]
    reaches:
      - {host: orders-uat.internal, through: code, where: "src/test/java/com/example/orders/OrderRepositoryIT.java:10"}
```

## 4. Propose decisions

Under `decisions:` (added at the end of the file if missing), keyed `anti-patterns/<id>`:

* existing, and its id is no longer a finding: set `state: stale`, nothing else;
* `stale`, and its id is a finding again: set `state: proposed`, nothing else;
* existing otherwise, whatever its state: leave it;
* missing: append, in finding order, `state: proposed`, `drafted_by: ai`, `choice:` from the table. Only
  `other-name-does-not-match-assertions` gets, instead of `choice:`, exactly
  `question: "Should these tests check what their names say, or what their assertions check?"`.

```yaml
decisions:
  anti-patterns/disabled:
    state: proposed
    drafted_by: ai
    choice: "Application Owner decides: re-enable, or delete once the approval-test baseline exists"
  anti-patterns/sleeps:
    state: proposed
    drafted_by: ai
    choice: fixed in the fix-flaky-tests workstream
```

| Kind | `choice` |
|---|---|
| `disabled` | `"Application Owner decides: re-enable, or delete once the approval-test baseline exists"` |
| `never-runs` | `"Application Owner decides: make it a real test, or delete once the approval-test baseline exists"` |
| `reaches-external-system` | `tagged and left out of normal runs` |
| `sleeps`, `order-dependent` | `fixed in the fix-flaky-tests workstream` |
| `no-real-assertion`, `mocks-everything`, `copy-pasted`, `other` | `fixed in the strengthen-tests workstream` |

## 5. Report

Briefly: the total number of tests, and how many show at least one anti-pattern; each kind's count and examples; disabled tests, and tests that never run, need the Application Owner; tests
reaching external systems need tagging before the tests run anywhere; read coverage and planted-bug results with these
in mind (a test with no real assertion adds coverage but catches nothing); and anything the searches couldn't settle, such
as copy-pasting across classes without PMD.
