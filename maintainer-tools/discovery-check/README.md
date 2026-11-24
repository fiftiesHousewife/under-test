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
  [-Dmockito.agent=<mockito-core jar>]
```

Maven, after the test compile:

```bash
JAVA=<java> AIRGAP_AGENT=<airgap-agent jar> AIRGAP_JUNIT=<airgap-junit jar> JUNIT_CONSOLE=<console standalone jar> \
  [ENABLE_DISABLED=1] maintainer-tools/discovery-check/run-junit-under-airgap.sh <module> <classpath file> <package prefix> <out folder>
```

Then:

```bash
python3 -I maintainer-tools/discovery-check/compare.py <facts file> <calls.jsonl>
```

Only on the field trial's public repos: never on another repo whose safety inventory isn't clean.
