---
status: proposed
decision-makers: Toolkit maintainers
group: How we work
---

# The toolkit's APM package carries only the journey skills, and the maintainers' skills are development-only

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[The toolkit reaches each repo through APM, pinned to a release tag](0051-the-toolkit-reaches-each-repo-through-apm-pinned-to-a-release-tag-and-nothing-in-it-is-copied.md).
APM installs a package's skills only from its `.apm/` folder, and the toolkit's skills are in `.github/skills/`,
where its own evals and maintainers read them. Two of them, for working the toolkit's backlog and writing its
decision records, mean nothing in an adopting repo, and the two third-party skills they depend on would reach every
repo. Installed skills are copies; APM rewrites their links to the toolkit's folder under `apm_modules/`, but not file
paths inside commands.

## Considered Options

* **`.apm/skills/` links to each journey skill; the third-party skills are `devDependencies`**  
  One copy of each skill; an adopting repo gets exactly the journey's skills and nothing for maintainers
* **Move the skills into `.apm/skills/`**  
  The evals, the plugin and every link to `.github/skills/` would move with them
* **Link the whole `.github/skills/` folder**  
  Simplest, but adopters get the maintainers' skills and their dependencies

## Decision Outcome

Proposed: `.apm/skills/` holds a link to each journey skill, and the third-party skills are `devDependencies`, which
`apm install` installs only in the toolkit itself. Each journey skill says where the toolkit's files are: its links
work as they are, and a command naming `<toolkit>` finds the toolkit's root under `apm_modules/`.

### Consequences

* A new journey skill reaches adopters only once it is linked from `.apm/skills/`.
* `maintainer-tools/apm-package/check-install.sh` installs a commit into an empty project and checks the skills and
  their links, before each release.
* The adoption guide gives an adopting repo's `apm.yml`.

## More Information

* Builds on: [The toolkit reaches each repo through APM, pinned to a release tag, and nothing in it is copied](0051-the-toolkit-reaches-each-repo-through-apm-pinned-to-a-release-tag-and-nothing-in-it-is-copied.md)
* Later decisions that build on this: none yet
* Background: none
