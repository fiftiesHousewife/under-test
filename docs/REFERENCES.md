# References and background

This document places the toolkit's choices in the wider literature and industry practice. A longer research report on
architecture modelling and behaviour specification for test design is in
[research/calm-and-allium-for-test-design.md](research/calm-and-allium-for-test-design.md). Each section discusses one body of work and how it shapes our decisions. Full references are at the end. Decision records and technique lessons link to the anchors below.

Words follow [GLOSSARY.md](../GLOSSARY.md). Where a source uses a different term, the glossary term comes first and the source's term follows in brackets.

---

## 1. Testing legacy code: record first, then change {#legacy-code}

Feathers defines legacy code simply as code without tests [Feathers 2004]. He argues that the first move is not to rewrite it, but to pin down what it does today with tests that record current behaviour (his "characterisation tests"). Only then is it safe to change. His catalogue of places where a dependency can be replaced (his "seams") underpins our *make code testable* workstream and our *refactoring for testability* technique. The order of our workstreams follows his argument: get the code running on its own, record what it does, make it testable, and only then test it against requirements.

Saved-output tests (snapshot or "approval" tests) put this idea into practice. A known-good output is saved once, and any later difference must be approved by a person [ApprovalTests]. They suit legacy systems whose outputs are files, reports or messages rather than return values. That is why they are the default for batch jobs and message consumers in our application-type testing guides.

Feathers also gives the moves for changing such code safely once it is pinned down: add new code beside the old
("sprout") or around it ("wrap") rather than editing it in place [Feathers 2004]. For larger changes, the Mikado method
plans a change as a tree of small, safe steps [Ellnestam & Brolund 2014]. Practice exercises built for this, such as the
Gilded Rose and trivia katas, let people learn on safe code first [Bache; Rainsberger]. Readable test data comes from test
data builders [Pryce 2007; Freeman & Pryce 2009].

When old and new versions must run side by side, the strangler fig pattern replaces a system piece by piece
[Fowler 2004], branch by abstraction lets old and new code live behind one interface during the change [Fowler 2014],
and a parallel run sends the same work to both and compares the results while still trusting the old one
[Newman 2019, ch. 3]. Dark launching does the same with real traffic, hidden from users [Fowler 2020].

Several once-standard tools for legacy Java and scripts are no longer maintained, and the toolkit replaces them:
PowerMock and JMockit (Mockito now replaces static and final methods), system-lambda (System Stubs), cram (prysk),
data-diff (reladiff), and the Java and JavaScript ports of GitHub's Scientist library (a small in-house wrapper).

## 2. Test doubles and standing in for real systems {#test-doubles}

Meszaros gives the standard vocabulary for stand-ins (dummy, stub, spy, mock, fake) and the trade-offs of each [Meszaros 2007]. Our *test stand-in approach* list (run in a container, recorded responses, contract, fake behind an interface, shared test environment, accept the risk) runs from most realistic to least, for the systems a repo depends on.

Two practices have since become mainstream: running real infrastructure in throwaway containers [Testcontainers], and recording real responses from an HTTP service to replay in tests [WireMock]. Contract testing, where consumer and provider check an agreed shape of request and response, addresses failures that sit between teams [Pact]. Our rule that an in-memory database of a *different product* never counts as evidence follows the common warning that a different SQL dialect and locking model give false confidence. Google's guidance on preferring realistic, hermetic test dependencies makes the same point [Winters et al. 2020, ch. 13–14].

For scripts, the same idea works one level up: a small stand-in program placed first on `PATH` takes the place of the
real tool a script calls. This is a seam in Feathers' sense, a place where behaviour can change without editing the code
[Feathers 2004]. The Bash Automated Testing System is the usual way to write such tests [Bats]. Organisations should mirror it, and its helper
libraries, as a pinned copy of the source or its official container image rather than from npm: the npm copies lag
behind or come from forks, and one helper's npm name is a placeholder left after a malicious package was removed.

## 3. Test mix: the pyramid and its alternatives {#test-mix}

The testing pyramid recommends many fast unit tests, fewer integration tests and few end-to-end tests [Cohn 2009; Fowler 2012; Vocke 2018]. It is advice about the *shape* of a suite, not about how mature a codebase's testing is. Google describes the same idea through test sizes (small, medium, large) defined by the resources a test uses, not by its purpose [Winters et al. 2020, ch. 11]. For web front ends, the "testing trophy" argues for more component and integration tests and fewer unit tests [Dodds 2021].

Our position (decision records on test mix) is that the right shape depends on the application type. Legacy code also starts top-heavy for a good reason: broad tests at the edges are the only safe first step [Feathers 2004]. The mix should then move toward the target as code becomes testable.

## 4. Maturity models {#maturity-models}

Rating testing on numbered levels has a long history in process improvement. TMMi (Test Maturity Model integration) is the best-known testing-specific model [TMMi Foundation]. TMMi rates an *organisation's* testing process. Our test maturity levels instead rate a *codebase* by the evidence its tests provide, from "builds reliably" to "checked in production". We borrow the idea of ordered levels and explicit targets, not TMMi's process areas.

## 5. Mutation testing {#mutation-testing}

Mutation testing was proposed to measure how well tests detect faults. It makes small changes to the code and checks that tests notice [DeMillo et al. 1978]. Jia and Harman survey three decades of work [Jia & Harman 2011]. Just et al. show that catching these artificial changes correlates with catching real faults, which supports using mutation results as evidence that tests catch bugs [Just et al. 2014].

Cost has been the long-standing objection. Google's practice answers it by mutating only the code changed in each code review and reporting surviving mutants to the author, rather than computing a whole-codebase score [Petrović et al. 2022]. Our level-4 evidence rule and our "report only at first" decision for pull requests follow that model. PIT is the standard mutation tool for the JVM [Coles et al. 2016; PIT], and StrykerJS covers JavaScript and TypeScript [Stryker].

## 6. Generating tests automatically {#test-generation}

Before large language models, automatic test generation used random and search-based methods. Randoop generates call sequences guided by feedback from execution [Pacheco et al. 2007]. EvoSuite evolves whole test suites towards coverage goals [Fraser & Arcuri 2011], though it has had no release since 2021 [EvoSuite]. Both work best on plain library code and struggle with framework-heavy code, which is why our technique rules limit them to libraries and pure logic.

## 6a. Property-based testing {#property-based-testing}

Property-based testing replaces single examples with stated rules (properties) that a tool checks against many generated inputs, shrinking any failure to the smallest case [Claessen & Hughes 2000]. It suits pure calculations, parsers and serialisation, where a domain expert can state an invariant such as "debits always equal credits". On the JVM, jetCheck (from JetBrains) brings the approach to any test framework [jetCheck]. For TypeScript, fast-check does the same [fast-check]. The toolkit avoids jqwik: its licence adds an anti-AI usage clause from version 1.10, and its maintainers have put it in maintenance-only mode.

## 6b. Feature flags {#feature-flags}

Feature flags (also "feature toggles") switch behaviour on and off without a release. Hodgson separates release flags, experiment flags, operations flags and permission flags, and warns that every flag is a cost until it is removed [Hodgson 2017]. Branch by abstraction uses the same idea to replace a component gradually, with old and new implementations side by side behind an interface [Fowler 2014]. An empirical study of flag use in Chrome found that flags enable rapid release, but leave a burden of dead and conflicting flags if they are not removed [Rahman et al. 2016]. OpenFeature is a vendor-neutral open standard for flag evaluation, under the Cloud Native Computing Foundation, that lets code use one API whatever flag product sits behind it [OpenFeature]. Our decisions require that every flag state in use is tested and that flags have an owner and a removal date.

## 7. AI-written tests with automated checks {#ai-written-tests}

Meta's work on improving unit tests with a language model is the closest published precedent for our approach. Candidate tests are kept only if they build, pass reliably, and add coverage [Alshahwan et al. 2024]. Later work steers generation towards killing specific surviving mutants [Foster et al. 2025]. Our acceptance check for AI-written tests adopts the same filter: compiles, passes repeatedly with the network blocked, adds coverage or catches a mutant, and is labelled. On top of that, a person reviews every change before merging, because the toolkit is used by people with AI coding assistance, not by unattended agents.

## 8. Flaky tests {#flaky-tests}

Luo et al.'s study of flaky tests in open-source projects found that asynchronous waits, concurrency and test-order dependency are the leading causes [Luo et al. 2014]. Their finding that many flaky tests share causes supports our rule to fix groups of tests that fail together before single tests. Industry practice of quarantining flaky tests carries a known risk: quarantined tests are quietly lost. Hence our rule that quarantine needs an expiry date.

## 9. Decision records {#decision-records}

Nygard proposed short architecture decision records, each capturing one decision, its context and its consequences, kept with the code [Nygard 2011]. MADR (Markdown Architectural Decision Records) gives a widely used template with explicit options and outcomes [MADR]. We keep each record small and state the question in the title. Each record lists the earlier decisions it builds on, so the set reads from foundations upward.

## 10. Classifying many repositories with existing tools {#repo-classification}

Large code-migration programmes classify their portfolio before changing it. Konveyor (formerly Windup) provides open rulesets for recognising J2EE, application-server and framework usage [Konveyor]. OpenRewrite's search recipes report the libraries, framework versions and language levels in use, from the build model [OpenRewrite]. We combine these instead of building a scanner, in line with our decision to reuse existing tools.

## 11. Forward deployed engagements and large rollouts {#engagement-model}

Forward deployed engineering puts engineers inside a client's teams. They solve the client's problem end to end and turn what they learn into reusable tools and guides [Orosz 2025; OpenAI FDE; Palantir FDE]. There is no formal standard for how such engagements are run. Each company has its own version [Orosz 2025; ICONIQ 2025]. Delivery-lead roles in these companies own scope, sequencing, acceptance criteria and reporting to the client's sponsor [OpenAI Deployment Lead]. An engagement is judged finished when the client can carry on without the forward deployed team [Forrester 2025].

For running one change across a very large estate, AWS's large-migration guidance is the most detailed public framework. It defines phases (assess, mobilise, migrate in waves), a pilot before scaling, application owners committing to each wave, a steering group and decision log, and sign-off at handover [AWS 2023a; AWS 2023b]. Our roles and phases combine the two. Forward deployed engineering supplies the delivery roles and the habit of turning field work into reusable tools. The AWS guidance supplies the client-side governance and the batch-by-batch rollout.

## 12. Keeping production safe {#production-safety}

Running unfamiliar code that may hold production credentials calls for separation enforced by the network, not by configuration. This is a core idea of zero-trust architecture, which assumes nothing about the trustworthiness of a workload's own settings [NIST SP 800-207]. Secret scanning before code is built or run is now standard practice and available in mainstream platforms [GitHub secret scanning; gitleaks].

---

## Bibliography

- **[Alshahwan et al. 2024]** N. Alshahwan, J. Chheda, A. Finegenova, B. Gokkaya, M. Harman, I. Harper, A. Marginean, S. Sengupta, E. Wang. *Automated Unit Test Improvement using Large Language Models at Meta.* FSE Companion 2024. https://arxiv.org/abs/2402.09171
- **[ApprovalTests]** ApprovalTests. https://approvaltests.com/
- **[AWS 2023a]** Amazon Web Services. *Guide for AWS large migrations: phases.* AWS Prescriptive Guidance. https://docs.aws.amazon.com/prescriptive-guidance/latest/large-migration-guide/phases.html
- **[AWS 2023b]** Amazon Web Services. *Governance for large migrations: roles and responsibilities.* AWS Prescriptive Guidance. https://docs.aws.amazon.com/prescriptive-guidance/latest/large-migration-intro-governance/understanding-roles-responsibilities.html
- **[Bache]** E. Bache. *Gilded Rose refactoring kata.* https://github.com/emilybache/GildedRose-Refactoring-Kata
- **[Bats]** Bash Automated Testing System (bats-core), MIT licence. https://github.com/bats-core/bats-core; documentation: https://bats-core.readthedocs.io/
- **[Claessen & Hughes 2000]** K. Claessen, J. Hughes. *QuickCheck: a lightweight tool for random testing of Haskell programs.* ICFP 2000.
- **[Cohn 2009]** M. Cohn. *Succeeding with Agile: Software Development Using Scrum.* Addison-Wesley, 2009.
- **[Coles et al. 2016]** H. Coles, T. Laurent, C. Henard, M. Papadakis, A. Ventresque. *PIT: a practical mutation testing tool for Java.* ISSTA 2016 (tool demo).
- **[DeMillo et al. 1978]** R. A. DeMillo, R. J. Lipton, F. G. Sayward. *Hints on test data selection: help for the practicing programmer.* IEEE Computer 11(4), 1978.
- **[Dodds 2021]** K. C. Dodds. *The Testing Trophy and Testing Classifications.* https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications
- **[Ellnestam & Brolund 2014]** O. Ellnestam, D. Brolund. *The Mikado Method.* Manning, 2014.
- **[EvoSuite]** EvoSuite. https://github.com/EvoSuite/evosuite
- **[fast-check]** https://fast-check.dev/
- **[Feathers 2004]** M. Feathers. *Working Effectively with Legacy Code.* Prentice Hall, 2004.
- **[Forrester 2025]** Forrester. *Forward Deployed Engineers Are The Training Wheels For AI Reinvention.* https://www.forrester.com/blogs/forward-deployed-engineers-are-the-training-wheels-for-ai-reinvention/
- **[Foster et al. 2025]** C. Foster et al. *Mutation-Guided LLM-based Test Generation at Meta.* FSE Companion 2025 (industry track). https://arxiv.org/abs/2501.12862
- **[Fowler 2004]** M. Fowler. *Strangler Fig Application.* https://martinfowler.com/bliki/StranglerFigApplication.html
- **[Fowler 2012]** M. Fowler. *TestPyramid.* https://martinfowler.com/bliki/TestPyramid.html
- **[Fowler 2014]** M. Fowler. *Branch By Abstraction.* https://martinfowler.com/bliki/BranchByAbstraction.html
- **[Fowler 2014]** M. Fowler. *BranchByAbstraction.* https://martinfowler.com/bliki/BranchByAbstraction.html
- **[Fowler 2020]** M. Fowler. *Dark Launching.* https://martinfowler.com/bliki/DarkLaunching.html
- **[Fraser & Arcuri 2011]** G. Fraser, A. Arcuri. *EvoSuite: automatic test suite generation for object-oriented software.* ESEC/FSE 2011.
- **[Freeman & Pryce 2009]** S. Freeman, N. Pryce. *Growing Object-Oriented Software, Guided by Tests.* Addison-Wesley, 2009.
- **[GitHub secret scanning]** GitHub Docs. *About secret scanning.* https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning
- **[gitleaks]** https://github.com/gitleaks/gitleaks
- **[Hodgson 2017]** P. Hodgson. *Feature Toggles (aka Feature Flags).* https://martinfowler.com/articles/feature-toggles.html
- **[ICONIQ 2025]** ICONIQ Growth. *The FDE Advantage.* https://www.iconiq.com/growth/reports/the-fde-advantage-turning-deployment-into-compounding-value
- **[jetCheck]** JetBrains jetCheck. https://github.com/JetBrains/jetCheck
- **[Jia & Harman 2011]** Y. Jia, M. Harman. *An analysis and survey of the development of mutation testing.* IEEE Transactions on Software Engineering 37(5), 2011.
- **[Just et al. 2014]** R. Just, D. Jalali, L. Inozemtseva, M. D. Ernst, R. Holmes, G. Fraser. *Are mutants a valid substitute for real faults in software testing?* FSE 2014.
- **[Konveyor]** Konveyor rulesets. https://github.com/konveyor/rulesets
- **[Luo et al. 2014]** Q. Luo, F. Hariri, L. Eloussi, D. Marinov. *An empirical analysis of flaky tests.* FSE 2014.
- **[MADR]** Markdown Architectural Decision Records, template version 4.0.0. https://adr.github.io/madr/
- **[Meszaros 2007]** G. Meszaros. *xUnit Test Patterns: Refactoring Test Code.* Addison-Wesley, 2007.
- **[Newman 2019]** S. Newman. *Monolith to Microservices.* O'Reilly, 2019.
- **[NIST SP 800-207]** S. Rose, O. Borchert, S. Mitchell, S. Connelly. *Zero Trust Architecture.* NIST Special Publication 800-207, 2020. https://doi.org/10.6028/NIST.SP.800-207
- **[Nygard 2011]** M. Nygard. *Documenting Architecture Decisions.* https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- **[OpenAI Deployment Lead]** OpenAI. *Deployment Lead, FDE* (job posting; may be withdrawn). https://openai.com/careers/deployment-lead-fde-sf-san-francisco/
- **[OpenAI FDE]** OpenAI. *Forward Deployed Engineer* (job posting; may be withdrawn). https://openai.com/careers/forward-deployed-engineer-(fde)-sf-san-francisco/
- **[OpenFeature]** OpenFeature. https://openfeature.dev/
- **[OpenRewrite]** OpenRewrite documentation. https://docs.openrewrite.org/
- **[Orosz 2025]** G. Orosz. *Forward Deployed Engineers.* The Pragmatic Engineer. https://newsletter.pragmaticengineer.com/p/forward-deployed-engineers
- **[Pacheco et al. 2007]** C. Pacheco, S. K. Lahiri, M. D. Ernst, T. Ball. *Feedback-directed random test generation.* ICSE 2007.
- **[Pact]** Pact documentation. https://docs.pact.io/
- **[Palantir FDE]** Palantir. *Forward Deployed Software Engineer* (job posting; may be withdrawn). https://jobs.lever.co/palantir/5168e8fd-fec1-4fea-b7a1-81bdaea65850
- **[Petrović et al. 2022]** G. Petrović, M. Ivanković, G. Fraser, R. Just. *Practical mutation testing at scale: a view from Google.* IEEE Transactions on Software Engineering 48(10), 3900–3912, 2022. https://doi.org/10.1109/TSE.2021.3107634
- **[PIT]** PIT mutation testing. https://pitest.org/
- **[Pryce 2007]** N. Pryce. *Test Data Builders: an alternative to the Object Mother pattern.* http://www.natpryce.com/articles/000714.html
- **[Rahman et al. 2016]** M. T. Rahman, L.-P. Querel, P. C. Rigby, B. Adams. *Feature toggles: practitioner practices and a case study.* MSR 2016.
- **[Rainsberger]** J. B. Rainsberger. *Trivia: a legacy code retreat kata.* https://github.com/jbrains/trivia
- **[Stryker]** Stryker Mutator. https://stryker-mutator.io/
- **[Testcontainers]** Testcontainers. https://testcontainers.com/
- **[TMMi Foundation]** TMMi Foundation. *Test Maturity Model integration.* https://www.tmmi.org/
- **[Vocke 2018]** H. Vocke. *The Practical Test Pyramid.* https://martinfowler.com/articles/practical-test-pyramid.html
- **[Winters et al. 2020]** T. Winters, T. Manshreck, H. Wright (eds.). *Software Engineering at Google.* O'Reilly, 2020. https://abseil.io/resources/swe-book
- **[WireMock]** WireMock. https://wiremock.org/

*Bibliographic details were written from the authors' knowledge and the sources linked. Check page numbers and author lists against the publisher's record before citing formally.*
