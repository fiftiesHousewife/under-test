# Measurement

[`measure.init.gradle`](measure.init.gradle) measures any Gradle build's tests without changing the build: Gradle
5.6 or later, any JDK the build already uses. It adds:

* **coverage** with JaCoCo, as an XML report;
* **flaky tests:** each run's JUnit results kept apart in `build/under-test/runs/<n>/`, so the runs can be compared,
  with the tests a file names left out of a run, and JUnit 5 or 6 tests run in an order from a seed;
* **planted bugs** with PIT, run from its own command line so it works on every Gradle version, in a
  `measurePlantedBugs` task.

Test failures don't stop a run: they are what's being measured. JaCoCo and PIT come through the build's own
repositories, so the organisation's proxy and package repository still apply.

**It refuses to run tests without the [airgap agent](https://github.com/fiftiesHousewife/under-test-airgap)**, so
no test reaches the network. Use it together with the agent's own init script. Only on a CI runner with no route
out can it run without the agent, by passing `-Dmeasure.network=blocked-by-runner`. PIT's own process only reads
class files; the tests it runs get the agent, with their own report in `build/airgap/measurePlantedBugs/`.

The [measure-a-repo](../../.github/skills/measure-a-repo/SKILL.md) skill runs it in stages, each gating the next:
the build, one run, four repeats, then planted bugs.

```bash
I='--init-script airgap.init.gradle --init-script measure.init.gradle'

# The build: compile the code and tests, running none
./gradlew clean testClasses $I

# One run, leaving out the tests the leave-out file names (those graded reaches), and writing the coverage report
./gradlew test jacocoTestReport -Dmeasure.run=1 -Dmeasure.leaveOut=build/under-test/leave-out.txt $I

# Four repeats, with the tests that failed in run 1 added to the leave-out file, each in an order from its own seed
./gradlew test -Dmeasure.run=2 -Dmeasure.order.seed=2 -Dmeasure.leaveOut=build/under-test/leave-out.txt $I
# ...and so on to run 5, seed 5

# Planted bugs, leaving out the tests that were flaky or failing in the runs
./gradlew measurePlantedBugs -Dmeasure.targets='com.example.orders.*' \
    -Dmeasure.excludedTests='com.example.orders.MailerTest,com.example.orders.ReminderMarkerTest' \
    $I
```

| Setting | What it does |
|---|---|
| `-Dmeasure.run=<n>` | Keeps this run's results, and the airgap agent's report of the calls it refused, in `build/under-test/runs/<n>/<test task>/` |
| `-Dmeasure.leaveOut=<file>` | Leaves out the tests the file names, one `Class.method` a line; the run stops if the file is missing |
| `-Dmeasure.order.seed=<n>` | Runs JUnit 5 or 6 classes and methods in a random order from this seed; JUnit 4 tests keep their order |
| `-Dmeasure.targets=<globs>` | The classes to plant bugs in (default: the project's group, then `.*`) |
| `-Dmeasure.excludedTests=<globs>` | Test classes PIT leaves out |
| `-Dmeasure.java=<path>` | The `java` that runs PIT, which needs JDK 11 or later, when the build runs on JDK 8 |
| `-Dmeasure.network=blocked-by-runner` | Runs without the airgap agent, on a CI runner with no route out |
| `-Dmeasure.jacoco.version`, `-Dmeasure.pit.version`, `-Dmeasure.pit.junit5.version` | Tool versions |

PIT needs every test it uses to pass. It leaves out any test that fails without a planted bug, and the
[measure-a-repo](../../.github/skills/measure-a-repo/SKILL.md) skill also leaves out the flaky ones by name. A flaky
test that happens to fail during the run would otherwise "catch" planted bugs at random.

The [sample repo](sample-repo/) is an invented old-style build: Java 8 source, JUnit 4, with a flaky test, a disabled
test, a test with no assertion and one that tries to send mail. It is tried with Gradle 6.9 on JDK 11 and Gradle 9 on
JDK 21, and the results are in [the skill's trial](../../docs/skill-evaluations/measure-a-repo.md).

Maven builds need no script, since the JaCoCo and PIT Maven plugins run from the command line. The measure-a-repo
skill doesn't cover Maven yet: running Maven's tests under the airgap agent without also blocking Maven's own
downloads is still to be tried.
