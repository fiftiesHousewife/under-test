---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Which of repair's changes OpenRewrite recipes make, and which the AI makes

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

> Narrowed by [Until the toolkit's recipes exist, the AI makes repair's mechanical changes, and each repair says which a recipe should make](0103-until-the-toolkits-recipes-exist-the-ai-makes-repairs-mechanical-changes-and-each-repair-says-which-a-recipe-should-make.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Repair](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md) turns
[every test that reaches an external system into a pair](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md),
changing only test code. Most of that change is mechanical once discovery has recorded where each test reaches the
system: move the test's bodies into a test interface, add the class that injects the stand-in, tag the class that
runs against the real system. Some of it needs judgement: what a recorded response or a fake should return for a
given test, and a test whose code doesn't match the shape a recipe expects.

OpenRewrite changes Java source by recipes that understand types, shows each change as a diff before it is made, and
runs from Maven or Gradle without changing the build. Its core, `rewrite-java` included, is Apache-2.0. Its testing
module, `rewrite-testing-frameworks` (3.27.0 read), is under the Moderne Source Available License, and holds recipes
that help (`JUnit4to5Migration`, `JUnit5to6Migration`, `CategoryToTag`, `IgnoreToDisabled`,
`TestMethodsShouldBeVoid`, `LifecycleNonPrivate`, `ReplacePowerMockito`, `Mockito1to5Migration`, `JMockitToMockito`,
`EasyMockToMockito`) and two that work against the toolkit: `TestsShouldIncludeAssertions` wraps a test with no
assertion in `assertDoesNotThrow`, which hides the problem instead of fixing it, and `RemoveEmptyTests` deletes
tests. Its `cleanup.BestPractices` bundle includes the first.

## Considered Options

* **The AI makes every change, a person reviews each**  
  Nothing new to build; the same change comes out differently from run to run, and large classes cost many tokens
* **Recipes for the mechanical changes, the AI and a person for the rest**  
  The toolkit's own recipes, on OpenRewrite's Apache-2.0 core, driven by what `testing/tests.yaml` and
  connection-paths' record say; named recipes from the testing module where an organisation's licence check allows
  them
* **OpenRewrite's best-practice bundles as they come**  
  Quick, but they include changes that hide or delete tests

## Decision Outcome

Chosen in discussion: recipes for the mechanical changes, the AI and a person for the rest, one external system at a time, each
change a pull request a person reviews.

| Change | By |
|---|---|
| Once per repo: the build runs JUnit 5 or 6 beside JUnit 4, so tests not yet twinned keep running | A person, as its own reviewed change; `JUnit4to5Migration`'s build changes are not used |
| Move a test class's bodies into a test interface, with one method the bodies call for the external system's client; on JUnit 4, a parameterised class instead | A recipe, given the class and the place connection-paths' record names |
| Add the class that implements that method with the stand-in | A recipe, given the stand-in the external systems list chose |
| Add the class that implements it with the real client, tagged `external` (`@Tag`, or switched on by a system property on JUnit 4) | A recipe |
| What the stand-in returns for each test: recorded responses, a fake's data, a container's start-up | The AI, a person reviews |
| A test the recipes can't twin (the client is built where the record names no place, or a framework's settings must change) | The AI, a person reviews; with no place at all, recorded as work for the testing plan |

Repair makes only these changes. The testing plan's work on
[meaningless and unreliable tests](0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)
may later use two more of the toolkit's recipes: one that renames a test class so the build's runner picks it up, or
makes a test method `void` and not `private` or `static`; and one that removes a catch that swallows a failure,
leaving the expected-exception idiom alone. Everything else on those lists is the AI's, with a person reviewing.

No step of the journey runs `TestsShouldIncludeAssertions`, `RemoveEmptyTests` or a bundle that includes either. The
toolkit's recipes live in their own module of
[under-test-tools](0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md),
Apache-2.0, depending only on OpenRewrite's Apache-2.0 modules.

### Consequences

* A recipes module in under-test-tools, each recipe with a before-and-after case, and a case in the repair eval's
  example repo.
* The repair skill runs the recipes and does the rest; the organisation profile says whether the testing module may
  be used, after the licence check in [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md).
* Tried on Openfire 4.6.0's `xmppserver` (Java 8, JUnit 4, Maven 3.6.2), with OpenRewrite's Maven plugin 6.46.1 run
  on JDK 11 by its coordinates, `dryRun`, nothing changed in the build: it compiled and ran no tests, parsed all 1,478
  source files, and wrote a patch for 57 test files in about four minutes. The plugin and OpenRewrite's core declare
  and are compiled for Java 8; a run on a JDK 8 itself is still to be seen.
* `JUnit4to5Migration` converts every test class at once and changes the build: it upgrades Surefire and Mockito
  (2.27 to 4.11), removes JUnit 4, and adds dependencies to the parent POM, reaching modules with no tests. Hence the
  build change made once by a person, and recipes that convert only the classes repair twins.
* The testing module's version must match the OpenRewrite core the plugin brings: 3.27.0 with plugin 6.46.1 failed
  in nine files (`NoSuchMethodError` in `MockitoJUnitRunnerToExtension`). Versions are pinned together, as
  OpenRewrite's recipe bill of materials lists them, and the organisation profile names them.

## More Information

* Builds on: [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md), [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md), [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)
* Later decisions that build on this: [Repair is directed by a work order per external system that under-test-tools writes](0095-repair-is-directed-by-a-work-order-per-external-system-that-under-test-tools-writes.md), [Repair pairs each test that reaches an external system, after measurement, changing only test code](0096-repair-pairs-each-test-that-reaches-an-external-system-after-measurement-changing-only-test-code.md), [Repair converts a JUnit 3 test class to JUnit 4 before pairing it](0102-repair-converts-a-junit-3-test-class-to-junit-4-before-pairing-it.md), [Until the toolkit's recipes exist, the AI makes repair's mechanical changes, and each repair says which a recipe should make](0103-until-the-toolkits-recipes-exist-the-ai-makes-repairs-mechanical-changes-and-each-repair-says-which-a-recipe-should-make.md)
* Background: [test-doubles](../REFERENCES.md#test-doubles)
