# Decision records

One small decision per record, in [MADR](https://adr.github.io/madr/) form. Later records build on earlier ones.
Each open question is a decision item in the organisation's issue tracker, assigned to the deciding role. The pull request that adds or changes the record resolves it, and that role's approval is the acceptance.
These are generic decision guides. An organisation records its own choices in its private overlay repo (see [Organisation-specific facts and decisions live in a private overlay repo](0004-organisation-specific-facts-and-decisions-live-in-a-private-overlay-repo.md)).
Numbers follow reading order until a record is accepted; after that a number never changes. Words follow [GLOSSARY.md](../../GLOSSARY.md). This index is generated.

## How we work

| Decision | Status | Who decides |
|---|---|---|
| [The programme runs as a forward deployed engagement with named roles](0001-the-programme-runs-as-a-forward-deployed-engagement-with-named-roles.md) | proposed | Programme Sponsor |
| [The programme moves through five phases, each ending with a sign-off](0002-the-programme-moves-through-five-phases-each-ending-with-a-sign-off.md) | proposed | Programme Sponsor |
| [How this repository is organised](0003-how-this-repository-is-organised.md) | proposed | Technical Architect |
| [Organisation-specific facts and decisions live in a private overlay repo](0004-organisation-specific-facts-and-decisions-live-in-a-private-overlay-repo.md) | proposed (agreed in discussion) | Technical Architect |
| [The programme backlog lives in the organisation's issue tracker, not in a file](0005-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md) | proposed | Engagement Lead |
| [Decision records follow MADR and are approved by pull request review](0006-decision-records-follow-madr-and-are-approved-by-pull-request-review.md) | proposed | Engagement Lead |
| [We write in plain English using the agreed word list](0013-we-write-in-plain-english-using-the-agreed-word-list.md) | proposed (agreed in discussion) | Engagement Lead |
| [We reuse existing tools before building new ones](0014-we-reuse-existing-tools-before-building-new-ones.md) | proposed (agreed in discussion) | Technical Architect |
| [Feature flags use the OpenFeature standard with the organisation's own flag product](0015-feature-flags-use-the-openfeature-standard-with-the-organisations-own-flag-product.md) | proposed | Technical Architect |
| [People do the work with AI coding assistance, and review everything it produces](0016-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md) | proposed (agreed in discussion) | Programme Sponsor |
| [Independent AI agents working unattended are a future direction only](0017-independent-ai-agents-working-unattended-are-a-future-direction-only.md) | proposed (agreed in discussion) | Programme Sponsor |

## Using the toolkit in an organisation

| Decision | Status | Who decides |
|---|---|---|
| [Build settings come in three layers: environment, code-quality standards and testing evidence](0007-build-settings-come-in-three-layers-environment-code-quality-standards-and-testing-evidence.md) | proposed (agreed in discussion) | Technical Architect |
| [The build environment (proxy and package repository) comes from the organisation's own build set-up](0008-the-build-environment-proxy-and-package-repository-comes-from-the-organisations-own-build-set-up.md) | proposed | Technical Architect, approved by the Security and Platform Owner |
| [Code-quality standards can be the toolkit's, the organisation's, or the organisation's own plugin](0009-code-quality-standards-can-be-the-toolkits-the-organisations-or-the-organisations-own-plugin.md) | proposed | Technical Architect |
| [Testing evidence is defined by standard report files, not by one build plugin](0010-testing-evidence-is-defined-by-standard-report-files-not-by-one-build-plugin.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [The toolkit provides reference build set-ups for Gradle, Maven and npm](0011-the-toolkit-provides-reference-build-set-ups-for-gradle-maven-and-npm.md) | proposed | Technical Architect |
| [How AI assistant skills and instructions reach every repo](0012-how-ai-assistant-skills-and-instructions-reach-every-repo.md) | proposed (agreed in discussion) | Technical Architect |

## Keeping production safe

| Decision | Status | Who decides |
|---|---|---|
| [No repo's code is built or run until its secrets scan is clean](0018-no-repos-code-is-built-or-run-until-its-secrets-scan-is-clean.md) | proposed | Security and Platform Owner (can veto) |
| [Old code runs first only where production cannot be reached](0019-old-code-runs-first-only-where-production-cannot-be-reached.md) | proposed | Security and Platform Owner (can veto) |
| [Tests stop at once if any configured address is a production address](0020-tests-stop-at-once-if-any-configured-address-is-a-production-address.md) | proposed | Security and Platform Owner (can veto) |
| [A test profile with dummy secrets is the default, and production profiles only work in production](0021-a-test-profile-with-dummy-secrets-is-the-default-and-production-profiles-only-work-in-production.md) | proposed | Technical Architect |
| [A production secret found in a repo is handled as a security incident](0022-a-production-secret-found-in-a-repo-is-handled-as-a-security-incident.md) | proposed | Security and Platform Owner (can veto) |

## What "well tested" means

| Decision | Status | Who decides |
|---|---|---|
| [What each test maturity level means](0023-what-each-test-maturity-level-means.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [What counts as evidence for each test maturity level](0024-what-counts-as-evidence-for-each-test-maturity-level.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [Target test maturity level for each business criticality](0025-target-test-maturity-level-for-each-business-criticality.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [Shared libraries target level 4, whatever the criticality of the apps using them](0026-shared-libraries-target-level-4-whatever-the-criticality-of-the-apps-using-them.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [How an application's test maturity level is worked out from its repos](0027-how-an-applications-test-maturity-level-is-worked-out-from-its-repos.md) | proposed (open) | Test Quality Lead, approved by the Steering Group |
| [Target test mix for each application type and the top-heavy phase at level 2](0028-target-test-mix-for-each-application-type-and-the-top-heavy-phase-at-level-2.md) | proposed (agreed in discussion) | Test Quality Lead, approved by the Steering Group |

## Where tests run

| Decision | Status | Who decides |
|---|---|---|
| [Tests are split by what they need: local tests and container tests](0029-tests-are-split-by-what-they-need-local-tests-and-container-tests.md) | proposed (agreed in discussion) | Technical Architect |
| [How CI runs container tests for each kind of CI platform](0030-how-ci-runs-container-tests-for-each-kind-of-ci-platform.md) | proposed | Technical Architect, approved by the Security and Platform Owner |
| [Container tests on developer machines that have no container runtime](0031-container-tests-on-developer-machines-that-have-no-container-runtime.md) | proposed | Technical Architect, approved by the Security and Platform Owner |
| [How developers see container test results while their machines cannot run containers](0032-how-developers-see-container-test-results-while-their-machines-cannot-run-containers.md) | proposed (open) | Technical Architect |

## Recording results and owning plans

| Decision | Status | Who decides |
|---|---|---|
| [The assessment file: where it lives, who writes which fields, and its schema version](0033-the-assessment-file-where-it-lives-who-writes-which-fields-and-its-schema-version.md) | proposed | Engagement Lead |
| [Testing plans are generated from the assessment file, and the issue tracker follows the work](0034-testing-plans-are-generated-from-the-assessment-file-and-the-issue-tracker-follows-the-work.md) | proposed | Engagement Lead |
| [Where measured results are stored and how each repo sees its own](0035-where-measured-results-are-stored-and-how-each-repo-sees-its-own.md) | proposed | Engagement Lead |
| [Who approves repo and application testing plans](0036-who-approves-repo-and-application-testing-plans.md) | proposed | Steering Group |
| [Repo work is tracked in the organisation's issue tracker with standard labels](0037-repo-work-is-tracked-in-the-organisations-issue-tracker-with-standard-labels.md) | proposed | Engagement Lead |
| [Each repos work is loaded into the issue tracker by one tool with an adapter per tracker](0038-each-repos-work-is-loaded-into-the-issue-tracker-by-one-tool-with-an-adapter-per-tracker.md) | proposed | Engagement Lead |
| [When the organisation requires it every commit names its work item](0039-when-the-organisation-requires-it-every-commit-names-its-work-item.md) | proposed | Steering Group |

## Understanding our repos

| Decision | Status | Who decides |
|---|---|---|
| [The estate survey sits outside the toolkit which provides a repo classifier a survey tool can call](0040-the-estate-survey-sits-outside-the-toolkit-which-provides-a-repo-classifier-a-survey-tool-can-call.md) | proposed (agreed in discussion) | Technical Architect |
| [Repos are classified by rules only, so results can be explained and repeated](0041-repos-are-classified-by-rules-only-so-results-can-be-explained-and-repeated.md) | proposed | Technical Architect |
| [Which existing tools the repo classifier combines](0042-which-existing-tools-the-repo-classifier-combines.md) | proposed | Technical Architect |
| [The lists of technology stacks and application types](0043-the-lists-of-technology-stacks-and-application-types.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [The named list of obstacles to testing and how each is scored](0044-the-named-list-of-obstacles-to-testing-and-how-each-is-scored.md) | proposed (open) | Test Quality Lead, approved by the Steering Group |

## Standing in for real systems

| Decision | Status | Who decides |
|---|---|---|
| [Order of preference for test stand-in approaches](0045-order-of-preference-for-test-stand-in-approaches.md) | proposed | Technical Architect |
| [An in-memory database of a different product never counts as evidence](0046-an-in-memory-database-of-a-different-product-never-counts-as-evidence.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [Recorded responses and fakes live in shared test kits, not in each repo](0047-recorded-responses-and-fakes-live-in-shared-test-kits-not-in-each-repo.md) | proposed | Technical Architect |
| [Who owns and maintains each shared test kit](0048-who-owns-and-maintains-each-shared-test-kit.md) | proposed | Steering Group |
| [Tests that reach real shared systems are tagged and left out of normal runs](0049-tests-that-reach-real-shared-systems-are-tagged-and-left-out-of-normal-runs.md) | proposed | Security and Platform Owner (can veto) |
| [Whether a shared test environment can count as evidence for a limited time](0050-whether-a-shared-test-environment-can-count-as-evidence-for-a-limited-time.md) | proposed (open) | Test Quality Lead, approved by the Steering Group |

## Test hygiene

| Decision | Status | Who decides |
|---|---|---|
| [How flaky tests are found](0051-how-flaky-tests-are-found.md) | proposed | Technical Architect |
| [Flaky tests can be quarantined only with an expiry date](0052-flaky-tests-can-be-quarantined-only-with-an-expiry-date.md) | proposed | Technical Architect |
| [Every feature flag state in use is tested and old flags are removed](0053-every-feature-flag-state-in-use-is-tested-and-old-flags-are-removed.md) | proposed | Test Quality Lead, approved by the Steering Group |
| [Personal data is removed from any recorded traffic or data](0054-personal-data-is-removed-from-any-recorded-traffic-or-data.md) | proposed | Security and Platform Owner (can veto) |

## AI-written tests

| Decision | Status | Who decides |
|---|---|---|
| [The checks an AI-written test must pass before it is kept](0055-the-checks-an-ai-written-test-must-pass-before-it-is-kept.md) | proposed | Test Quality Lead |
| [AI-written tests that expect different behaviour go to triage, not the bin](0056-ai-written-tests-that-expect-different-behaviour-go-to-triage-not-the-bin.md) | proposed | Test Quality Lead |
| [How strict the checks on AI-written tests are at the start](0057-how-strict-the-checks-on-ai-written-tests-are-at-the-start.md) | proposed (open) | Test Quality Lead |

## Rolling out

| Decision | Status | Who decides |
|---|---|---|
| [The order of workstreams for a repo](0058-the-order-of-workstreams-for-a-repo.md) | proposed | Engagement Lead |
| [Feature flags are used to change legacy code safely and to release gradually](0059-feature-flags-are-used-to-change-legacy-code-safely-and-to-release-gradually.md) | proposed | Technical Architect |
| [Repos no longer deployed or changed get a retirement review, not a testing plan](0060-repos-no-longer-deployed-or-changed-get-a-retirement-review-not-a-testing-plan.md) | proposed | Engagement Lead, with the Programme Sponsor |
| [One pilot application per common technology stack and application type pair](0061-one-pilot-application-per-common-technology-stack-and-application-type-pair.md) | proposed | Engagement Lead, with the Programme Sponsor |
| [How each batch of repos is chosen](0062-how-each-batch-of-repos-is-chosen.md) | proposed | Engagement Lead, with the Programme Sponsor |
| [Mutation testing in pull requests reports only at first](0063-mutation-testing-in-pull-requests-reports-only-at-first.md) | proposed | Technical Architect |
| [How often repos are re-scanned and re-measured](0064-how-often-repos-are-re-scanned-and-re-measured.md) | proposed | Engagement Lead |
