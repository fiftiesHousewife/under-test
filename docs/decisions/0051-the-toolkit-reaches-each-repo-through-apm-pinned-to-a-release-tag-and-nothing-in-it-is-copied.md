---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The toolkit reaches each repo through APM, pinned to a release tag, and nothing in it is copied

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

Organisations adopting the toolkit say it isn't clear how to take it: which of its decision guides, schemas and
technique rules to copy, and how to stay in step afterwards. Earlier proposals described a content bundle and a skills
bundle published to a package repository, and an installer of managed files; none of them is built. Meanwhile the
toolkit's skills read its schemas and technique rules from beside them, and the skill evals already load the whole
toolkit as one package
([Skill evals run on a clean copy of the whole toolkit, which is the plugin, so skills can read its files](0047-skill-evals-run-on-a-clean-copy-of-the-whole-toolkit-which-is-the-plugin-so-skills-can-read-its-files.md)).
This repo already installs outside skills with APM (the Agent Package Manager), pinned, for more than one AI assistant.

## Considered Options

* **APM, pinned to a release tag of the toolkit in the organisation's internal mirror**  
  Each repo's `apm.yml` names the toolkit and a tag; `apm install` puts the skills where that repo's AI assistant finds
  them, with the schemas and technique rules beside them. Works for any assistant APM supports, needs no build tool,
  and records the exact version in its lock file
* **A versioned package from the organisation's package repository, unpacked by an install step**  
  Fits a locked-down network well, but has to be built and published first
* **A git submodule at a release tag**  
  Nothing to build, but awkward for most teams, and the assistant still has to be pointed at the skills inside it

## Decision Outcome

Chosen in discussion: APM, pinned to a release tag. The toolkit is one APM package: its skills, decision guides,
schemas and technique rules arrive together and are read where they are installed, never copied or edited in the
repo. An organisation changes what they say only through its own decision records
([An organisation adopts every decision guide in its toolkit version by default, and records only its departures](0052-an-organisation-adopts-every-decision-guide-in-its-toolkit-version-by-default-and-records-only-its-departures.md)).
A newer toolkit version is a one-line change to the tag, by pull request.

### Consequences

* The toolkit's `apm.yml` declares it as a package that installs its skills, decision guides, schemas and technique
  rules; release tags are its versions.
* The organisation keeps an internal mirror of the toolkit's repository; each repo's `apm.yml` points at the mirror,
  so nothing reaches a public site.
* The organisation profile's `toolkit.version` names the same tag, so the organisation repo and its repos agree.
* The adoption guide's step for bringing the toolkit inside the network describes this instead of published bundles.

## More Information

* Builds on: [The toolkit is AI first: its steps are skills that run existing tools, and code lives in its own repos](0040-the-toolkit-is-ai-first-its-steps-are-skills-that-run-existing-tools-and-code-lives-in-its-own-repos.md)
* Replaces: [The organisation repo refers to the toolkit by version through the organisation's package repository](0004-the-organisation-repo-refers-to-the-toolkit-by-version-through-the-organisations-package-repository.md), [The toolkit is installed into organisation and target repos as managed files with a lock file](0005-the-toolkit-is-installed-into-organisation-and-target-repos-as-managed-files-with-a-lock-file.md), [How AI assistant skills and instructions reach every repo](0019-how-ai-assistant-skills-and-instructions-reach-every-repo.md)
* Later decisions that build on this: none yet
* Background: none
