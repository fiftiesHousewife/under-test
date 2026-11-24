---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# An external system is one on another machine that a test cannot run without

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[The toolkit calls a system a test cannot run without an external system](0062-the-toolkit-calls-a-system-a-test-cannot-run-without-an-external-system.md).
It used to call them "shared systems"; people using it found "external" clearer, and it matches the `external` tag
of Bazel, Google's build tool. That definition takes in a database or server on the test's own machine, which a test
also can't run without. But
[only a system on another machine reaches out](0090-only-a-system-on-another-machine-reaches-out-and-a-test-needing-a-service-on-its-own-machine-is-found-by-failing.md):
the grades treat an address on the test's own machine as local, the airgap agent allows calls to the machine itself,
and repair pairs only the tests that reach other machines. The word and the rules no longer say the same thing.

## Considered Options

* **An external system is one on another machine that a test cannot run without**  
  The word matches the grades, the airgap agent and repair
* **Any system a test cannot run without, a service on its own machine included**  
  The earlier definition; a local database would be an external system that nothing in the journey treats as one
* **Keep "shared system"**  
  Less clear to the people using the toolkit, and no build tool uses it

## Decision Outcome

Chosen in discussion: an external system is a system on another machine that a test cannot run without: a database,
a service, a mail server, a directory, a queue, a file share, or the host of another program. Tests that reach one are
tagged `external`.

A service on the test's own machine is not an external system. A test that needs one that isn't running fails in
measurement and goes to the testing plan, as
[Only a system on another machine reaches out, and a test needing a service on its own machine is found by failing](0090-only-a-system-on-another-machine-reaches-out-and-a-test-needing-a-service-on-its-own-machine-is-found-by-failing.md)
says.

This replaces [The toolkit calls a system a test cannot run without an external system](0062-the-toolkit-calls-a-system-a-test-cannot-run-without-an-external-system.md).

### Consequences

* The [glossary](../../GLOSSARY.md)'s entry for "external system" says "on another machine", and names the host of
  another program among the kinds.
* Skills, schemas and decision guides that define the word follow the glossary.

## More Information

* Builds on: [We write in plain English using the agreed word list](0020-we-write-in-plain-english-using-the-agreed-word-list.md), [Only a system on another machine reaches out, and a test needing a service on its own machine is found by failing](0090-only-a-system-on-another-machine-reaches-out-and-a-test-needing-a-service-on-its-own-machine-is-found-by-failing.md)
* Later decisions that build on this: none yet
* Background: none
