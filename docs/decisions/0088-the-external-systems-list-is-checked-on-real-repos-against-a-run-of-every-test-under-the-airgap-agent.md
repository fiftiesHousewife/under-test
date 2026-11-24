---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# The external systems list is checked on real repos against a run of every test under the airgap agent

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Every skill and tool is also checked against real public repos by a person's review of a sample](0071-every-skill-and-tool-is-also-checked-against-real-public-repos-by-a-persons-review-of-a-sample.md).
For the external systems list a person can judge a chain of calls from reading it, but can't tell which tests
actually reach another machine: on Openfire 4.6.0's server module that took tracing 230 chains by hand, and still
left open whether any were missed. The airgap agent records, test by test, every call a test tries to make to another
machine, and refuses it.

## Considered Options

* **Run every test of the repo under the airgap agent, refusing every outside call, and compare test by test**  
  Gives recall (tests that called out and have a chain) and precision (tests with a chain that called out) over the
  whole suite, with no person's judgement
* **A person reviews a sample of chains**  
  Precision on the sample only; misses can only be estimated
* **Both**  
  The run settles which tests call out; a person is still needed for why a chain is wrong

## Decision Outcome

Chosen in discussion: run every test under the airgap agent and compare test by test. Tests marked disabled run too,
where the test framework can switch the mark off for one run without changing the repo (JUnit 5 and later), since
discovery lists them and they would run once enabled. A person reads only the tests the comparison names: each missed
test, each wrong grade, and the groups of false alarms, to say why, and each cause goes to connection-paths as a
fault. The check is repeated on the same repos whenever connection-paths changes.

How to run it is in [Checking discovery against a run under the airgap agent](../design/checking-discovery-against-a-run-under-the-airgap-agent.md).

### Consequences

* The field-trial repos are chosen so that some of their tests do reach other machines, or recall can't be judged:
  Openfire's and spring-petclinic's tests reach none, jsoup's `UrlConnectTest` reaches twenty hosts.
* The comparison needs the agent's JUnit listener on the test classpath, so each call names its test.
* For the other skills, the person's review of a sample stays as decided.

## More Information

* Builds on: [Every skill and tool is also checked against real public repos by a person's review of a sample](0071-every-skill-and-tool-is-also-checked-against-real-public-repos-by-a-persons-review-of-a-sample.md), [Each test is graded reaches, may reach or cannot reach, from the address its own settings give](0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md)
* Later decisions that build on this: [The field trial's public repos run their tests under the airgap agent without a safety inventory first](0089-the-field-trials-public-repos-run-their-tests-under-the-airgap-agent-without-a-safety-inventory-first.md), [Discovery is checked on real repos against an airgap run, and the other skills by a review of a sample](0097-discovery-is-checked-on-real-repos-against-an-airgap-run-and-the-other-skills-by-a-review-of-a-sample.md)
* Background: none
