# Cucumber feature files

Read this when the test folders hold `.feature` files.

* **A test** is each scenario (its line is its `Scenario:` or `Example:` line), and each row of a Scenario Outline's
  examples (its line is the row's; the heading row isn't a test).
* A Cucumber runner class (`@RunWith(Cucumber.class)`, or `@Suite` with Cucumber options) holds no tests itself.
* **The only kind counted** for a scenario is `disabled`: the scenario or its feature has the tag `@ignore` or
  `@disabled`, in any case.
* In `testing/anti-pattern-tests.yaml`, its `name` is `<feature file>: <scenario title>`, with the row's line for an
  examples row. In the report, give how many of the tests are scenarios and example rows.

```bash
grep -rnE '^\s*(Scenario|Example):' --include='*.feature' <test folders>
grep -rnE '^\s*Scenario (Outline|Template):|^\s*Examples:|^\s*\|' --include='*.feature' <test folders>
grep -rniE '@(ignore|disabled)\b' --include='*.feature' <test folders>
```
