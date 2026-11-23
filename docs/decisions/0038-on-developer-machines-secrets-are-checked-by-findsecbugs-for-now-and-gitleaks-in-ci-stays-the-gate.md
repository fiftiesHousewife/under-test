---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# On developer machines, secrets are checked by FindSecBugs for now, and gitleaks in CI stays the gate

## Context and Problem Statement

[No repo's code is built or run until its secrets scan is clean](../../decision-guides/0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md)
names gitleaks, a native Go program. Developer machines are Windows laptops with no administrator rights, where
only approved tools can be installed, and the toolkit's core use needs nothing beyond Java and Git (see
[Using the toolkit inside a corporate network](../CORPORATE-USE.md)). Engineers still want a check on their own
machine, not only in CI.

A search for prior art found:

* **Gradle plugins that wrap a native scanner:** `io.dotinc.gitleaks` runs the gitleaks binary or a Docker image, and
  has had no release in years; gradle-trivy downloads Trivy at run time. Both need a native program on each laptop.
* **No maintained secret scanner written in Java.** The standalone scanners found are small Python projects;
  TruffleHog is a Go program under the AGPL, a strong copyleft licence.
* **FindSecBugs**, the SpotBugs plugin already in the toolkit's quality checks, reports hard-coded passwords and keys
  in compiled code. It needs the code compiled, and sees only the current code, not its history or settings files.

## Considered Options

* **FindSecBugs on laptops, through the SpotBugs check the convention plugin already runs; gitleaks in CI stays the
  scan that decides whether a repo may be built**  
  No new code and nothing new to approve. On a laptop it catches credentials written into code as the work goes on.
  It doesn't cover history or settings files, so it can't be the gate; CI's gitleaks scan, on every push, covers those
* **A small Java check that runs gitleaks' own rules (its MIT-licensed `gitleaks.toml`), with RE2/J for Go-compatible
  patterns and JGit for history**  
  The same rules on laptops and in CI, history included, with nothing native; but it is custom code the toolkit has
  to keep in step with gitleaks
* **The gitleaks binary on every laptop**  
  The real scanner everywhere; but each organisation must approve and distribute a native program to every machine
* **A Gradle plugin that wraps gitleaks or Trivy**  
  Still downloads or needs a native program, from plugins that are not kept current

## Decision Outcome

Accepted: the first option. It was chosen in discussion by the toolkit maintainers, who want no more custom code than
is needed. The gate is unchanged: gitleaks runs in CI, over the whole history, before any of a repo's code is built or
run anywhere, laptops included, and on every push after that. On laptops, FindSecBugs is an early warning, not a gate.
The Java check that runs gitleaks' rules is the option to revisit if engineers need a full scan before pushing, or if
a secret reaches CI that a laptop check should have caught.

### Consequences

* The decision guide on secrets scans says gitleaks runs in CI, and FindSecBugs on developer machines.
* The convention plugin keeps FindSecBugs' hard-coded credential detectors switched on, and fails the build on them.
* An engineer clones and builds a repo on a laptop only after its CI scan is clean.
* No toolkit code for secret scanning.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [No repo's code is built or run until its secrets scan is clean](../../decision-guides/0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md)
* Later decisions that build on this: none yet
* Background: [production-safety](../REFERENCES.md#production-safety); [gitleaks](https://github.com/gitleaks/gitleaks); [gitleaks Gradle plugin](https://plugins.gradle.org/plugin/io.dotinc.gitleaks); [gradle-trivy](https://github.com/mgerhardy/gradle-trivy); [Find Security Bugs](https://find-sec-bugs.github.io/)
