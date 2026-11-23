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
| 1 | [draft-the-connection-list](../../.github/skills/draft-the-connection-list/SKILL.md) | the build's dependency resolution; [connection-paths](https://github.com/fiftiesHousewife/connection-paths) | Every place the code opens or uses a connection, each connection's address (or where it will come from), the systems they make, and every test that may reach one, with the chain of calls ([why](../decisions/0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md)) | `connections.calm.json`; `connection-paths.json`; in `tests.yaml`, each test's `connections` |
| 2 | [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | PMD with the toolkit's rules, and its copy-paste detector | Every test with a problem, by kind; `reaches-external-system` from step 1's record ([why](../decisions/0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md)) | In `tests.yaml`, each test's `anti_patterns`; `assessment.yaml`: `anti_patterns` |
| | (no skill) | — | The sources that count for intended behaviour | `sources.yaml` |

Alongside, and settled before anything runs: [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md)
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
| A host in the test's own code | The connection-list skill: a search over test code |
| A host in a file the test loads: properties, YAML, Spring XML, Spring Boot's settings | The connection-list skill: following what the test loads |
| An address from a setting, an environment variable, a system property or JNDI | connection-paths traces it; the skill looks the setting up, or records where it will come from ([why](../decisions/0076-a-connection-whose-address-is-not-known-is-a-system-of-its-own-per-class-that-opens-it.md)) |
| Dispatch points with many implementations (listeners, handlers, plug-ins) | connection-paths reports them instead of following them; a person looks at the largest |
| Anything a search can't follow: reflection, beans wired only in XML, code loaded by name, an address built at run time | Measurement: the airgap agent refuses the call and reports who made it; without it, a connection error's destination |

## Still being built

* connection-paths tracing addresses, marking local connections and proposing systems
  ([why](../decisions/0074-connection-paths-does-everything-a-program-can-decide-and-the-connection-list-skill-only-what-needs-judgement.md));
  until then the connection-list skill does those steps by reading.
* find-test-anti-patterns reading `reaches-external-system` from the connection list's record; it still finds
  hosts itself.
* A tool for find-test-anti-patterns' mechanical steps
  ([proposed](../decisions/0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md)).
* What the skill for tests that reach external systems and tests that mock everything does with these lists, after
  discovery and measurement ([why](../decisions/0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md)).
