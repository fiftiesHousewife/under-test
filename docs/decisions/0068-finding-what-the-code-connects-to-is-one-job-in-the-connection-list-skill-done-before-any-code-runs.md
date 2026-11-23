---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Finding what the code connects to is one job, in the connection-list skill, done before any code runs

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

find-test-anti-patterns finds tests that reach external systems through their own code and the settings they load,
Spring XML and Spring Boot's included. It can't see a connection opened inside production code: a test that calls a
DAO which opens its own database connection names nothing. The airgap agent catches those, but only when the code
runs, in measurement, and only for tests that run. The connection list was to be drafted from settings files, which
would follow the same settings and Spring rules again, so two skills would answer the same question and could
disagree.

## Considered Options

* **One job, in the connection-list skill, before find-test-anti-patterns**  
  It finds every external system, from production code and all settings, and which tests reach each, named or may-reach
  through production code; find-test-anti-patterns counts what it recorded
* **One job, in find-test-anti-patterns**  
  Keeps the tuned skill as the owner, but makes it about two things
* **Both, with different fields**  
  The same settings and Spring rules followed in two places

## Decision Outcome

Chosen in discussion: one job, in the connection-list skill, run first in discovery. It runs no code. In three passes:

1. **Where production code opens a connection,** found by PMD with a toolkit ruleset over the main code: the
   framework calls (JDBC, JPA, HTTP clients, mail, LDAP, JMS and other queues) and, beneath them, the public JDK calls
   that reach what the airgap agent intercepts (sockets, host lookups, JNDI, starting a process, loading native code),
   so discovery looks wherever the agent would refuse.
2. **Where each connection's address comes from:** a literal, a setting (followed through properties, YAML, Spring XML
   and Spring Boot's settings, profiles included), a Spring bean, or an environment variable, system property or JNDI
   name (external, address unknown). Connections needed at start-up (a Spring context, a static block, a
   `@BeforeClass`) are marked, since they block whole groups of tests.
3. **Which tests reach each,** named by the test or the settings it loads, or **may reach** it through production
   code, with the chain of classes from the test to the connection as evidence.

Each test's connections go into `testing/tests.yaml` in a field this skill owns. find-test-anti-patterns no longer
looks for hosts: its `reaches-external-system` counts the tests the connection list recorded. Measurement confirms or
clears each may-reach, from the airgap agent's report or, without it, from the destination of a connection error.

The kind of system (database, http, mail, directory, queue, file share) is what a stand-in needs, and is the
toolkit's vocabulary; the airgap agent's kinds describe the mechanism it caught (host-lookup, tcp, udp, jndi,
process, native-library, exit), and both are recorded where known. The agent's planned system kinds should use the
toolkit's names.

### Consequences

* The connection-list skill takes the Spring Boot and Spring XML rules and their eval checks from
  find-test-anti-patterns, and its eval case gains a DAO opening its own connection, a client building its own HTTP
  call, a test reaching them two classes deep, and a connection needed at start-up.
* The static ruleset's JDK calls follow the airgap agent's hooks (its `Hook.java`), so the two stay aligned.
* The journey runs the connection list before counting anti-patterns.

## More Information

* Builds on: [The tests something is recorded about are kept in one list, each step adding its own fields](0057-the-tests-something-is-recorded-about-are-kept-in-one-list-each-step-adding-its-own-fields.md), [find-test-anti-patterns runs PMD with the toolkit's rules, and searches only what PMD cannot read](0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md), [Risky calls on developer machines are refused and reported by the airgap agent, built in its own repo](0036-risky-calls-on-developer-machines-are-refused-and-reported-by-the-airgap-agent-built-in-its-own-repo.md)
* Later decisions that build on this: none yet
* Background: the airgap agent's [design](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/docs/design.md)
