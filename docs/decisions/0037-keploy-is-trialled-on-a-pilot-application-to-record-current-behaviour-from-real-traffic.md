---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Keploy is trialled on a pilot application to record current behaviour from real traffic

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Recording what an old application does today is the first deliverable on every repo. Keploy records an application's
incoming calls and the calls it makes in turn (HTTP, databases, queues), and turns them into tests with stand-ins for
each dependency, which would save much of that work. The toolkit rejected it because it needed eBPF on Linux as root.
Keploy now runs as an ordinary user on Windows (x86-64) and on macOS (Apple silicon), with no WSL or Docker
([installation](https://keploy.io/docs/server/install/)). On those platforms it fully understands HTTP and HTTPS,
MySQL and MongoDB; PostgreSQL, Redis and Kafka are captured only as raw bytes and usually don't replay
([Spring Boot quickstart](https://keploy.io/docs/quickstart/java-spring-boot-xml/)). Its core is Apache-2.0, but some
of its protocol-parsing components aren't open source ([repository](https://github.com/keploy/keploy)). Its own pages
disagree on Windows support for its mocking mode ([Universal Mocker](https://keploy.io/docs/universal-mocker/overview/)),
and no source says whether it contacts Keploy's servers. See also
[capturing and cleaning black-box data](../research/capturing-and-cleaning-black-box-data.md).

## Considered Options

* **Trial it on one pilot application, on a machine with no route out, and recommend it for the cases the trial
  proves; WireMock recording stays the default until then**
  Finds out cheaply whether it works within corporate limits; nothing depends on it before it's proved
* **Recommend it now**
  Fastest, but on facts its own documents don't agree on, with closed components unreviewed
* **Keep rejecting it**
  Safe, but ignores a tool that may now fit and would save the most effort

## Decision Outcome

Chosen: trial it. The trial passes if, on Windows without administrator rights and with no route out, Keploy records
a pilot service's HTTP calls and its MySQL or MongoDB calls, replays them as passing tests, makes no contact with
Keploy's servers, and its recordings pass the personal-data check once cleaned; and the Security and Platform Owner
approves the binary and its closed components.

### Consequences

* [The traffic-record-and-replay technique](../../techniques/traffic-record-and-replay/technique.yaml) is updated to
  these facts, and moves to the "record current behaviour" workstream.
* A backlog item for the trial, on the pilot application.
* A lesson on recording current behaviour with Keploy, planned in the lessons repo once the trial passes.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md)
* Later decisions that build on this: none yet
* Background: [capturing and cleaning black-box data](../research/capturing-and-cleaning-black-box-data.md)
