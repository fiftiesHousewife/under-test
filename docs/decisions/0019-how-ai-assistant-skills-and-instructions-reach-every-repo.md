---
status: superseded
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# How AI assistant skills and instructions reach every repo

**Decided by:** Toolkit maintainers · **Status:** superseded

> Replaced by [The toolkit reaches each repo through APM, pinned to a release tag, and nothing in it is copied](0051-the-toolkit-reaches-each-repo-through-apm-pinned-to-a-release-tag-and-nothing-in-it-is-copied.md).

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Skills and instructions live in this toolkit but are needed in every repo. Many organisations can't install new tools such as APM (Agent Package Manager) from outside, but already allow libraries through their package repository.

## Considered Options

* **Skills bundle: the toolkit's skills, and external skills it depends on copied in at pinned commits with their licences, published as a versioned artifact through public repositories; organisations mirror it through their own package repository; the convention plugin's `installSkills` task unpacks it into the folders each AI assistant reads. APM stays an optional extra, with `apm.yml` generated from the same list**  
  Uses a channel organisations already approve; one list of skills
* **Git subtree or submodule from internal mirrors**  
  Only needs git; awkward for people; someone keeps mirrors current
* **Copies in each repo, updated by a bot**  
  No new tools; many copies
* **APM only**  
  Needs an outside installer many organisations won't allow
* **Organisation-level skills on the code-hosting platform**  
  One copy; depends on the platform; not widely available

## Decision Outcome

Agreed in discussion; waiting for approval by pull request. Agreed in discussion: the skills bundle, with APM as an optional extra.

### Consequences

* the AI assistant skill used in every repo.

## More Information

* Builds on: [People do the work with AI coding assistance, and review everything it produces](../../decision-guides/0005-people-do-the-work-with-ai-coding-assistance-and-review-everything-it-produces.md)
* Later decisions that build on this: none yet
* Background: none
