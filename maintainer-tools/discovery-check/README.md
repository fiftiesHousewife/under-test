# Discovery check (for toolkit maintainers)

Scripts for [checking discovery against a run under the airgap agent](../../docs/design/checking-discovery-against-a-run-under-the-airgap-agent.md):
run every test of a field-trial repo under the airgap agent, refusing every call to another machine, and compare what
each test tried to reach with under-test-external-calls' facts.

| Script | What it does |
|---|---|
| `airgap-named.init.gradle` | Runs a Gradle build's tests under the agent, with its JUnit listener so each call names its test; failures don't stop the run |
| `run-junit-under-airgap.sh` | Runs a Maven module's compiled tests on the JUnit Platform under the agent, without the build |
| `compare.py` | Compares a facts file with the agent's `calls.jsonl`: recall, precision, grades, and each miss named |

Gradle:

```bash
./gradlew test --init-script maintainer-tools/discovery-check/airgap-named.init.gradle \
  -Dairgap.agent=<airgap-agent jar> -Dairgap.junit=<airgap-junit jar> -Dairgap.project=<package prefix> \
  [-Dmockito.agent=<mockito-core jar>] [-Dairgap.enableDisabled=true]
```

| Property | What it does |
|---|---|
| `-Dairgap.agent` | The airgap agent's jar. Required: the run stops at once with a message naming it if it is missing |
| `-Dairgap.junit` | The airgap-junit jar, put on the test classpath so each call names its test. Required, like `airgap.agent` |
| `-Dairgap.project` | The package prefix of the repo's own code, so the agent can tell its calls from the libraries' |
| `-Dmockito.agent` | The mockito-core jar, loaded as an agent at start, for machines that refuse Mockito's usual self-attach |
| `-Dairgap.enableDisabled=true` | Runs tests marked `@Disabled` too (JUnit 5 and later), by setting the test system property `junit.jupiter.conditions.deactivate=org.junit.*DisabledCondition` |

Each test task's report is `build/airgap/<task name>/calls.jsonl`; no report means no refused calls.

Maven, after the test compile:

```bash
JAVA=<java> AIRGAP_AGENT=<airgap-agent jar> AIRGAP_JUNIT=<airgap-junit jar> JUNIT_CONSOLE=<console standalone jar> \
  [ENABLE_DISABLED=1] [TEST_CLASSES=<folder>] [MAIN_CLASSES=<folder>] \
  maintainer-tools/discovery-check/run-junit-under-airgap.sh <module> <classpath file> <package prefix> <out folder>
```

`TEST_CLASSES` and `MAIN_CLASSES` name the compiled classes, relative to the module or absolute, and default to
Maven's `target/test-classes` and `target/classes`. The script exits with the test run's own status.

Then compare. Only calls the agent refused, of the kinds that go to another machine (`tcp`, `udp`, `database`,
`http`, `jndi`, `mail`, `host-lookup`), count: calls to the machine itself are allowed. Test names are matched as
`Class.method`, without a parameter list or an `[n]` invocation:

```bash
python3 -I maintainer-tools/discovery-check/compare.py <facts file> <calls.jsonl>
```

Only the field trial's public repos run this way, without a safety inventory first, and always under the airgap agent
refusing every call to another machine
([why](../../docs/decisions/0089-the-field-trials-public-repos-run-their-tests-under-the-airgap-agent-without-a-safety-inventory-first.md)).
Every other repo goes through the safety inventory before any of its tests run.
