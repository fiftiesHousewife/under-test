---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# A stand-in for an HTTPS system makes a throwaway certificate in the test, trusted only by that test

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

A stand-in for an HTTPS system has to present a certificate the test's client trusts. A keystore committed to the repo
is key material the safety inventory exists to keep out ([The safety inventory is a gate before the first run, and no skill ever copies a secret](0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)). On repair's trial on jsonld-java the stand-in served
plain HTTP, so a test named for an HTTPS-to-HTTP redirect no longer checked the HTTPS part in normal builds. Starting
the JDK's `keytool` from the test is no way out either: the airgap agent refuses programs a test starts.

## Considered Options

* **A throwaway self-signed certificate, made in the test's JVM when it starts, trusted only by that test's client**  
  Nothing committed, nothing downloaded, and the stand-in half checks TLS as the real one does
* **Plain HTTP, with the test noted**  
  Simpler, but an HTTPS test stops checking HTTPS in normal builds
* **A committed test keystore, recorded in the safety inventory**  
  Simple, but it puts key material in the repo

## Decision Outcome

Chosen in discussion: a throwaway certificate made in the test.

* **The stand-in makes its key pair** with the JDK's `KeyPairGenerator` when the test starts, and a self-signed
  certificate for `localhost` from it with a few lines of code in the test sources (or a library already on the test
  classpath), kept only in memory.
* **Only that test's client trusts it,** through an `SSLContext` built for the test; the JVM's own trust store is
  never changed.
* **Where the test's client can't be given an `SSLContext`,** the pair is made over plain HTTP and the test's `repair`
  field notes that its stand-in half doesn't check TLS.

### Consequences

* The repair skill's stand-in table says so for HTTPS systems.

## More Information

* Builds on: [Every test that reaches an external system becomes a pair: one run injects a stand-in, the other is tagged external](0086-every-test-that-reaches-an-external-system-becomes-a-pair-one-run-injects-a-stand-in-the-other-is-tagged-external.md), [The safety inventory is a gate before the first run, and no skill ever copies a secret](0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)
* Later decisions that build on this: none yet
* Background: none
