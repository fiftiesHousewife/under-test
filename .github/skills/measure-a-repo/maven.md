# Measuring a Maven repo

Read this when the repo builds with Maven (a `pom.xml`, no Gradle build file). The stages, what each reads and what
each writes are those of [SKILL.md](SKILL.md); only the commands and where the reports land differ
([why](../../../docs/decisions/0104-a-maven-repos-tests-get-the-airgap-agent-from-its-maven-extension-named-on-the-command-line.md),
[and](../../../docs/decisions/0049-a-maven-repo-is-measured-with-the-agents-in-java-tool-options-and-jacoco-and-pit-run-from-the-command-line.md)).
Never change a pom or `.mvn/`.

## Before the stages

**Who runs Maven.** Maven needs its dependencies and plugins from the package repository. Where your commands can't
reach it, give the person each command to run in their own terminal, then read what it wrote.

**Maven** is the repo's `./mvnw` if it has one, else `mvn`; `M` below. **Surefire** must be 2.19 or later (it leaves
out tests by `!` patterns from then): `M help:effective-pom | grep -A1 maven-surefire-plugin`. If it is older, say so
and stop.

**The airgap agent** comes from its Maven extension, named for each run, never in `.mvn/extensions.xml`. Put the three
jars, `airgap-maven-extension`, `airgap-agent` and `airgap-junit` (`io.github.fiftieshousewife.airgap`, one version),
in one folder from the organisation's package repository (or Maven Central); `X` below is
`-Dmaven.ext.class.path=<extension jar>:<agent jar>:<junit jar>`. Its reports go to
`<module>/target/airgap/<plugin>-<execution>/calls.jsonl`. If the build warns that a module runs its tests in Maven's
own JVM (`forkCount=0`), say so and stop: those need the agent in `JAVA_TOOL_OPTIONS` for Maven itself, which this
page doesn't cover yet.

**First, without the agent and running nothing,** fetch everything the stages need, so every later run is offline
(`-o`):

```bash
M -B dependency:go-offline
M -B dependency:get -Dartifact=org.jacoco:jacoco-maven-plugin:0.8.16
M -B dependency:get -Dartifact=org.pitest:pitest-maven:1.30.2
```

`R <n>` below means: after the run, copy `target/surefire-reports/` and `target/airgap/` of each module to
`build/under-test/runs/<n>/<module>/`, so the next run doesn't overwrite them. The stages read their reports there, as
they read Gradle's `build/under-test/runs/<n>/<task>/`.

## The stages' commands

| Stage | Command |
|---|---|
| Build | `M -o -B X clean test-compile` |
| One run | `M -o -B X org.jacoco:jacoco-maven-plugin:0.8.16:prepare-agent test org.jacoco:jacoco-maven-plugin:0.8.16:report -Djacoco.destFile=$PWD/build/under-test/jacoco.exec -Djacoco.dataFile=$PWD/build/under-test/jacoco.exec -Dsurefire.excludesFile=$PWD/build/under-test/leave-out.surefire`, then `R 1` and copy `target/site/jacoco/jacoco.xml` beside it |
| Repeats | `M -o -B X test -Dsurefire.excludesFile=$PWD/build/under-test/leave-out.surefire -Dsurefire.runOrder=random -Dsurefire.runOrder.random.seed=<n>`, then `R <n>`, for n = 2 to 5 |
| A rerun alone | `M -o -B X test -Dtest='<Class>#<method>' -Dsurefire.failIfNoSpecifiedTests=false`, then `R <test>-<k>` |
| Planted bugs | `M -o -B X org.pitest:pitest-maven:1.30.2:mutationCoverage -DtargetClasses='<targets>' -DexcludedTestClasses='<left out classes>' -DoutputFormats=XML -DtimestampedReports=false`; the mutations are in `target/pit-reports/mutations.xml` |

* **Leaving tests out:** `build/under-test/leave-out.surefire` holds one line, `**/<Class with / for .>.java#<method>`,
  for each line of the leave-out file SKILL.md's stages write (empty when it is). An excludes file adds to the pom's own
  `<excludes>`, where `-Dtest` would replace them and run classes the build leaves out on purpose. After each run,
  check that no left-out test is in its reports; if one is, stop and say so.
* **The order:** Surefire's `runOrder=random` with a seed (Surefire 3.0.0-M6 or later) orders the test classes, not
  the methods within them. With an older Surefire, or JUnit 4, the order is kept, and `order_seeds` is `[]`, as
  SKILL.md says.
* **Planted bugs on JUnit 5 or 6** need PIT's JUnit 5 plugin, which can't be added from the command line: say so, and
  stop before this stage.
* **A multi-module build** gives each module's reports under its own `target/`; read every module's. `<targets>` is
  `<groupId>.*` for each module's `groupId`, by the same rule as SKILL.md's.
