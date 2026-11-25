---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Repair converts a JUnit 3 test class to JUnit 4 before pairing it

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)
gives the pair's shape for JUnit 5 or 6 (a test interface) and for JUnit 4 (a parameterised class), but not for
JUnit 3: classes that extend `TestCase`, name their tests `test...`, and build parameterised runs by hand in a static
`suite()`. Old repos still hold many of them. The field trial's Apache Commons Net 3.6 is one: all 26 of its test
classes are JUnit 3, its 18 tests that reach public servers among them, and it compiles to Java 6, which rules out
JUnit 5. JUnit 4 is already on its test classpath, as it usually is, since JUnit 4 runs JUnit 3 tests.

## Considered Options

* **Convert the class to JUnit 4, then pair it as a JUnit 4 class**  
  Only test code changes, and the build already runs JUnit 4
* **Keep JUnit 3: an abstract `TestCase` with the bodies and two subclasses**  
  JUnit 3 has no tags or assumptions, so keeping the external half out of normal builds needs a build change
  (a Surefire exclude), which repair may not make

## Decision Outcome

Chosen in discussion: convert, then pair.

* **Only the class repair pairs** is converted: `@Test`, `@Before` and `@After` in place of the names and overrides,
  JUnit 4's assertions, and no `extends TestCase`. Its other tests come along unchanged in behaviour.
* **A `suite()` that adds one test per value** (Commons Net's `ListingFunctionalTest` adds each test once per FTP
  server) becomes `@RunWith(Parameterized.class)` with those values as its parameters. The pair then follows the JUnit
  4 shape of [decision 0086](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md):
  one parameterised class, whose run against the real system a system property switches on.
* **The conversion is its own commit** in repair's pull request, before the pairing, so a reviewer sees that it
  changes no test's behaviour: the same tests run, and the same ones pass, before and after.
* Where the repo compiles to Java 8 or later, the class goes to JUnit 5 or 6 instead, as decision 0086 says for any
  class repair pairs.

### Consequences

* The work orders' `framework` says `junit3` for these tests once the facts are `external-calls/2`; the repair skill
  converts before it pairs.
* Converting is a mechanical change, so it is a candidate for the toolkit's recipes
  ([Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md));
  until one exists, the AI makes it and a person reviews it.

## More Information

* Builds on: [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md), [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md), [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md)
* Later decisions that build on this: none yet
* Background: none
