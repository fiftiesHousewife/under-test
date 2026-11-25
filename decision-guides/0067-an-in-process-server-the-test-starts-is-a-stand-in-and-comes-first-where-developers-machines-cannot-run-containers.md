---
status: proposed
decision-makers: Technical Architect
group: Standing in for real systems
---

# An in-process server the test starts is a stand-in, and comes first where developers' machines can't run containers

**Decided by:** Technical Architect · **Status:** proposed

*This is a decision guide for adopting organisations. Each organisation accepts, narrows or replaces it in its own organisation repo.*

## Context and Problem Statement

[Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md)
lists a container, recorded responses, a contract, a fake behind an interface, a shared test environment and
accepting the risk. It has no place for a server the test starts in its own JVM on a port of this machine: an
in-memory LDAP directory, GreenMail for mail, MockFtpServer for FTP, or a small fake written for the test, as Apache
Commons Net's own tests do for telnet. For a plain socket protocol none of the six fits well, so the external systems
list leaves its stand-in not chosen, and repair waits. Developers' machines often can't run containers either.

## Considered Options

* **Add an in-process server as an approach: second, after a container; first where developers' machines can't run containers**  
  Works on every machine, needs no network, and is faithful where a well-used one exists for the protocol
* **Keep the six approaches, and choose a fake behind an interface for such systems**  
  A fake replaces the client in the code, so the client's own protocol handling is never tested
* **Keep the six, and record responses at the socket level**  
  Precise, but the recordings are written by hand, and only libraries that take a socket factory allow it

## Decision Outcome

Proposed: the first option.

* **An in-process server** (`in-process-server` in the external systems list) is a server the test starts on a
  port of this machine and stops after it, from a library that implements the protocol or a fake written for the test.
  The test connects to it the way it would to the real system, through the same client.
* **Its place in the order:** second, after a container. Where the organisation profile's
  `developer_machines.container_runtime_available` is false, it comes first, so tests run on developers' machines.
* **It fits** where a faithful one exists for the protocol (LDAP, mail, FTP, telnet and other text protocols); a
  database's in-memory stand-in is not one of these, since its dialect differs from the real one's.
* The external systems list proposes it for a `socket` system, which none of the other approaches fits.

This narrows [Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md).

### Consequences

* `in-process-server` joins the stand-in approaches in the external systems list's schema and the repair work
  orders' schema.
* draft-the-external-systems-list proposes it for a `socket` system instead of leaving the stand-in not chosen.

## More Information

* Builds on: [Order of preference for test stand-in approaches](0036-order-of-preference-for-test-stand-in-approaches.md), [The external systems list says what tests use for each system, and which addresses tests must never reach](0031-the-external-systems-list-says-what-tests-use-for-each-system-and-which-addresses-tests-must-never-reach.md)
* Later decisions that build on this: none yet
* Background: none
