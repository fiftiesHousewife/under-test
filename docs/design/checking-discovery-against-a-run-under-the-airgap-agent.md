# Checking discovery against a run under the airgap agent

How toolkit maintainers check that the external systems list finds every test that reaches another machine, and
grades each one right, on real repos
([why](../decisions/0088-the-external-systems-list-is-checked-on-real-repos-against-a-run-of-every-test-under-the-airgap-agent.md)).
Discovery reads the source and runs no test. The check then runs every test under the
[airgap agent](https://github.com/fiftiesHousewife/under-test-airgap), which refuses every call to another machine and
records it with the test that made it, and compares the two test by test.

The repos are the field trial's old releases of public projects, whose tests run without a safety inventory first
([why](../decisions/0089-the-field-trials-public-repos-run-their-tests-under-the-airgap-agent-without-a-safety-inventory-first.md)).
Never run any other repo's tests this way.

## What it measures

| Measure | Meaning |
|---|---|
| Recall | Of the tests that tried to reach another machine, how many have a chain from under-test-external-calls. A miss is a test that called out with no chain |
| Precision | Of the tests with a chain, how many tried to reach another machine. The rest are false alarms |
| Grades | Whether the tests that called out are graded reaches or may reach, and none cannot reach; and how many graded reaches really called out |

A test graded may reach that made no call is cleared by measurement's one run, so it is safe but costs a run. A test
graded cannot reach that called out is the serious fault, and so is a miss.

## What you need

* The repo, built: its classes and test classes compiled (the build may compile; nothing runs yet).
* The jars its tests compile against, from the same compile
  ([the external systems list skill](../../.github/skills/draft-the-external-systems-list/SKILL.md) has the command
  for Maven and for Gradle).
* under-test-external-calls' jar, built from the commit being checked.
* The airgap agent's jar and its JUnit listener (`airgap-agent-<version>.jar`, `airgap-junit-<version>.jar`).
* For a repo built with Maven: `junit-platform-console-standalone` 1.10 or later, which includes the engine that runs
  JUnit 4 tests.
* The scripts in [`maintainer-tools/discovery-check/`](../../maintainer-tools/discovery-check/README.md).

## Steps

1. **Run under-test-external-calls** on the module with that classpath, as the external systems list skill does, writing the
   facts file outside the repo.
2. **Run every test under the agent**, with `mode=refuse` and the listener on the test classpath, so each call names
   its test:
   * Gradle: the build's `test` task with `airgap-named.init.gradle`.
   * Maven: `run-junit-under-airgap.sh`, which runs the compiled tests on the JUnit Platform without the build.
   * With JUnit 5 or later, set `ENABLE_DISABLED=1` (Maven) or pass the same JUnit setting
     (`junit.jupiter.conditions.deactivate=org.junit.*DisabledCondition`), so tests marked disabled run too.
3. **Check the run is a real run:** the console's counts (tests found, passed, failed, skipped), and that the agent
   started (its report folder exists). A report that is missing means no risky call was made, not that the agent
   didn't run, but only once the agent is known to start on that JDK: a one-line program that looks up
   `example.com` under it must be refused and reported.
4. **Compare:** `python3 -I compare.py <facts file> <calls.jsonl>`. It prints every target called and by how many
   tests, recall with each missed test named, precision, and each test graded cannot reach that called out.
5. **Read what it names:** each missed test's call and the code that made it (the report's `caller` and `stack`);
   each wrong grade's chain in the facts file; and each group of false alarms, by the point and the chain's first
   steps they share. Say why for each: a rule that's missing, an address not followed, a stand-in not recognised.
6. **Record and send:** write the counts and causes in the repo's notes, and send each cause to under-test-external-calls as a
   fault, with the repo, the file and line, and the tests it affects. Run the check again on the same repos when
   under-test-external-calls changes.

## When a run goes wrong

| Symptom | Cause | Fix |
|---|---|---|
| Tests can't find their settings files ("does conf/openfire.xml exist in the test classpath") | They look them up through `ClassLoader.getSystemResource`, and the classes are on the launcher's class path, not the JVM's | Put everything on the JVM's `-cp`, as `run-junit-under-airgap.sh` does |
| The run stops making progress, with macOS window-server messages | Code that draws images starts AWT | `-Djava.awt.headless=true` |
| Mockito fails with `AttachNotSupportedException` | The machine refuses the attach socket Mockito uses to install itself | Load Mockito as an agent at start: `-Dmockito.agent=<mockito-core jar>` with the Gradle script |
| Gradle: "Failed to load JUnit Platform" after adding the listener | The test task's classpath was replaced, dropping the launcher | Add the listener as a `testRuntimeOnly` dependency, as the script does |
| Calls with no test named | The listener isn't on the test classpath | Add `airgap-junit` |

## Results so far

With under-test-external-calls 990003c. "Flagged" is graded reaches or may reach.

| Repo | Tests run | Tests that called out | Missed (no chain) | Flagged but made no outside call | What still causes them |
|---|---|---|---|---|---|
| Openfire 4.6.0, `xmppserver` (Maven, JUnit 4) | 461: 448 passed, 13 skipped | 0 | none to miss | 1 of 230 with a chain | A call through `XMPPServer.getInstance()`, which is null in tests |
| spring-petclinic (Gradle, Spring Boot) | 81: 77 passed, 4 skipped (no Docker) | 0 | none to miss | 0 of 22 with a chain | — |
| jsoup 1.15.3 (Maven, JUnit 5), disabled tests run | 1,165: 1,124 passed, 41 failed | 40, to 20 hosts | 0 | 13 of 53 flagged | 4 go through a proxy on localhost, so reach the outside only through another program the agent can't see: reaches is right for them. 1 throws before connecting; 8 are graded may reach and clear in a run |

On jsoup, 39 of the 44 graded reaches called out. One test that called out is graded may reach, not reaches: its host is
an internationalised name (`räksmörgås.josefsson.org`).

A test that reaches the outside only through a proxy on the same machine makes no call the agent can see: the proxy,
another program, makes it. Such a test is graded reaches, and the check counts it as a false alarm; read those by
hand.
