---
status: proposed
decision-makers: Toolkit maintainers
group: How we work
---

# Dependencies are checked for known vulnerabilities against the OSV database

**Decided by:** Toolkit maintainers · **Status:** proposed (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The toolkit and everything it brings into a build (libraries, quality tools, Gradle plugins and their own dependencies) must have no known vulnerabilities. The earlier OWASP dependency-check needed a key for the US National Vulnerability Database (NVD) and failed without one. A one-off check against OSV (osv.dev) found no known vulnerabilities in 105 resolved artifacts, and correctly flagged a known-vulnerable control version.

## Considered Options

* **Check every resolved dependency against OSV (osv.dev), Google's open vulnerability database, as a task in tools/repo-checks: collect resolved artifacts from every configuration, query OSV in batches, and fail on known vulnerabilities at or above a chosen severity. Organisations without internet access point it at a mirror of OSV's published data files**  
  No account or key; covers Maven and npm; works offline from a mirror
* **OSV-Scanner (Google's command-line tool)**  
  Complete and maintained; a Go binary that many organisations must approve separately
* **OWASP dependency-check**  
  Thorough; needs an NVD key, downloads a large database, and failed in this repo's CI

## Decision Outcome

Agreed in discussion: the first option. Run it in CI on every build, after confirming dependencies are on their latest versions.

### Consequences

* A vulnerability check task in tools/repo-checks, part of ./gradlew check in CI.
* A severity threshold setting, and a setting for an internal OSV mirror.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md)
* Later decisions that build on this: none yet
* Background: none
