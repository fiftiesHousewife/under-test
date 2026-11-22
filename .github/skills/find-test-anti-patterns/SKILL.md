---
name: find-test-anti-patterns
description: Find anti-patterns in a repo's existing tests by reading the test code, and write the anti_patterns section of its testing/assessment.yaml. Use in discovery, or when asked how good a repo's existing tests are.
---

# Finding anti-patterns in existing tests

Write the `anti_patterns` section of `testing/assessment.yaml` ([schema](../../../schema/assessment.schema.json)).
Read code only: **never** build, test or run the repo, or change or delete a test
([why](../../../decision-guides/0059-anti-patterns-in-existing-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)).

## 1. List the tests

Read every file in each module's `src/test/`, `src/integrationTest/` and any other test source set the build names. A **test** is a
method marked `@Test`, `@ParameterizedTest`, `@RepeatedTest` or `@TestFactory`, or a public `void test...()` in a
class extending `TestCase`. Its **line** is the line with its name, not its annotation; its **path** is from the repo
root.

## 2. Count

A test counts once under each kind it shows; a disabled test counts under `disabled` only. The lists are closed.
Look only at the test's own body and the `@Before`/`@BeforeEach` methods declared in its class: don't follow helper
methods or superclasses.

| `kind` | A test counts when |
|---|---|
| `disabled` | It or its class has `@Ignore` or `@Disabled`. |
| `no-real-assertion` | Its body has no assertion, or only `assertNotNull`, `assertNull`, `assertTrue(true)`, `isNotNull()`. `verify(...)`, `fail(...)`, `@Test(expected = ...)`, `assertThrows` and `@Rule ExpectedException` are real. |
| `sleeps` | Its body, or a `@Before`/`@BeforeEach` method of its class (then every test in the class), calls `Thread.sleep` or `TimeUnit.<unit>.sleep`. |
| `order-dependent` | Its class has `@FixMethodOrder` or `@TestMethodOrder`, whatever its argument. |
| `reaches-shared-system` | Its class, or a resource file the class loads, names a host (any name or IP address after `//`, `@` or `=` in a string literal, or in a properties or YAML value) other than `localhost`, `127.0.0.1`, `::1`, `example.com`/`.org`/`.net` and their subdomains, or one ending `.example`, `.test`, `.invalid`, `.localhost`. Also any test the airgap agent's reports (`build/airgap/*/calls.jsonl`) name as calling a host not excluded here. |
| `mocks-everything` | Its class has five or more mocks in total: `@Mock` and `@MockBean` fields, and `mock(` and `Mockito.mock(` calls (a field set by `mock(` counts once; `@Spy` doesn't count). |
| `copy-pasted` | Ten or more consecutive non-blank lines between its method's braces are the same as another test's once every string, number and character literal is ignored: count every test in the group. PMD's `cpd --minimum-tokens 75 --dir <test folders>` may find candidates if PMD is installed. |
| `other` | It can't catch a bug for a reason the list misses: an expected value bent to pass (`size() + 1`), a server on `localhost` nothing starts, a word in the test's name that an asserted expected value contradicts, set-up copied and never changed (only where not already `copy-pasted`). Only these four, one finding each, holding every test that shows it, with a fixed id: `other-bent-expected-value`, `other-server-nothing-starts`, `other-name-does-not-match-assertions`, `other-copied-setup-unchanged`. Anything else you notice goes in the report, not the file. |

## 3. Write the section

* A finding for each kind with at least one test, keys in this order: `id` (the kind, or `other-...`), `kind`,
  `tests` (the count), `examples`. Findings sorted by `id`.
* `examples`: one line, the first three counted tests sorted by path (byte order) then by line as a number, as
  quoted `"path:line"`.
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
| `reaches-shared-system` | `tagged and left out of normal runs` |
| `sleeps`, `order-dependent` | `fixed in the fix-flaky-tests workstream` |
| `no-real-assertion`, `mocks-everything`, `copy-pasted`, `other` | `fixed in the strengthen-tests workstream` |

## 5. Report

Briefly: the total number of tests, and how many show at least one anti-pattern; each kind's count and examples; disabled tests need the Application Owner; tests
reaching shared systems need tagging before the tests run anywhere; read coverage and planted-bug results with these
in mind (a test with no real assertion adds coverage but catches nothing).
