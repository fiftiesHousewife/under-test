---
status: accepted
decision-makers: Toolkit maintainers
group: How we work
---

# Every repo's backlog is synced to its issues by one shared GitHub Actions workflow, on push

**Decided by:** Toolkit maintainers · **Status:** accepted (chosen in discussion)

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

The toolkit, the airgap agent and the lessons repo each kept a copy of a push script, an issue importer and a git
hook that refused a plain push. The copies drifted: a fix to the importer reached one repo only. Each push ran on the
maintainer's machine with their GitHub credentials, waited for the build and then for hundreds of issue and link
calls, and could not run from an AI assistant's sandbox at all, so every push was a command typed by hand.

## Considered Options

* **One reusable GitHub Actions workflow in the toolkit, called by each repo on push**  
  One importer; no credentials or script on any machine; pushing is a plain `git push`
* **One shared local script, fetched at a tag or run from under-test-tools**  
  One copy, but still run by hand with the maintainer's credentials

## Decision Outcome

Chosen in discussion: one reusable workflow, `.github/workflows/backlog-sync.yml`, using the one importer in
`tools/backlog-import/`. Each repo has a short workflow of its own that calls it with its backlog file, on each push to
`main` that changes that file, and by hand with `relink` to post every issue link again. It runs with the run's own
token, one import at a time per repo, and commits the refreshed backlog page itself.

* Pushing is `./gradlew check`, then a plain `git push`; CI's build check runs on the push as before.
* The push scripts, the copied importers and the hooks that refused a plain push are deleted from every repo.

### Consequences

* The backlog page arrives as its own commit from GitHub Actions after a push; pull before the next change.
* The airgap agent's and the lessons repo's own copies go when each adds its calling workflow.
* A backlog key still never changes: the importer matches issues by key.

## More Information

* Builds on: [The programme backlog lives in the organisation's issue tracker, not in a file](0009-the-programme-backlog-lives-in-the-organisations-issue-tracker-not-in-a-file.md), [This repo's own upkeep is kept apart from what adopting organisations use](0034-this-repos-own-upkeep-is-kept-apart-from-what-adopting-organisations-use.md)
* Later decisions that build on this: none yet
* Background: none
