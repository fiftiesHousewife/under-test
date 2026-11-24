# Discovery: who finds what, in which order

Discovery runs none of the repo's tests or application; only its build may run, to resolve dependencies or compile
([why](../decisions/0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md)). Its skills write
into the repo's `testing/` files, each skill owning its own fields, so a later step reads what an earlier one learned
instead of searching again
([why](../decisions/0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md)).
Each skill asks which modules to cover in a build with more than one, and records the ones it covered
([why](../decisions/0060-the-journey-works-module-by-module.md)). What a program can decide the same way every time is
done by a tool, and the skill keeps the judgement
([why](../decisions/0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)).

## In order

| Order | Skill | Runs | Finds | Writes, and owns |
|---|---|---|---|---|
| 1 | [draft-the-external-systems-list](../../.github/skills/draft-the-external-systems-list/SKILL.md) | the build's test compile; [connection-paths](https://github.com/fiftiesHousewife/connection-paths) | Every place the code opens or uses a connection, each connection's address (or where it will come from), the systems they make, and every test that may reach one, with the chain of calls ([why](../decisions/0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md)) | `external-systems.calm.json`; `connection-paths.json`; in `tests.yaml`, each test's `connections` |
| 2 | [find-meaningless-and-unreliable-tests](../../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) | PMD with the toolkit's rules | Meaningless tests (never run, can't fail, check only their mocks) and unreliable ones (sleep, depend on order) ([why](../decisions/0080-discovery-keeps-three-lists-of-tests-apart-those-that-reach-external-systems-meaningless-tests-and-unreliable-tests.md)) | In `tests.yaml`, each test's `meaningless` and `unreliable`; `assessment.yaml`: `meaningless_tests`, `unreliable_tests` |
| | (no skill) | — | The sources that count for intended behaviour | `sources.yaml` |

Alongside, and settled before any test runs: [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md)
turns gitleaks' reports and a list of keystores ever committed into `assessment.yaml`'s `safety` section. It is the
gate before the first run of any test or the application
([why](../decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

Measurement, the first time any test runs, comes next, in stages: build, one run, repeats, planted bugs
([why](../decisions/0070-measurement-runs-in-stages-each-gating-the-next-build-one-run-repeats-then-planted-bugs.md)).
Its one run leaves out the tests step 1 found reaching external systems, confirms or clears each one that may reach,
and adds flaky and failing tests to `tests.yaml`.

## How each kind of connection is found

| Where the connection is | Found by |
|---|---|
| Opened in production code: a DAO, a client, a mailer, several classes down from the test | connection-paths: the call graph from each test, through interfaces with few implementations, to the call that opens it |
| A host in the test's own code | The external systems list skill: a search over test code |
| A host in a file the test loads: properties, YAML, Spring XML, Spring Boot's settings | The external systems list skill: following what the test loads |
| An address from a setting, an environment variable, a system property or JNDI | connection-paths traces it; the skill looks the setting up, or records where it will come from ([why](../decisions/0076-a-connection-whose-address-is-not-known-is-a-system-of-its-own-per-class-that-opens-it.md)) |
| Dispatch points with many implementations (listeners, handlers, plug-ins) | connection-paths reports them instead of following them; a person looks at the largest |
| Anything a search can't follow: reflection, beans wired only in XML, code loaded by name, an address built at run time | Measurement: the airgap agent refuses the call and reports who made it; without it, a connection error's destination |

## Still being built

* [under-test-tools](https://github.com/fiftiesHousewife/under-test-tools)' `meaningless-and-unreliable`, which does
  find-meaningless-and-unreliable-tests' mechanical steps and gives the eval's known answers, is built but not yet
  published; the skill uses it when its jar is there
  ([proposed packaging](../decisions/0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md)).
* An eval case for the external systems list's pass from the code, from what Openfire showed.
* The repair step, which reads these lists after measurement: each test that reaches an external system becomes a
  pair, one injecting a stand-in and one tagged external
  ([why](../decisions/0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md)).

How maintainers check, on real repos, that this step finds every test that reaches another machine:
[Checking discovery against a run under the airgap agent](checking-discovery-against-a-run-under-the-airgap-agent.md).
