---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos

> Narrowed by [Finding what the code connects to is one job, in the connection-list skill, done before any code runs](0068-finding-what-the-code-connects-to-is-one-job-in-the-connection-list-skill-done-before-any-code-runs.md), [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md), [The journey's mechanical steps are one command-line tool, with a sub-command per step, in its own repo](0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md).

## Context and Problem Statement

The toolkit is used by people with AI coding assistance. Its backlog had grown a long list of tools to build: a
converter for the safety inventory, a measurement run, a report generator, a repo classifier, a plan generator, a
convention plugin, installers and loaders. Most of these only run existing tools (gitleaks, JaCoCo, PIT, the airgap
agent) and write files to one of the toolkit's schemas, which an AI assistant can do when it follows clear
instructions. Every tool built here is code to maintain, release and get approved inside each organisation.

## Considered Options

* **Skills here, code in its own repos later; schemas, rules and templates stay here**  
  Each step of a repo's journey is a skill: the AI assistant runs existing tools and writes the result to the
  toolkit's schemas, and a person reviews it. Code that has to be code (a Gradle plugin, an installer, a loader
  that needs only Java, a cleaner for captured data) gets its own repo when a pilot needs it, the way the airgap agent
  did, and is documented here until then
* **Skills here, and code only as documented designs, with no plan for repos yet**  
  Lighter still, but leaves the code with no home when a pilot needs it
* **Build the tools here, as planned**  
  One repo, but most of its code would repeat what an AI assistant can do with existing tools

## Decision Outcome

Accepted: the first option. It was chosen in discussion by the toolkit maintainers. This repo holds decisions,
schemas, technique rules, rule files (such as the safety inventory's gitleaks rules), templates (such as the repo
assessment report page) and skills, plus the tools that keep it in order. A skill is judged by how much effort it
saves: fewer tool calls, fewer corrections, the same result each time. Code already here, the repo checks and the
backlog importer, stays until something replaces it.

### Consequences

* Backlog items for steps of the journey become skills: running the safety inventory, drafting the connection list
  from the airgap reports, finding anti-patterns in tests, measuring a repo, scoring obstacles, choosing techniques,
  writing the testing plan, classifying a repo and rendering the assessment report.
* Backlog items for real code (the convention plugin and its parts, installers, content and skills bundles, tracker
  loaders, the commit-message check, the capture cleaner, Maven and npm set-ups) move to "later", each marked as
  belonging to its own repo.
* The small converter planned in [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md)
  becomes part of the safety inventory skill.
* Schemas carry the precision a tool would have had: a skill's output is checked against its schema.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [Risky calls on developer machines are refused and reported by the airgap agent, built in its own repo](0036-risky-calls-on-developer-machines-are-refused-and-reported-by-the-airgap-agent-built-in-its-own-repo.md)
* Later decisions that build on this: [A repo is measured by a Gradle init script that adds JaCoCo and PIT without changing its build](0044-a-repo-is-measured-by-a-gradle-init-script-that-adds-jacoco-and-pit-without-changing-its-build.md), [The toolkit's skills are evaluated with claude plugin eval, against known answers, five runs with and without them](0045-the-toolkits-skills-are-evaluated-with-claude-plugin-eval-against-known-answers-five-runs-with-and-without-them.md), [Each technique rule separates what calls for the technique from what makes it possible](0046-each-technique-rule-separates-what-calls-for-the-technique-from-what-makes-it-possible.md), [The toolkit reaches each repo through APM, pinned to a release tag, and nothing in it is copied](0051-the-toolkit-reaches-each-repo-through-apm-pinned-to-a-release-tag-and-nothing-in-it-is-copied.md), [A skill finds what to read by searching, and reads only what the searches find](0054-a-skill-finds-what-to-read-by-searching-and-reads-only-what-the-searches-find.md), [A skill keeps each kind of repo in its own file, and reads only the ones that apply](0056-a-skill-keeps-each-kind-of-repo-in-its-own-file-and-reads-only-the-ones-that-apply.md), [A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement](0075-a-skills-mechanical-steps-are-done-by-deterministic-tools-and-the-skill-keeps-only-judgement.md), [All our Java follows one set of code-quality standards: a plugin published to Maven Central that every repo applies](0082-all-our-java-follows-one-set-of-code-quality-standards-a-plugin-published-to-maven-central-that-every-repo-applies.md), [Getting the classpath is under-test-external-calls' job, and the toolkit carries no copy of its steps](0091-getting-the-classpath-is-under-test-external-calls-job-and-the-toolkit-carries-no-copy-of-its-steps.md)
* Background: none
