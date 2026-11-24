# What the skills produce

Each journey skill's eval case is a small example repo: an orders service, Spring Boot on JDK 8 with JUnit 4, written
to hold known problems (a password in a settings file, a database dump, tests that sleep or are disabled, a call to a
production database). Below, in journey order, is what each skill wrote for its case in one run with the skill, from
round 2 of [the evals](skill-versions-compared.md), and what the runs without the skill got wrong. Each skill's whole
output is in [examples/](examples/).

The cases differ a little from each other, because each holds the facts its own skill needs, so the numbers don't
carry from one section to the next.

## 1. Discovery: the connection list, [draft-the-connection-list](../../.github/skills/draft-the-connection-list/SKILL.md)

**Given:** the airgap agent's reports of every call the tests and the application tried to make off the machine. (This
case is the skill's later pass, merging in measurement's reports; its first pass, from the code with connection-paths,
has no eval case yet.)
**Writes:** `testing/connections.calm.json`, a [CALM](https://calm.finos.org/) file with a node for each system the
code reaches and a proposed stand-in for each connection
([whole file](examples/connections.calm.json)).

```json
{"under-test": {
  "state": "proposed", "drafted_by": "ai",
  "found-by": ["airgap-agent", "settings"],
  "kinds": ["database", "host-lookup"],
  "callers": ["com.example.orders.OrderRepository.connect(OrderRepository.java:41)"],
  "setting": {"name": "spring.datasource.url", "from": "application.yml:12"},
  "tests": 2,
  "stand-in": {"approach": "run-in-container"},
  "never-reach": ["db-orders.prod.example.com"]
}}
```

**Without the skill:** every run left out the systems the plan and the tracker need as nodes, and none marked which
connection must never be reached.

## 1. Discovery: anti-patterns in the existing tests, [find-test-anti-patterns](../../.github/skills/find-test-anti-patterns/SKILL.md)

**Given:** the repo's test code, read only.
**Writes:** the `anti_patterns` section: a count for each kind, and the first three tests of each as `path:line`
([whole file](examples/anti-patterns-assessment.yaml)).

```yaml
anti_patterns:
  findings:
    - id: disabled
      kind: disabled
      tests: 4
      examples: ["src/test/java/com/example/orders/OrderServiceTest.java:35", "src/test/java/com/example/orders/RefundTest.java:13", "src/test/java/com/example/orders/RefundTest.java:18"]
    - id: mocks-everything
      kind: mocks-everything
      tests: 2
      examples: ["src/test/java/com/example/orders/PricingServiceTest.java:23", "src/test/java/com/example/orders/PricingServiceTest.java:30"]
```

**Without the skill:** six of the counts were wrong in every run and a seventh in most, and no run gave its examples
as `path:line`, so the next run couldn't compare them.

## 2. Safety inventory: [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md)

**Given:** gitleaks' reports over the repo and its history, and a list of keystores ever committed.
**Writes:** the `safety` section of the assessment file, one finding for each risk, each with a stable id, what it
does to the first run, and where it is
([whole file](examples/safety-inventory-assessment.yaml)).

```yaml
safety:
  findings:
    - id: credentials-in-jdbc-url-application
      kind: production-credential
      effect: blocks
      what: A database address with the user name and password inside it
      where: ["src/main/resources/application.conf:3"]
    - id: email-addresses-in-data-files-orders
      kind: real-personal-data
      effect: blocks
      what: "Email addresses in a data file: check whether they belong to real people"
      where: ["src/test/resources/orders.csv:2"]
    - id: batch-job-runs-at-start-up-application
      kind: self-starting-job
      effect: neutralise
      what: Spring Batch is set to run its jobs when the application starts
      where: ["src/main/resources/application.properties:6"]
```

**Without the skill:** no run gave the 18 findings ids anything later could follow, and in each round one run
repeated a password, in its reply or in the assessment file.

## 3. Measurement: [measure-a-repo](../../.github/skills/measure-a-repo/SKILL.md)

**Given:** a Gradle repo, the airgap agent and the toolkit's measurement script.
**Writes:** the `tests` and `level` sections from five runs under the agent, with coverage and planted bugs
([whole file](examples/measurement-assessment.yaml)).

```yaml
tests:
  framework: JUnit 4
  count: 6
  runs: 5
  flaky: 1
  failing: 1
  disabled: 1
  line_coverage: 64.7
  branch_coverage: 62.5
  planted_bugs:
    planted: 14
    caught: 5
    targets: "com.example.orders.*"
    left_out: [com.example.orders.MailerTest, com.example.orders.ReminderMarkerTest]
level:
  reached: 0
  evidence:
    - "Built and ran its tests five times on Gradle 6.9.4 and JDK 11, under the airgap agent"
```

**Without the skill:** every run got the starting level wrong, and half measured with a build that could reach
outside the machine.

## 3. Obstacles to testing: [score-obstacles](../../.github/skills/score-obstacles/SKILL.md)

**Given:** the assessment file and connection list so far.
**Writes:** the `obstacles` section, each obstacle scored 0 to 3 by
[the named list](../../decision-guides/0029-the-named-list-of-obstacles-to-testing-and-how-each-is-scored.md), with
its evidence ([whole file](examples/obstacles-assessment.yaml)).

```yaml
obstacles:
  findings:
    - id: may-hold-real-personal-data
      score: 3
      evidence: ["testing/assessment.yaml: safety/fixture-customers"]
    - id: starts-things-by-itself
      score: 2
      evidence: ["testing/assessment.yaml: safety/flyway-at-start", "testing/assessment.yaml: safety/reminder-job"]
```

**Without the skill:** every run left out the evidence for the flaky-tests score.

## 6. Techniques: [choose-techniques](../../.github/skills/choose-techniques/SKILL.md)

**Given:** everything recorded so far, and the rules in each [technique](../../techniques/README.md).
**Writes:** a proposed decision for every technique, adopt, defer or reject, each naming the rule that decided it
([whole file](examples/techniques-assessment.yaml)).

```yaml
  techniques/in-memory-databases:
    state: proposed
    drafted_by: ai
    choice: adopt
    reason: "adopt: 'The code reads or writes a relational database, and the machines local tests run on can't run containers', ..."
  techniques/mutation-testing:
    state: proposed
    drafted_by: ai
    choice: defer
    reason: "defer: 'Flaky suite', 7 tests are flaky in 5 runs. Waits for fix-flaky-tests. Brought back when the flaky tests are fixed (tests.flaky is 0)."
```

**Without the skill:** every run missed adopting in-memory databases and property-based testing, and most missed
deferring machine-state checks.

## 6. Testing plan: [write-the-testing-plan](../../.github/skills/write-the-testing-plan/SKILL.md)

**Given:** the assessment file, with its decisions, and the connection list.
**Writes:** `testing/TESTING-PLAN.md`: the decisions approving it makes, then the work in a fixed order, each piece
with a key the issue tracker can follow ([whole file](examples/TESTING-PLAN.md)).

| Key | Work | Done when |
|---|---|---|
| `orders-service:make-it-run-on-its-own:choose-stand-in-payments-example-com` | Choose what tests use for payments.example.com | The Architecture Owner has decided the stand-in in the connection list |
| `orders-service:make-it-run-on-its-own:tag-reaches-external-system` | Tag the 6 tests that reach an external system, and leave them out of normal runs | No test in a normal run reaches an external system |
| `orders-service:fix-flaky-tests:flaky-tests` | Fix the 7 flaky tests, groups that fail together first | Five runs in a row with no flaky test |

**Without the skill:** no run gave the pieces of work keys a tracker could follow, and none listed the 15 pieces.

## Every step: [render-the-assessment-report](../../.github/skills/render-the-assessment-report/SKILL.md)

**Given:** the assessment file, connection list and source list.
**Writes:** `testing/assessment-report.html`, a single page for the Application Owner showing every decision they can
change, filled from the toolkit's report template
([the page](examples/assessment-report.html): download it and open it in a browser).

**Without the skill:** every run built its own page instead of filling the template, so the page's data never held
the decisions, and some runs didn't escape the text they put in it.
