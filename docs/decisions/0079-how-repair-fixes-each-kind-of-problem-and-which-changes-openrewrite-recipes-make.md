---
status: proposed
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# How repair fixes each kind of problem, and which changes OpenRewrite recipes make

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Repair](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md) changes
only test code. Some of its changes are mechanical once a person has settled what a test needs: tagging a test,
moving a test's bodies into a test interface, renaming a class so the test runner picks it up. Others need judgement:
what a test should assert, what to wait for instead of sleeping.

OpenRewrite changes Java source by recipes that understand types, shows each change as a diff before it is made, and
runs from Maven or Gradle without changing the build. Its core, `rewrite-java` included, is Apache-2.0. Its testing
module, `rewrite-testing-frameworks` (3.27.0 read), is under the Moderne Source Available License, and holds recipes
that help repair (`JUnit4to5Migration`, `JUnit5to6Migration`, `CategoryToTag`, `IgnoreToDisabled`,
`TestMethodsShouldBeVoid`, `LifecycleNonPrivate`, `ReplacePowerMockito`, `Mockito1to5Migration`, `JMockitToMockito`,
`EasyMockToMockito`) and two that work against it: `TestsShouldIncludeAssertions` wraps a test with no assertion in
`assertDoesNotThrow`, which hides the problem instead of fixing it, and `RemoveEmptyTests` deletes tests. Its
`cleanup.BestPractices` bundle includes the first.

## Considered Options

* **The AI makes every change, a person reviews each**  
  Nothing new to build; the same change comes out differently from run to run, and large classes cost many tokens
* **Recipes for the mechanical changes, the AI and a person for the rest**  
  The toolkit's own recipes, on OpenRewrite's Apache-2.0 core, driven by what `testing/tests.yaml` records; named
  recipes from the testing module where an organisation's licence check allows them
* **OpenRewrite's best-practice bundles as they come**  
  Quick, but they include changes that hide or delete tests

## Decision Outcome

Proposed: recipes for the mechanical changes, the AI and a person for the rest.

| Kind | How repair fixes it | By |
|---|---|---|
| Reaches an external system, sorted as logic | Builds the connection's stand-in instead of the real class, where connection-paths' shared chain shows one stand-in covers every test | A recipe, given that place and the stand-in |
| Sorted as the connection itself | Tagged `external` (`@Tag`, or `@Category` on JUnit 4) | A recipe |
| Sorted as both | Its bodies move to a JUnit 5 or 6 test interface, run by one class with the stand-in and one tagged class with the real system | A recipe, after `JUnit4to5Migration` or `JUnit5to6Migration` where allowed |
| Never runs | Renamed so the build's runner picks it up, or made `void` and not `private` or `static` | A recipe (`ChangeType` in the core for the rename) |
| Swallows failures | The catch that does nothing is removed, or fails; the expected-exception idiom is left alone | A recipe |
| Sleeps | Waits for the condition it was sleeping for | The AI, a person reviews |
| Order-dependent | Sets up what it relied on another test for | The AI, a person reviews |
| No real assertion | Asserts what the code computes, until a planted bug that survived is caught | The AI, a person reviews |
| Mocks everything | Mocks of the repo's own classes become the real classes; a mock of a connection becomes its stand-in; a mock stays only where neither exists yet | The AI, a person reviews; `ReplacePowerMockito` and the Mockito upgrades first where allowed |
| Copy-pasted | One copy kept, the rest call shared helpers | The AI, a person reviews |

Repair never runs `TestsShouldIncludeAssertions`, `RemoveEmptyTests` or a bundle that includes either. The toolkit's
recipes live in their own module of [under-test-tools](0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md),
Apache-2.0, depending only on OpenRewrite's Apache-2.0 modules.

### Consequences

* A recipes module in under-test-tools, each recipe with a case in the repair eval's example repo.
* The repair skill runs the recipes and does the rest; the organisation profile says whether the testing module may
  be used, after the licence check in [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md).
* Tried on Openfire 4.6.0's `xmppserver` (Java 8, JUnit 4, Maven 3.6.2), with OpenRewrite's Maven plugin 6.46.1 run
  on JDK 11 by its coordinates, `dryRun`, nothing changed in the build: it compiled and ran no tests, parsed all 1,478
  source files, and wrote a patch for 57 test files in about four minutes. The plugin and OpenRewrite's core declare
  and are compiled for Java 8; a run on a JDK 8 itself is still to be seen.
* `JUnit4to5Migration` converts every test class at once and changes the build: it upgrades Surefire and Mockito
  (2.27 to 4.11), removes JUnit 4, and adds dependencies to the parent POM, reaching modules with no tests. Repair
  therefore makes the build change once, as its own reviewed step that keeps JUnit 4 tests running beside JUnit 5
  ones, and migrates only the classes it twins.
* The testing module's version must match the OpenRewrite core the plugin brings: 3.27.0 with plugin 6.46.1 failed
  in nine files (`NoSuchMethodError` in `MockitoJUnitRunnerToExtension`). Versions are pinned together, as
  OpenRewrite's recipe bill of materials lists them, and the organisation profile names them.

## More Information

* Builds on: [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md), [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)
* Later decisions that build on this: none yet
* Background: [test-doubles](../REFERENCES.md#test-doubles), [mutation-testing](../REFERENCES.md#mutation-testing)
