---
name: find-test-anti-patterns
description: Find anti-patterns in a repo's existing tests (no real assertion, disabled, sleeps, order dependence, reaching shared systems, mocking everything, copy-paste), by reading the test code, and write the anti_patterns section of its testing/assessment.yaml. Use in discovery, or when asked how good a repo's existing tests are.
---

# Finding anti-patterns in existing tests

Each anti-pattern is counted the same way every time, so a re-run can be compared with the last, and recorded in the
`anti_patterns` section of `testing/assessment.yaml` ([its schema](../../../schema/assessment.schema.json)). This
reads code only. **Never** build, test or run the repo, and **never** delete or change a test: no existing test is
deleted before the approval-test baseline exists
([the guide](../../../decision-guides/0059-anti-patterns-in-existing-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)).

## 1. List the test methods

Read every file under the repo's test folders (`src/test/`, `src/integrationTest/`, and any other test source set
the build names). A **test** is a method marked `@Test`, `@ParameterizedTest`, `@RepeatedTest` or `@TestFactory`,
or, in JUnit 3, a public `void test...()` method in a class that extends `TestCase`. Count methods, not classes.

## 2. Count each anti-pattern

A test can show several anti-patterns; count it under each. Count a disabled test under `disabled` only.

| `kind` | A test counts when | |
|---|---|---|
| `disabled` | It, or its class, has `@Ignore` or `@Disabled` (with or without a reason) | every test in a disabled class |
| `no-real-assertion` | It has no assertion at all, or its only assertions are `assertNotNull`, `assertNull`, `assertTrue(true)` or `isNotNull()`. A `verify(...)`, an expected exception (`@Test(expected = ...)`, `assertThrows`, `@Rule ExpectedException`) and `fail(...)` count as real assertions | |
| `sleeps` | It calls `Thread.sleep` or `TimeUnit...sleep`, directly or in a `@Before`/`@BeforeEach` method of its class | every test in the class, when the sleep is in a set-up method |
| `order-dependent` | Its class has `@FixMethodOrder` or `@TestMethodOrder` | every test in the class |
| `reaches-shared-system` | Its class, or a resource file it loads, names a host other than `localhost`, `127.0.0.1`, `::1`, or a name reserved for examples (ending `.example`, `.test`, `.invalid`, `.localhost`, or `example.com`/`.org`/`.net`), in a URL, JDBC address or host setting | every test in the class. If the airgap agent's reports exist (`build/airgap/*/calls.jsonl`), each test they name counts too |
| `mocks-everything` | Its class creates five or more mocks (`@Mock` fields, `mock(...)` or `Mockito.mock(...)` calls) | every test in the class |
| `copy-pasted` | Its body repeats another test's body, line for line apart from literal values, for ten or more lines | each test in the pair |

For copy-paste you may use PMD's copy-paste detector (`cpd --minimum-tokens 75 --dir <test folders>`) if PMD is
already available; it reads code without running it.

**Then note what the list misses.** While reading, look for tests that can't catch a bug for a reason the list
doesn't cover: an expected value bent to make the test pass (`size() + 1`), a test that needs something nothing in
it starts (a server on `localhost`), a test whose name says one thing and whose assertions check another, set-up
copied from another case and never changed. Record each as kind `other`, with id `other-<two to four words>`.
Where only a person can say what was meant, add a proposed decision with a `question:` for the Application Owner.

## 3. Write the section

One finding per kind that has at least one test. Leave out kinds with none.

* `id`: the kind itself, so it stays the same between runs.
* `tests`: the number of tests counted.
* `examples`: up to three tests, as `"path:line"` of the method's declaration, quoted, sorted by path.

```yaml
anti_patterns:
  found_by: {tool: find-test-anti-patterns, version: "<toolkit version, or unreleased>", commit: <short commit>}
  findings:
    - id: disabled
      kind: disabled
      tests: 4
      examples: ["src/test/java/com/example/orders/OrderServiceTest.java:35", "src/test/java/com/example/orders/RefundTest.java:13"]
```

Replace any `anti_patterns` section already there, findings sorted by id. Leave every other section as it is. If the
file doesn't exist yet, create it with `schema: assessment/1`, a `repo:` with at least `name`, and the
`# yaml-language-server: $schema=...` first line pointing at the toolkit's schema: a relative path to it where the toolkit is installed next to the repo, otherwise `https://raw.githubusercontent.com/fiftiesHousewife/under-test/main/schema/assessment.schema.json`.

## 4. Propose what happens to each kind

Don't change a decision people have made. Mark an `anti-patterns/<id>` decision whose kind has gone `state: stale`.
Where no decision exists, add one with `state: proposed` and `drafted_by: ai`:

| Kind | Proposed `choice` |
|---|---|
| `disabled` | "Application Owner decides: re-enable, or delete once the approval-test baseline exists" |
| `reaches-shared-system` | "tagged and left out of normal runs" |
| `sleeps`, `order-dependent` | "fixed in the fix-flaky-tests workstream" |
| `no-real-assertion`, `mocks-everything`, `copy-pasted` | "fixed in the strengthen-tests workstream" |
| `other` | "fixed in the strengthen-tests workstream", or a `question:` where the intent is unclear |

## 5. Report

Tell the person, briefly: how many tests the repo has, how many show each anti-pattern, and the examples. Disabled
tests need the Application Owner; tests reaching shared systems need tagging before the tests run anywhere. Then say
that coverage and planted-bug results should be read with these tests in mind: a test with no real assertion adds
coverage but catches nothing.
