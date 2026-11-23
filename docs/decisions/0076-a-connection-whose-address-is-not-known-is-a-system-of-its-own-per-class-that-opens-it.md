---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A connection whose address isn't known is a system of its own per class that opens it

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Found from the code before anything runs, many connections have no address yet: it comes from an environment
variable, a JNDI name, a setting the application's installer writes, or is built at run time. On Openfire 4.6.0,
every database address was a setting with no value in the repo. The connection list still needs one entry per system,
each with a stand-in and the tests that may reach it.

## Considered Options

* **A system per class that opens the connection**, after grouping by host and by setting name where those are known
* **A system per kind**: one "database, address unknown" for all of them; two unrelated databases would look like one
  and share a stand-in
* **No system, only a mention in the report**: the tests that may reach it would have nothing to point at

## Decision Outcome

Chosen in discussion: connection points are grouped into systems by host where the address is known; else by the
name of the setting, variable or JNDI name that holds it; else one system per class that opens the connection. A
system without an address records where its address comes from, so a person, or measurement's runs, can fill it in
and merge systems that turn out to be one.

### Consequences

* On Openfire this gives three database systems (one per setting) instead of one per class, and keeps the update
  server, Crowd and server-to-server connections apart.
* Implementations of one interface that a program picks between at run time are marked as alternatives, for a person
  to say whether they are one system.

## More Information

* Builds on: [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md), [connection-paths does everything a program can decide, and the connection-list skill only what needs judgement](0074-connection-paths-does-everything-a-program-can-decide-and-the-connection-list-skill-only-what-needs-judgement.md)
* Later decisions that build on this: none yet
* Background: none
