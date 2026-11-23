# Discovery: who finds what, in which order

Discovery runs none of the repo's code. Its skills write into the repo's `testing/` files, each skill owning its own
fields, so a later step reads what an earlier one learned instead of searching again
([why](../decisions/0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md)).
Each skill asks which modules to search in a build with more than one, and records the ones it covered
([why](../decisions/0060-the-journey-works-module-by-module.md)).

## In order

| Order | Skill | Reads | Finds | Writes, and owns |
|---|---|---|---|---|
| 1 | [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md) | gitleaks' reports over the history, a list of keystores ever committed | Secrets, production credentials, personal data, jobs that start themselves, file shares, native code | `assessment.yaml`: `safety` |
| 2 | [draft-the-connection-list](../../.github/skills/draft-the-connection-list/SKILL.md) | Production code (PMD), all settings files, Spring XML and Spring Boot's settings, test code and the settings it loads | Every external system the code reaches, its kind, its address or that it is unknown, whether it is needed at start-up; which tests reach each, named or may reach through production code ([why](../decisions/0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md)) | `connections.calm.json`; in `tests.yaml`, each test's connections |
| 3 | [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md) | Test code (PMD and its copy-paste detector), feature files, the build's test folders; the connections step 2 recorded | Every test with a problem, by kind; `reaches-external-system` is counted from step 2, not searched again | In `tests.yaml`, each test's `anti_patterns`; `assessment.yaml`: `anti_patterns` |
| | (no skill) | People | The sources that count for intended behaviour | `sources.yaml` |

Measurement, the first time any code runs, comes next: it leaves out the tests step 2 found reaching external systems,
confirms or clears each one that may reach, and adds flaky and failing tests to `tests.yaml`
([why](../decisions/0059-measurement-leaves-out-external-tests-varies-the-test-order-and-sorts-connection-errors-by-where-they-were-going.md)).

## What each finds a connection by

| Where the connection is | Found by |
|---|---|
| A host in the test's own code | Step 2: a search over test code |
| A host in a file the test loads: properties, YAML, Spring XML, Spring Boot's settings | Step 2: following what the test loads |
| A connection opened in production code: a DAO, a client, a mailer | Step 2: PMD over the main code finds where connections are opened, then the classes that use them, up to the tests. Repos often open connections in one central class, so this finds that class first and follows its callers |
| An address from an environment variable, a system property or JNDI | Step 2: recorded as external, address unknown |
| Anything a search can't follow: reflection, plug-ins loaded by name, an address built at run time | Measurement: the airgap agent refuses the call and reports who made it; without it, a connection error's destination |

## Still being built

* Step 2 as described: today the connection-list skill drafts from the airgap agent's reports, and
  find-test-anti-patterns finds tests' hosts itself.
* What the skill for tests that reach external systems and tests that mock everything does with these lists, after
  discovery and measurement ([why](../decisions/0063-tests-that-reach-external-systems-are-sorted-into-logic-connection-or-both-and-treated-accordingly.md)).
