# Prior art for getting a legacy codebase under test, and how the toolkit uses it

No published method takes an untested legacy codebase from a first look to tests that can be trusted, but the pieces
have strong prior art. Michael Feathers gives a method for each change, and the characterisation test, which records
what code does today, bugs included. Approval testing saves what the code produces and compares every later run
against it. Google's Test Certified programme gives a team levels to reach, starting with measurement. Research covers
test smells (patterns in test code that suggest a problem), flaky tests (tests that pass and fail with no change to the
code) and mutation testing (planting small bugs to see whether the tests catch them). Static analysis research covers
call graphs, which show which methods can call which. Contract tests, which run one set of checks against a fake and
against the real system, keep fakes honest. Meta has published the checks it runs on AI-written tests.

Three parts of the toolkit's [journey](JOURNEY.md) have little or no precedent: **finding, before any test runs, which
tests may reach an external system through the production code**, where one paid tool comes close; the **safety
inventory as a gate before the first run**; and **pairing existing tests that reach external systems**. The
[field trial](decisions/0050-the-journey-is-field-trialled-on-old-releases-of-well-known-public-repos-before-any-organisation-pilot.md)
and the [checks on real public repos](decisions/0097-discovery-is-checked-on-real-repos-against-an-airgap-run-and-the-other-skills-by-a-review-of-a-sample.md)
test them hardest.

| Step | Nearest prior art | Support |
|---|---|---|
| Discovery: meaningless and unreliable tests | Test-smell catalogues; Sonar and PMD rules | Supported; run through PMD with the toolkit's rules |
| Discovery: what the code connects to, and which tests reach it | Static call graphs; one paid tool (Moderne Prethink); open tools that each do one part | Partial; the toolkit's own tool combines them |
| Safety inventory, the gate before the first run | Forum advice: a start-up check that refuses production | None; the toolkit's own |
| Measurement | Test Certified's first level; flaky-test and mutation research | Strong |
| Repair | Abstract test cases (Rainsberger) and test interfaces (JUnit): one set of test bodies run against a stand-in and the real system | Supported; pairing every existing test, and the JUnit 4 form, are the toolkit's own |
| Capture current behaviour | Characterisation and approval tests | Strong |
| Intended behaviour | Characterisation tests as today's specification (Feathers) | Little; drafting requirements from cited sources, with every difference an open question, is the toolkit's own |
| Obstacles and techniques | Measurable success criteria | Partial; no published scoring scheme |
| The work | Feathers' algorithm; test doubles; contract tests | Strong |
| Keeping it there | Test Certified's later levels; mutation results in code review | Supported |

## What changes when AI assistants do the work

The prior art assumes people do the reading and writing. In the toolkit, people work with an AI assistant, and six
things follow.

* **Tools do what a program can decide; the assistant does what needs judgement**
  ([A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](decisions/0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md)).
  The toolkit's own trials showed why. Reading a module's tests to find meaningless ones, an assistant printed whole files
  and its answers varied between runs; PMD with the toolkit's rules read the 61 test files of Openfire's server module in about a second, the
  same way every time. Following the external systems list steps by hand on Openfire, nearly every step was one a program
  does better, so they moved into a tool, [under-test-external-calls](https://github.com/fiftiesHousewife/under-test-external-calls).
* **It searches, then reads only what the searches find,** so no file goes unread on large repos
  ([A skill finds what to read by searching, and reads only what the searches find](decisions/0054-a-skill-finds-what-to-read-by-searching-and-reads-only-what-the-searches-find.md)),
  reading only the instructions for the kind of repo in front of it
  ([A skill keeps each kind of repo in its own file, and reads only the ones that apply](decisions/0056-a-skill-keeps-each-kind-of-repo-in-its-own-file-and-reads-only-the-ones-that-apply.md)),
  one module at a time ([The journey works module by module](decisions/0060-the-journey-works-module-by-module.md)).
  It reads a tool's output through queries, never by printing it whole.
* **It drafts, and people confirm**
  ([People do the work with AI coding assistance, and review everything it produces](../decision-guides/0005-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md)).
  In Google's AI-assisted test migrations, human review, not generation, set the pace
  ([Google](https://arxiv.org/html/2501.06972v1)).
* **Its tests pass checks before a person sees them** (see [Tests written by AI](#tests-written-by-ai)).
* **Skills are evaluated against known answers, with and without the skill**
  ([Skill evals run on a clean copy of the whole toolkit, which is the plugin, so skills can read its files](decisions/0047-skill-evals-run-on-a-clean-copy-of-the-whole-toolkit-which-is-the-plugin-so-skills-can-read-its-files.md)),
  and checked on real public repos: discovery against a run under the airgap agent, the other skills by a person's
  review of a sample
  ([Discovery is checked on real repos against an airgap run, and the other skills by a review of a sample](decisions/0097-discovery-is-checked-on-real-repos-against-an-airgap-run-and-the-other-skills-by-a-review-of-a-sample.md)).
  One replication found a plain model matched or beat several specialised test-writing tools
  ([replication](https://arxiv.org/html/2601.09695v1)), so a skill has to show what it adds.
* **Results vary from run to run,** even for identical requests ([Ouyang et al.](https://arxiv.org/html/2308.02828v2)),
  so each evaluation runs five times each way, and the mechanical steps that varied most became tools.

## Discovery: meaningless and unreliable tests

**Prior art.** Developers mostly discount smells about readability: one study found 87.5% rated low severity
([Campos et al.](https://arxiv.org/pdf/2107.13902)). Problems that make results vary matter more. In 51 Apache
projects, asynchronous waits, concurrency and test order caused 77% of fixed flaky tests, a typical case being
`Thread.sleep(2000)` waiting for a server
([Luo et al.](https://huang.isis.vanderbilt.edu/cs8395/paper/flakytest.pdf)). Disabled tests stay disabled: 41% are
never resolved ([Kim et al.](https://petertsehsun.github.io/papers/fse2021_disabled_test.pdf)). The toolkit's
kinds are about whether a test can be trusted: meaningless tests pass whatever the code does, and unreliable ones may
give a different answer on another run. Each kind has names in the
[Open Catalog of Test Smells](https://test-smell-catalog.readthedocs.io/en/latest/), and checks in Sonar and PMD:

| Toolkit's kind | Names in the literature and the tools |
|---|---|
| `never-runs`, `disabled` | Unknown Test, Commented Test, Ignored Test; Sonar's JUnit 5 tests silently skipped for being private, static or returning a value ([S5810](https://raw.githubusercontent.com/SonarSource/sonar-java/master/sonar-java-plugin/src/main/resources/org/sonar/l10n/java/rules/java/S5810.html)); PMD's JUnit 3-style method that never runs ([PMD](https://pmd.github.io/pmd/pmd_rules_java_bestpractices.html)) |
| `no-real-assertion` | Assertionless Test, Empty Test; Sonar's `assertThat(x)` or `verify(mock)` with nothing after it ([S2970](https://raw.githubusercontent.com/SonarSource/sonar-java/master/sonar-java-plugin/src/main/resources/org/sonar/l10n/java/rules/java/S2970.html)) |
| `swallows-failures` | Exception Catching Throwing, in tsDetect's catalogue; a test that catches `AssertionError` or `Throwable` and does nothing with it cannot fail |
| `sleeps` | Sleepy Test |
| `order-dependent` | Order Dependent Tests, Test Run War |
| `mocks-everything` | Excessive Mocking |

A search finds a test with no assertion but cannot prove one weak. Methods whose bodies can be removed without any
test failing turn up everywhere ([Vera-Pérez et al.](https://ar5iv.arxiv.org/html/1807.05030)), and only planted bugs
find them, so discovery's searches and measurement's planted bugs are both needed.

**In the toolkit.** [find-meaningless-and-unreliable-tests](../.github/skills/find-meaningless-and-unreliable-tests/SKILL.md) runs PMD with the
toolkit's rules, then reads only the methods PMD flags
([find-test-anti-patterns runs PMD with the toolkit's rules and searches only what PMD cannot read](decisions/0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md)),
and records each kind
([Meaningless and unreliable tests are recorded and triaged, and no existing test is deleted before the approval-test baseline exists](../decision-guides/0059-meaningless-and-unreliable-tests-are-recorded-and-triaged-and-no-existing-test-is-deleted-before-the-approval-test-baseline-exists.md)).
Every test something is learned about goes into one list, keyed by class and name, which later steps add to instead of
searching again
([The tests something is recorded about are kept in one list, each step adding its own fields](decisions/0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md)).
Packages are ranked by change frequency times size, after Adam Tornhill's "hotspot" analysis, which finds a small share
of files takes most of the change
([Software (r)Evolution](https://adamtornhill.com/articles/software-revolution/part1/index.html)).

**Real code corrects the rules.** Run over Openfire 4.6.0's server module, three of the toolkit's rules misread real
code that the example repo never had: a `test...` helper that a test calls, flagged as never running; `assertNull` as
the check itself, flagged as weak; a `catch (Throwable)` that records the exception for a later assertion, flagged as
swallowing it. Each was fixed and added to the example repo, which is why tools and skills are also checked on real
repos.

**With an AI assistant.** Assistants find smells, but not reliably alone: the best model in one study scored 80.32%
against a detector's labels ([Santana et al.](https://arxiv.org/abs/2506.07594)). So PMD finds, the assistant reads
each hit it can't settle, and the skill is checked against known answers rather than by its own results
([Panichella et al.](https://pure.tudelft.nl/ws/portalfiles/portal/137994226/s10664_022_10207_5.pdf)).

## Discovery: what the code connects to, and which tests reach it

Test-smell detectors find a test that names a host in its own body (Mystery Guest, Resource Optimism), and look no
further ([testsmells.org](https://testsmells.org/pages/testsmells.html)). Most tests in old code reach a database or a
service through the production code: a test of an order service that ends in a JDBC call three classes down. Finding
those before any test runs needs a call graph, which records which methods can call which, walked back from every
place a connection is opened to the tests.

**Class level is not enough.** A graph of which classes use which, built by searching, marked 356 of Openfire's 426
tests (84%) as reaching the database, for every kind of connection alike. Three classes joined everything up: a logging
class used by 260 others, the server class (192) and the settings class (151); a test that logs anything "reached" the
database. A plan built on that would treat almost every test as external.

**Method level, and its known trade-offs.** Static call graphs for object-oriented code resolve a call through an
interface to the methods that may answer it. Class hierarchy analysis takes every overriding method in the class
hierarchy ([Dean, Grove and Chambers](https://doi.org/10.1007/3-540-49538-X_5)); rapid type analysis keeps only
classes the program creates ([Bacon and Sweeney](https://doi.org/10.1145/236337.236371)); points-to analyses go
further at more cost. Practical analyses are knowingly unsound for reflection and similar dynamic features, which their
authors call "soundiness" ([Livshits et al.](https://doi.org/10.1145/2644805)), and studies of Java call graph tools
find each misses edges from such features
([Reif et al.](https://doi.org/10.1145/3293882.3330555); [Sui et al.](https://doi.org/10.1145/3377811.3380441)). So a
static graph says which tests **may** reach a system, and the first run confirms or clears each one.

On Openfire, two rules made the method-level graph useful. Following calls through the JDK's own interfaces (`Map.put`
into a project class that extends a map) marked 260 of 415 tests; not following them, 155. And calls through
dispatch points with many implementations ("notify every registered listener", "every packet handler") marked every
test as opening a socket; reporting dispatch points with more than three implementations instead of following them took
that from 169 tests to none, while the database paths, through an interface with three implementations, stayed.

**The tools.** No free tool finds a Java program's connections, their addresses and the tests that reach them. Checked
for use inside a company, on private code, on Windows without admin rights:

| Tool | Connections | Addresses | Tests that reach them | Fit |
|---|---|---|---|---|
| [Moderne Prethink](https://docs.moderne.io/user-documentation/agent-tools/prethink) | Databases, HTTP, messaging | Not documented | A test-to-code mapping | Closest, but proprietary: Moderne licence only ([licensing](https://docs.openrewrite.org/licensing/openrewrite-licensing)) |
| [OpenRewrite](https://docs.moderne.io/user-documentation/recipes/recipe-catalog/core/findcallgraph), open source (Apache-2.0) | From method patterns we supply | No | One row per call; chains and interfaces are ours to follow | Runs through the build's Maven or Gradle plug-in |
| [jQAssistant](https://github.com/jQAssistant/jqassistant) (GPL-3.0) | By our own graph queries | No | By queries over compiled classes | Needs a graph database and its query language |
| [CodeQL](https://github.com/github/codeql/pull/12081) | Models for JDBC URLs, opened URLs and more | Partly | Yes | Paid for private code ([licence](https://github.com/github/codeql-cli-binaries/blob/main/LICENSE.md)) |
| [Joern](https://docs.joern.io/frontends/java/) (Apache-2.0) | By queries | No | Method-level graph from source | Scala; a 1.8 GB distribution, or about 90 MB of libraries assembled by hand |
| [codeanalyzer-java](https://github.com/codellm-devkit/codeanalyzer-java) (Apache-2.0) | JPA only | No | Partly | Needs Linux, macOS or WSL |
| [Konveyor](https://github.com/konveyor/kantra/blob/main/docs/containerless.md), Red Hat MTA, [Azure AppCAT](https://learn.microsoft.com/azure/migrate/appcat/java-preview) | Technology tags, as file and line | No | No | Migration assessment, not test planning |
| [Semgrep](https://docs.semgrep.dev/semgrep-pro-vs-oss) | Patterns | No | Cross-file only in the paid edition | — |
| [SootUp](https://soot-oss.github.io/SootUp/latest/call-graph-construction/), WALA, OPAL, [java-callgraph](https://github.com/gousiosg/java-callgraph), [jdeps](https://docs.oracle.com/en/java/javase/21/docs/specs/man/jdeps.html) | — | — | Call graphs from compiled classes | Libraries to build on, or class level only |
| [Teamscale](https://docs.teamscale.com/howto/providing-testwise-coverage), OpenClover | — | — | Per-test coverage | Only by running the tests |

**Compared on Openfire.** OpenRewrite's open-source call graph, walked with the toolkit's rules, against
under-test-external-calls, on Openfire's server module with the same classpath:

| | under-test-external-calls | OpenRewrite's tables |
|---|---|---|
| Time | 20 s, one jar | 1 min 45 s, through the Maven plug-in |
| Calls resolved | 99.8% | all, from the compiler's own types; 33 files flagged as partly extracted |
| Tests reaching a reach point from their own body | 122 | the same 122 |
| Tests reaching one through set-up methods and fields | 40 more | can't tell: the tables hold no annotations, and no calls from field initialisers |
| Reach points | 54 | 37: the tables hold only the repo's own class hierarchy, so a call on a library's subclass (`CloseableHttpClient.execute`) can't match a rule on `HttpClient` |
| Where an address comes from | traced from the syntax tree | nothing to trace it from |

An adapter over OpenRewrite would have to rebuild most of under-test-external-calls, so the toolkit builds its own, on
JavaParser's symbol solver, and borrows the connection-call lists of Prethink's and Konveyor's documented detectors
(under-test-external-calls' [decision](https://github.com/fiftiesHousewife/under-test-external-calls/blob/main/docs/decisions/0005-connection-paths-is-built-not-adopted-after-checking-the-existing-tools.md)).
The comparison also found two mail calls the toolkit's rules had missed.

**In the toolkit.** [under-test-external-calls](https://github.com/fiftiesHousewife/under-test-external-calls) reads a module's source
with the classpath its build resolves (building without running tests is allowed before the safety gate:
[why](decisions/0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md)). It finds every
reach point, walks the graph back to the tests, follows set-up methods and field initialisers, and reports what it
couldn't resolve and the dispatch points it didn't follow. On Openfire's server module 230 of 415 tests have a chain
of calls to a reach point, and those reaching the database all go through one shared chain, the calls every such test
goes through (the test kit's fixtures, the settings class, the connection manager), which is what a plan needs: one
stand-in covers them all. Graded from the address each test's own settings give, all 230 cannot reach
([Each test is graded reaches, may reach or cannot reach, from the address its own settings give](decisions/0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md)).
[draft-the-external-systems-list](../.github/skills/draft-the-external-systems-list/SKILL.md) runs it, settles what the tool
can't, and drafts the external systems list, one system per host, else per setting, else per class that opens it
([A connection whose address isn't known is a system of its own per class that opens it](decisions/0076-a-connection-whose-address-is-not-known-is-a-system-of-its-own-per-class-that-opens-it.md)).
Measurement's first run then confirms or clears each test; the
[airgap agent](https://github.com/fiftiesHousewife/under-test-airgap), where approved, catches what no static graph
can: reflection, beans wired only in XML, addresses built at run time.

**With an AI assistant.** The tool decides; the assistant reads its facts by query, traces the few addresses the tool
couldn't, and asks a person about alternatives (two database providers a program chooses between at run time) and
placeholder values (`YOUR-CROWD-SERVER` in a shipped settings file).

## Safety inventory: the gate before the first run

**Prior art.** No published source makes production safety a step of its own; the legacy-code literature assumes code
runs safely in a test harness. The nearest advice comes from forums: a check at test start-up that refuses production,
and test credentials production rejects
([python-list](https://www.python.org/pipermail/python-list/2013-March/792574.html);
[hoop.dev](https://hoop.dev/blog/your-integration-tests-are-lying-to-you/)). No source names jobs that start
themselves, such as schedulers started when a Spring context loads, though a characterisation test that loads the
context starts them.

**In the toolkit.** [run-the-safety-inventory](../.github/skills/run-the-safety-inventory/SKILL.md) turns a secrets
scan of the whole history, and searches for keystores, production credentials, real personal data, jobs that start
themselves and build tasks that deploy, into findings, some of which block every run
([Before any test or application runs, a safety inventory records what could reach production or real data, and some findings block the run](../decision-guides/0057-before-any-test-or-application-runs-a-safety-inventory-records-what-could-reach-production-or-real-data-and-some-findings-block-the-run.md)).
It runs alongside discovery and is settled before any test or the application runs; discovery itself runs nothing but
the build ([The safety inventory is a gate before the first run, and no skill ever copies a secret](decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)),
and later runs happen only where production can't be reached
([Old code runs first only where production cannot be reached](../decision-guides/0008-old-code-runs-first-only-where-production-cannot-be-reached.md)).

**With an AI assistant.** The assistant reads scan reports and never repeats a secret. In the skill's evaluation, a
run with the skill passed all 25 checks; a run without it passed 2 and wrote the passwords it found into its reply.

## Measurement

**Prior art.** Test Certified's first level was "setting up the tools necessary to measure the current state of
affairs"; its author calls it the most important, because teams began improving once they could see the numbers
([Mike Bland](https://mike-bland.com/2011/10/18/test-certified.html)). Measuring needs a stable suite: PIT, which plants
bugs and counts how many the tests catch, refuses a suite that is not passing, as does the flaky-test tool iDFlakies
([PIT FAQ](https://pitest.org/faq/); [Lam et al., iDFlakies](https://par.nsf.gov/servlets/purl/10101224)). AI
assistants copy the flakiness of tests in front of them, and the researchers advise fixing flaky tests first
([study](https://arxiv.org/abs/2601.08998)). So the existing suite is measured before anything is added.

**Old code often doesn't build at first.** Openfire 4.6.0 is a well-kept project, yet one of its libraries is now in
only one of the Maven repositories its build names, and another of those refuses it; a module also depends on a
sibling module that was never published. So measurement goes in stages, each gating the next, and a repo that stops
after any stage still has a result
([Measurement runs in stages, each gating the next: build, one run, repeats, then planted bugs](decisions/0070-measurement-runs-in-stages-each-gating-the-next-build-one-run-repeats-then-planted-bugs.md)).

**Order matters more than the number of runs.** In iDFlakies' sample, 50.5% of flaky tests depended on test order,
which reruns in one order "cannot detect". Lam et al. advise more orders with fewer runs each, and about five reruns
to confirm a suspect failure ([Lam et al., reruns](https://par.nsf.gov/servlets/purl/10273112)).

**Blocking the network follows Google's test sizes:** small tests get no network, medium tests only the machine itself,
large tests are kept apart ([Software Engineering at Google, ch. 11](https://abseil.io/resources/swe-book/html/ch11.html)).
By that model, a connection refused on `localhost` is a missing local service, not an external system.

**Coverage finds untested code; planted bugs judge the tests**
([Inozemtseva and Holmes](https://cs.ubc.ca/~rtholmes/papers/icse_2014_inozemtseva.pdf);
[Just et al.](https://homes.cs.washington.edu/~mernst/pubs/mutation-effectiveness-fse2014-abstract.html)). Google
computes no whole-codebase score ([Petrović et al.](https://arxiv.org/abs/2102.11378)), and PIT advises targeting the
packages of interest.

**In the toolkit.** [measure-a-repo](../.github/skills/measure-a-repo/SKILL.md) is the first run of the repo's tests.
It builds; runs every test once, leaving out by filter the tests discovery found reaching external systems; runs the
tests that passed once reversed and three times shuffled with a recorded seed, rerunning each failure to tell flaky,
order-dependent and always-failing tests apart; and sorts connection errors by destination, off the machine being
external and `localhost` set-up work
([Measurement leaves out external tests, varies the test order, and sorts connection errors by where they were going](decisions/0059-measurement-leaves-out-external-tests-varies-the-test-order-and-sorts-connection-errors-by-where-they-were-going.md)).
Maven's test runner runs every test when no exclude is set
([JUnit 4 wiki](https://github.com/junit-team/junit4/wiki/Categories)), so a run with its filter missing stops. Planted
bugs are counted per module, in key packages proposed from the change history where a module is large
([Planted bugs are counted per module, in key packages proposed from the change history](decisions/0061-planted-bugs-are-counted-per-module-in-key-packages-proposed-from-the-change-history.md)).

**With an AI assistant.** The tools measure; the assistant records each flaky, failing or left-out test by name.

## Capturing current behaviour

**Prior art.** A characterisation test records "the actual behavior of a piece of code", because "when a system goes
into production, in a way, it becomes its own specification"
([Feathers](https://michaelfeathers.silvrback.com/characterization-testing)). Approval tests (also called snapshot or
golden master tests) "quickly put Legacy Code under tests" ([Carlo](https://understandlegacycode.com/approval-tests);
[Emily Bache](https://automation.eurostarsoftwaretesting.com/event/2025/get-in-control-of-legacy-code-with-approval-testing/)).
The recipe is a loop: snapshot simple inputs, widen them until coverage is complete, then break each line and confirm a
snapshot fails
([Carlo, 3 steps](https://understandlegacycode.com/blog/3-steps-to-add-tests-on-existing-code-when-you-have-short-deadlines/)).
Pasting today's output into an assertion can make a test that always passes, so the check is to break the code
([Mark Seemann](https://blog.ploeh.dk/2025/11/03/empirical-characterization-testing/)).

**In the toolkit.** Behaviour is captured at the code's edges and cleaned where it was captured
([Order of preference for where current behaviour is captured](../decision-guides/0061-order-of-preference-for-where-current-behaviour-is-captured.md)).
The approval tests get the same checks as measurement.

**With an AI assistant.** The assistant can list input values for combination approvals, where the tool tries every
combination ([8th Light](https://8thlight.com/insights/add-approval-testing-to-your-toolbox)), and the tests it is
shown are already known to be stable.

## Measuring again

Measurement runs again with the same settings, so what the captured tests add shows up as a change in coverage and
planted bugs caught: the approval-testing loop, with the existing suite as its baseline.

## Obstacles, intended behaviour and techniques

No published scheme scores a repo's obstacles to testing. The nearest is measurable success criteria set up front, one
problem at a time ([Carlo, on Bellotti](https://understandlegacycode.com/blog/key-points-of-kill-it-with-fire)).
[score-obstacles](../.github/skills/score-obstacles/SKILL.md) scores from what is recorded, and
[choose-techniques](../.github/skills/choose-techniques/SKILL.md) traces each proposal to the rule that decided it. The
assistant drafts rules of intended behaviour from cited sources, and every difference from today's behaviour becomes
an open question
([Current and intended behaviour are recorded side by side, and every difference is an open question](../decision-guides/0033-current-and-intended-behaviour-are-recorded-side-by-side-and-every-difference-is-an-open-question.md)).
The scoring is the toolkit's own; its test is whether different runs, and people, score a repo the same way. The plan
is then generated and approved, as Test Certified had peers sign off each level.

## The work

Feathers' legacy code change algorithm runs: identify change points, find test points, break dependencies, write
tests, make the change and refactor
([Agile in a Flash](https://agileinaflash.blogspot.com/2009/03/legacy-code-change-algorithm.html)). It starts from the
next change, so it fits inside the toolkit's
[workstreams](../decision-guides/0050-the-order-of-workstreams-for-a-repo.md). People write tests with AI help, and
each AI-written test passes the [checks below](#tests-written-by-ai). Tests that reach external systems are
[paired](#tests-that-reach-external-systems). Some have no seam, Feathers' word for a place where behaviour
can be changed without editing the code there; what to do then is [still open](#what-is-still-open).

## Keeping it there

Test Certified's later levels were a written policy that "essentially forbade anyone from submitting untested code",
then "low tolerance for broken or flaky tests". New problems arrive with new tests: smells usually come in when a test
is first committed ([Tufano et al.](https://www.cs.wm.edu/~denys/pubs/ASE'16-TestSmells.pdf)), and 78% of flaky tests
are flaky from the day they are written (Luo et al.). At Google, planted-bug results in code review rated useful rose
from 20% to 80% as feedback shaped them
([Petrović and Ivanković](https://web.eecs.umich.edu/~weimerw/2022-481W/readings/mutation-google.pdf)). The toolkit
re-measures on a schedule
([How often repos are re-scanned and re-measured](../decision-guides/0056-how-often-repos-are-re-scanned-and-re-measured.md)),
[mutation testing in pull requests reports only at first](../decision-guides/0055-mutation-testing-in-pull-requests-reports-only-at-first.md),
and every new AI-written test meets the same checks, so the suite does not slide back.

## Tests written by AI

**Meta's filters, and their gap.** Meta's TestGen-LLM keeps an AI-written test only if it builds, passes, passes five
of five repeat runs, and raises line coverage; a person then reviews it
([TestGen-LLM](https://arxiv.org/html/2402.09171)). It improved 196 of 1,979 classes, and engineers accepted 73% of the
improvements. **Nothing checked whether assertions were right or whether a test could find a bug;** a reviewer caught
a test with no assertion.

**Planted bugs as the guide.** MuTAP feeds surviving planted bugs back to the model
([MuTAP](https://arxiv.org/abs/2308.16557)). Meta's later ACH plants bugs current tests miss, then writes tests to
catch them; engineers accepted 73% of those ([ACH](https://arxiv.org/abs/2501.12862)).

| Failure | Evidence |
|---|---|
| Assertions record today's bugs | AI-written expected values mainly capture what the code does, bugs included ([study](https://arxiv.org/abs/2410.21136)) |
| Made-up classes and methods | About 7.2% of class-level suites compiled without repair; "cannot find symbol" caused most errors ([Ouédraogo et al.](https://arxiv.org/html/2407.00225v4)) |
| Missing assertions | The test TestGen-LLM's reviewer caught |
| Copied flakiness and smells | 63% of flaky AI-written database tests relied on a collection with no fixed order ([study](https://arxiv.org/abs/2601.08998)); AI-written tests repeat the smells of the tests they learned from ([study](https://arxiv.org/html/2410.10628v2)) |

No peer-reviewed study evaluates AI-written approval tests; practitioners advise proving they can fail by planting
bugs ([DEV Community](https://dev.to/tmfrisinger/characterization-tests-are-how-agents-enter-legacy-code-2e48)).

**In the toolkit**
([The checks an AI-written test must pass before it is kept](../decision-guides/0047-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md)),
a kept test compiles, passes five runs in a row with outbound calls blocked, asserts more than "is not null", and is
labelled AI-written and as recording current or intended behaviour. **A test checking intended behaviour is kept only
if it catches a planted bug nothing caught before,** closing the gap Meta named. A test recording current behaviour may
be kept on raised coverage, since recording today's behaviour is its purpose. The label stops anyone mistaking a record
of today's bugs for what the system should do, and a test expecting different behaviour goes to
[triage](../decision-guides/0048-ai-written-tests-that-expect-different-behaviour-go-to-triage-not-the-bin.md). People
review every test, as with TestGen-LLM and ACH.

## Tests that reach external systems

Discovery finds which tests may reach an external system ([above](#discovery-what-the-code-connects-to-and-which-tests-reach-it));
measurement confirms them. What happens to them then has less precedent. A test double is a stand-in for a real dependency: a fake (a working, simplified version), a stub (canned answers) or
a mock (which also checks how it was called).

**The order of preference.** Google prefers the real implementation, then a fake, then stubs used sparingly, then
checks of how a mock was called; mocking frameworks "required constant effort to maintain while rarely finding bugs"
([Software Engineering at Google, ch. 13](https://abseil.io/resources/swe-book/html/ch13.html)). The toolkit leans
towards doubles because its machines cannot run containers or reach the systems, not because doubles are better; its
[order of preference](../decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md) puts a container
first where one can run. Among doubles, the prior art favours a fake over a mock.

**Every external test a pair.** Each test that reaches an external system becomes two runs of one set of test
bodies: one against the stand-in in normal runs, one against the real system under the `external` tag
([Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](decisions/0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md)).
The literature names three kinds of such test: J. B. Rainsberger's collaboration test (logic that happens to touch a
system), Martin Fowler's [narrow integration test](https://martinfowler.com/bliki/IntegrationTest.html) (the
connection itself: SQL, HTTP mapping, mail format), and the contract test (both). Google separates size (what a test
reaches) from scope (how much code it checks). **No published procedure sorts an existing suite into these kinds,**
and sorting needs a judgement per test; pairing every test needs none, keeps every test's real run, and costs a
larger external suite, run on a schedule. "External" matches the tag of
Google's build tool, Bazel
([An external system is one on another machine that a test cannot run without](decisions/0098-an-external-system-is-one-on-another-machine-that-a-test-cannot-run-without.md)).

**Contract tests keep fakes honest.** Here a contract test runs one set of checks against both the double and the real
system, unlike contract testing with Pact, where two teams agree a request and response. Google says "a fake must have
its own tests", run against "both the real implementation and the fake"; Rainsberger builds them as
[abstract test cases](https://blog.thecodewhisperer.com/permalink/abstract-test-cases-20-years-later), and JUnit
documents test interfaces "for interface contracts"
([JUnit](https://docs.junit.org/current/writing-tests/test-interfaces-and-default-methods.html)). No official source
documents a JUnit 4 form, so the toolkit's parameterised class is its own pattern.

**Why H2 is only for logic.** The maintainer of H2, an in-memory database, says "H2 is not an emulator of other
databases" ([H2 mailing list](https://groups.google.com/g/h2-database/c/W0Gr8n3Toj0)). It may stand in where a test
checks logic, but cannot show SQL works on the real product
([An in-memory database of a different product never counts as evidence](../decision-guides/0038-an-in-memory-database-of-a-different-product-never-counts-as-evidence.md)).

**A schedule and an owner.** Fowler runs contract tests outside the normal pipeline ("often running just once a day is
plenty") and has a failure "trigger a task" rather than break the build
([ContractTest](https://martinfowler.com/bliki/ContractTest.html)). Doubles drift, and Rainsberger's answer is to "rely
on the human to pay attention and check". A tagged set nobody runs protects nothing. So each external system's external
tests have a schedule (daily by default), a place that can reach the system's test instance, and a named owner; a
failure opens a work item and never breaks a normal build
([Tests that reach external systems are tagged and left out of normal runs](../decision-guides/0041-tests-that-reach-external-systems-are-tagged-and-left-out-of-normal-runs.md)).

## The limits of the evidence, and false confidence to avoid

The larger risk is false confidence, not a missing step. Four things read as stronger evidence than they are:

* **A clean five-run report.** A test failing one time in ten shows both results in five runs only about 41% of the
  time; one failing one time in a hundred, about 5%. Studies running suites thousands of times keep finding new flaky
  tests ([Parry et al.](https://philmcminn.com/publications/parry2021.pdf)). The result is "flaky tests found in five
  runs", a lower bound, never "no flaky tests".
* **A high coverage figure.** Coverage correlates only weakly with finding faults once suite size is controlled.
  Planted bugs do better, though the link weakens once suite size is controlled
  ([Papadakis et al.](https://orbilu.uni.lu/handle/10993/34950)), and coverage that varies between runs moves the score
  by about four points ([Shi et al.](https://par.nsf.gov/servlets/purl/10104340)).
* **A static list of the tests that reach external systems.** A call graph both over-reaches (an interface with
  several implementations, a code path a test never takes) and misses (reflection, beans wired only in XML, addresses
  built at run time). "May reach" is a plan to check, not a finding, until the first run confirms or clears it.
* **A passing AI-written test.** Its expected values confirm what the code does today.

No study evaluates the safety inventory, the pairing of external tests, blocking the network inside the JVM,
AI-written approval tests, or how often review catches a wrong assertion.

**Palomba and Zaidman's journal paper on test smells and flaky tests, "The smell of fear", was retracted by its
authors** ([retraction note](https://www.springerprofessional.de/en/retraction-note-retraction-note-to-the-smell-of-fear-on-the-rela/17835682)).
Do not cite it. Figures that sources back only with slides, search snippets or secondary summaries are left out.

## What is still open

* **Where an external test has no seam.** Feathers breaks dependencies before writing tests, with low-risk moves such
  as sprout and wrap ([Carlo, on Feathers](https://understandlegacycode.com/blog/key-points-of-working-effectively-with-legacy-code/)),
  and calls it risky work needing care. Until the field trial shows which option would have handled each case, the
  skill stops and records the refactoring as work
  ([What repair does where a test that reaches an external system has no place to inject a stand-in](decisions/0064-what-repair-does-where-a-test-that-reaches-an-external-system-has-no-place-to-inject-a-stand-in.md)).
* **How complete the static list is beyond HTTP, FTP and Telnet.** The static list has now been compared with runs
  of every test under the airgap agent on four public repos
  ([Checking discovery against a run under the airgap agent](design/checking-discovery-against-a-run-under-the-airgap-agent.md)):
  no test that called out was missed, and on three of them none was graded may reach or cannot reach. But the tests
  that called out reached only HTTP, FTP and Telnet hosts. Whether it finds every test that reaches the other kinds,
  such as databases and directories, is still to be checked on repos whose tests reach them.
* **Reach points that no call matches.** Clients declared as annotated interfaces (Feign, some JAX-RS clients) have no
  supertype for a rule to match, and need a rule on the annotation.
* **The full record of which tests catch each planted bug.** PIT stops at the first, and its documentation calls the
  full record partially supported, with no stated cost. The field trial tries it on one module, with its run time.
* **The mocks-everything threshold has no published basis.** Developers say excessive mocking hides design problems,
  but no study gives a number
  ([Spadini et al.](https://repository.tudelft.nl/record/uuid:a0b02521-ad00-4f96-9d96-17a85dc23f99)). The toolkit's
  five mocks should be calibrated from an organisation's repos, or replaced by a count with no cut-off.
* **Which other steps become tools.** Most skills have mechanical steps (turning reports into the assessment file,
  applying the techniques' rules, generating the plan); each becomes a sub-command of one tool
  ([why](decisions/0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md)),
  one at a time, in the order the journey runs.
* **Smaller additions still to come:**
  * Unstable output removed from approval tests; keeping them (Feathers) or retiring them after the change (Carlo).
  * A written policy that new code comes with tests, and checks on new tests at commit time.
  * Stand-ins and test frameworks pinned to each JDK line: JUnit 6 needs Java 17
    ([release notes](https://docs.junit.org/6.0.0/release-notes.html)).
  * The skill evaluations re-run, against a plain assistant, whenever the approved model changes.
