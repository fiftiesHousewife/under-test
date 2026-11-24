---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# We reuse existing tools before building new ones

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion) (agreed in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Many needs (classification, secrets scanning, coverage, mutation testing, dependency maps) already have mature tools. Building our own costs time and needs maintaining.

## Considered Options

* **Look for existing tools first; build only what is missing, on top of them**  
  Faster and cheaper; we depend on outside projects and their licences
* **Build our own**  
  Full control; slow and costly

## Decision Outcome

Chosen in discussion: the first option. Every tool item records which existing tools were considered, and why one was chosen, in a decision record.

### Consequences

* Every piece of tool work starts with a search for existing tools.

## More Information

* Builds on: nothing (a foundation decision)
* Later decisions that build on this: [Feature flags use the OpenFeature standard with the organisation's own flag product](../../decision-guides/0004-feature-flags-use-the-openfeature-standard-with-the-organisations-own-flag-product.md), [The organisation repo refers to the toolkit by version through the organisation's package repository](0004-the-organisation-repo-refers-to-the-toolkit-by-version-through-the-organisations-package-repository.md), [The toolkit is installed into organisation and target repos as managed files, with a lock file](0005-the-toolkit-is-installed-into-organisation-and-target-repos-as-managed-files-with-a-lock-file.md), [The toolkit provides reference build set-ups for Gradle, Maven and npm](0015-the-toolkit-provides-reference-build-set-ups-for-gradle-maven-and-npm.md), [Lessons are runnable, checked by the build, and illustrated with terminal videos generated from scripts](0016-lessons-are-runnable-checked-by-the-build-and-illustrated-with-terminal-videos-generated-from-scripts.md), [Every tool the toolkit names is checked for maintenance and licence before adoption and at each release](0022-every-tool-the-toolkit-names-is-checked-for-maintenance-and-licence-before-adoption-and-at-each-release.md), [Each repo's work is loaded into the issue tracker by one tool, with an adapter per tracker](0023-each-repos-work-is-loaded-into-the-issue-tracker-by-one-tool-with-an-adapter-per-tracker.md), [The estate survey sits outside the toolkit, which provides a repo classifier a survey tool can call](0024-the-estate-survey-sits-outside-the-toolkit-which-provides-a-repo-classifier-a-survey-tool-can-call.md), [Repos are classified by rules only, so results can be explained and repeated](0025-repos-are-classified-by-rules-only-so-results-can-be-explained-and-repeated.md), [Which existing tools the repo classifier combines](0026-which-existing-tools-the-repo-classifier-combines.md), [Dependencies are checked for known vulnerabilities against the OSV database](0029-dependencies-are-checked-for-known-vulnerabilities-against-the-osv-database.md), [Each application's external systems are recorded as a CALM list](../../decision-guides/0030-each-applications-external-systems-are-recorded-as-a-calm-list.md), [Knowledge sources are listed by the knowledge curator and read through Allium skills with a citation addendum](../../decision-guides/0034-knowledge-sources-are-listed-by-the-knowledge-curator-and-read-through-allium-skills-with-a-citation-addendum.md), [Risky calls on developer machines are refused and reported by the airgap agent, built in its own repo](0036-risky-calls-on-developer-machines-are-refused-and-reported-by-the-airgap-agent-built-in-its-own-repo.md), [Contract tests share pacts as versioned artifacts through the package repository, without a broker](../../decision-guides/0037-contract-tests-share-pacts-as-versioned-artifacts-through-the-package-repository-without-a-broker.md), [Keploy is trialled on a pilot application to record current behaviour from real traffic](0037-keploy-is-trialled-on-a-pilot-application-to-record-current-behaviour-from-real-traffic.md), [On developer machines, secrets are checked by FindSecBugs for now, and gitleaks in CI stays the gate](0038-on-developer-machines-secrets-are-checked-by-findsecbugs-for-now-and-gitleaks-in-ci-stays-the-gate.md), [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md), [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [find-test-anti-patterns runs PMD with the toolkit's rules, and searches only what PMD cannot read](0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md), [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md)
* Background: [repo-classification](../REFERENCES.md#repo-classification)
