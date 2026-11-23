---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Connections and the test paths to them are found by connection-paths, a JavaParser tool in its own repo

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The connection list finds, before any code runs, every external system the code reaches and which tests reach each
([why](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md)).
Finding which tests reach a connection opened deep in production code needs a call graph. An AI assistant tracing it
by reading is slow, costly and different every time. On one module of Openfire 4.6.0 (788 files, 415 tests), a
class-level graph marked 84% of tests, because logging and settings classes join everything up; only a method-level
graph gives a number a plan can use.

## Considered Options

* **A small Java tool on JavaParser and its symbol solver, in its own repo**  
  Plain Java, about 6 MB of libraries, reads source only; tried on Openfire: 20 seconds, 0.4% of calls unresolved
  once the module's dependency jars were given, chains that read as real
* **Joern**  
  Builds method-level graphs from source and is Apache-2.0, but brings Scala and about 90 MB, or 1.8 GB for its
  distribution, and its query glue is Scala
* **CodeQL**  
  The most precise without a build, but free only for open-source code
* **Tools that read compiled classes** (java-callgraph, SootUp, WALA, jdeps)  
  Need a build, which discovery doesn't do
* **A class-level graph from searches**  
  Marked 84% of Openfire's tests; no use for planning

## Decision Outcome

Chosen in discussion: [connection-paths](https://github.com/fiftiesHousewife/connection-paths), a command-line jar in
its own repo, following [the toolkit is AI first](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md). It reads a module's source and its dependency jars, which come from the
organisation's package repository by reading the build files, never by running the build. It writes a facts file,
with a schema in this toolkit: each place a connection is opened and its kind, each test that may reach one and a
chain of calls showing how, the calls it could not resolve and why, and the dispatch points it did not follow.

It follows a call through an interface to the implementations in the repo, except through the JDK's own interfaces,
and except at dispatch points with many implementations (listeners, handlers, plug-ins), which it reports instead: on
Openfire, following those marked every test as reaching a socket through "notify every listener". Set-up methods and
field initialisers count as part of a test.

### Consequences

* The connection-list skill runs it and turns its facts into the connection list and each test's connections in
  `testing/tests.yaml`; reading settings, Spring XML and Spring Boot's settings stays in the skill.
* Its first version leaves out reflection, beans made only in XML, and overloads with the same number of parameters;
  measurement confirms or clears every test it marks.
* It is checked like the skills: an example repo with known chains, and real public repos reviewed by a person
  ([why](0071-every-skill-and-tool-is-also-checked-against-real-public-repos-by-a-persons-review-of-a-sample.md)).

## More Information

* Builds on: [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md)
* Later decisions that build on this: none yet
* Background: none
