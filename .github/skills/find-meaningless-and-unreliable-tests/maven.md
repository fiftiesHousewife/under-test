# A Maven build

Read this when the repo builds with Maven: a `pom.xml`, and no Gradle build file.

**Test folders:** `src/test/java` and `src/test/resources`, plus any folder the pom names in `<testSourceDirectory>`
or adds with the build-helper plugin's `add-test-source`. Another `src/<name>/java` folder holds tests that never run.

**Classes the test runner doesn't pick up** count every test under `never-runs`. Unless the pom's Surefire
`<includes>` say otherwise, only classes named `Test*`, `*Test`, `*Tests` or `*TestCase` run, and none that its
`<excludes>` name (such as `**/*FunctionalTest.java`). A class named `*IT` runs
only where the pom configures the Failsafe plugin.

```bash
grep -nE '<testSourceDirectory>|add-test-source|<includes>|<include>|<excludes>|<exclude>|maven-failsafe-plugin|maven-surefire-plugin' pom.xml */pom.xml
```
