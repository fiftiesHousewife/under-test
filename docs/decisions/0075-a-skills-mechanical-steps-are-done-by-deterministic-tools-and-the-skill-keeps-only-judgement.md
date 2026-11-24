---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# A skill's mechanical steps are done by deterministic tools, and the skill keeps only judgement

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[The toolkit is AI first](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)
made each step of the journey a skill that runs existing tools, and folded a planned converter into a skill. Trying
the skills on real repos showed the cost of that where no tool existed. An AI assistant reading tests to find
anti-patterns was slow and printed whole files; PMD with the toolkit's rules did it in a second, the same way every
time ([why](0066-find-test-anti-patterns-runs-pmd-with-the-toolkits-rules-and-searches-only-what-pmd-cannot-read.md)).
Following the connection-list skill by hand on Openfire, nearly every step (getting the classpath, tracing an address,
telling local from external, grouping into systems) was something a program decides better.

## Considered Options

* **Whatever a program can decide the same way every time is a tool; the skill keeps the rest**
* **Skills do everything from instructions, with existing tools where there are some**: the AI-first starting point

## Decision Outcome

Chosen in discussion. A step is mechanical when a program can decide it from the files alone, the same way every
time: searching, listing, counting, mapping one record to another, following a reference, applying a fixed rule,
writing a file whose every field follows from others. Each such step is a tool:

1. an existing tool, as [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md) says, checked by searching for what does the whole job, not only for its parts;
2. else a rule file for an existing tool (PMD's rules, gitleaks' rules), kept in this repo's `tools/`;
3. else a program of its own, in its own repo, published so organisations can mirror it, with an example repo of
   known answers and a check on a real public repo
   ([why](0071-every-skill-and-tool-is-also-checked-against-real-public-repos-by-a-persons-review-of-a-sample.md)).

A skill keeps what needs judgement or a person: choosing what to cover, asking the person, the hard cases a tool
reports it couldn't settle, merging with what people decided before, and the report. It reads a tool's output
through queries, never by printing it whole.

### Consequences

* Each skill is reviewed for mechanical steps; each one found becomes a backlog item for a tool.
* A skill's eval measures what is left for the AI assistant; a tool's example repo measures the tool.
* The first program of its own is [connection-paths](0072-connections-and-the-test-paths-to-them-are-found-by-connection-paths-a-javaparser-tool-in-its-own-repo.md).

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md), [connection-paths does everything a program can decide, and the connection-list skill only what needs judgement](0074-connection-paths-does-everything-a-program-can-decide-and-the-connection-list-skill-only-what-needs-judgement.md)
* Later decisions that build on this: [The journey's mechanical steps are one command-line tool, with a sub-command per step, in its own repo](0077-the-journeys-mechanical-steps-are-one-command-line-tool-with-a-sub-command-per-step-in-its-own-repo.md), [Repairing the existing tests is a step of its own, after measurement, changing only test code](0078-repairing-the-existing-tests-is-a-step-of-its-own-after-measurement-changing-only-test-code.md), [Which of repair's changes OpenRewrite recipes make, and which the AI makes](0079-which-of-repairs-changes-openrewrite-recipes-make-and-which-the-ai-makes.md), [Getting the classpath is under-test-external-calls' job, and the toolkit carries no copy of its steps](0091-getting-the-classpath-is-under-test-external-calls-job-and-the-toolkit-carries-no-copy-of-its-steps.md), [under-test-external-calls grades each reach, and the external systems list skill reads the grade](0094-under-test-external-calls-grades-each-reach-and-the-external-systems-list-skill-reads-the-grade.md)
* Background: none
