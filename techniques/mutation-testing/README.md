# Mutation testing

**Workstream: strengthen tests · evidence for test maturity level 4 · tools: PIT (Java), StrykerJS (TypeScript)**

## What it catches

Coverage tells you which lines your tests *ran*. Mutation testing tells you which bugs your tests would *catch*.
PIT makes small changes to the compiled code, such as turning `>=` into `>`, `+` into `-`, or a return value into `0`.
Each changed version is a *mutant*. PIT runs your tests against every mutant:

- a test fails → the mutant is **killed** (good: your tests noticed the bug)
- every test still passes → the mutant **survived** (your tests would miss that bug)

A suite can have 100% line coverage and still let most mutants survive. This example shows exactly that.

## Run the example

```bash
./gradlew :techniques:mutation-testing:pitest -Psuite=weak   # BEFORE: 5 of 13 mutants killed (38%)
./gradlew :techniques:mutation-testing:pitest                # AFTER: 13 of 13 killed (100%)
open techniques/mutation-testing/example/build/reports/pitest/index.html
```

Both suites give 100% line coverage of [`DiscountCalculator`](example/src/main/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculator.java).
In the HTML report, red lines have a surviving mutant. Hover over the number next to a line to see each mutant.

## Walk-through: from weak to strong

[`DiscountCalculatorWeakTest`](example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorWeakTest.java)
shows the five most common weaknesses. Each one has a fix in
[`DiscountCalculatorStrongTest`](example/src/test/java/io/github/fiftieshousewife/undertest/techniques/mutation/DiscountCalculatorStrongTest.java):

| Weakness in the test | Mutant that survives | Fix |
|---|---|---|
| Inputs far from the boundary (`70`, `-1`) | `>= 50` → `> 50`, `< 0` → `<= 0` | Test both sides of every boundary: `0`, `49`, `50`, `99`, `100` |
| Vague assertion (`> 0`) | Returning the wrong percentage | Assert the exact value |
| No assertion at all | `+= 2` → `-= 2` | Every test asserts its result |
| `assertNotNull` on a primitive | Every arithmetic change on the price line | Assert the computed price (`180`, `176`) |

Try it: delete one assertion from the strong suite, re-run PIT, and find the mutant that now survives.

## When to use it, and when not

The rules a planning tool applies are in [`technique.yaml`](technique.yaml). In short:

- **Adopt** when the code already has tests worth strengthening, the tests aren't flaky, and the application's business criticality warrants it.
- **Defer** when coverage is near zero: there's nothing to strengthen yet. Add tests that record current behaviour first.
- **Never** run PIT on a whole large repo. Limit `targetClasses` to the high-risk files, or to the classes changed in a pull request.

## How it fits the programme

- **Measurement run:** a time-limited PIT run on the ten highest-risk files writes `measured.mutation_sample` into the repo's
  assessment file (`testing/assessment.yaml`). It's skipped, and the skip recorded, if coverage is under 20%.
- **Acceptance check (ADR-004):** a AI-written test is kept only if it raises coverage *or kills at least one surviving mutant*.
- **"Strengthen tests" workstream:** PIT runs on the code changed in each pull request and comments with the surviving mutants.
  The AI assistant is asked to strengthen assertions to kill named mutants, and the acceptance check confirms each kill.

## Common mistakes

- **Mutants that can't be killed:** some changes behave exactly like the original code, so no test can tell them apart. Don't chase 100% across a codebase.
- **Flaky tests spoil the score:** a flaky test "kills" mutants at random. Fix flaky tests first.
- **Gaming a fixed score:** a fixed mutation score target gets gamed. ADR-003 proposes "no surviving mutants in key-journey code changed by each pull request" instead.

## Further reading

- PIT: <https://pitest.org/quickstart/>
- Petrović et al., *Practical Mutation Testing at Scale* (Google): mutating only changed code
- Meta, *Mutation-Guided LLM-based Test Generation*: the approach the "strengthen tests" workstream follows
