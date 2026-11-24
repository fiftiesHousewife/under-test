---
runs: 5
max_turns: 60
timeout_seconds: 1800
allowed_tools: [Read, Glob, Grep, Write, Edit, Bash, Skill]
---
Measure this repo's tests: does it build, which tests are flaky over five runs, line and branch coverage, how many
planted bugs (mutation testing) the tests catch, and the mix of test types. Write the results into the `tests` and
`level` sections of `testing/assessment.yaml`, which must match `.toolkit/schema/assessment.schema.json`, and each
test's outcome into `testing/tests.yaml`, which must match `.toolkit/schema/tests.schema.json`; leave the other
sections and fields as they are.

Every run of the repo's code must be under the airgap agent, which blocks network calls: pass
`--init-script .airgap/airgap.init.gradle` (it finds the agent's jar by itself). Use the repo's Gradle wrapper. The
under-test toolkit is installed in `.toolkit/`. Don't change the repo's build files or tests. Then tell me briefly
what you found.
