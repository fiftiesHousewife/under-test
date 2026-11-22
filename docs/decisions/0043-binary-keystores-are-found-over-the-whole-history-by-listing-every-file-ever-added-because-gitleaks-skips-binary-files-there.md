---
status: proposed
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# Binary keystores are found over the whole history by listing every file ever added, because gitleaks skips binary files there

**Decided by:** Toolkit maintainers · **Status:** proposed

*This is a decision about the toolkit itself, made by its maintainers.*

## Context and Problem Statement

[Keystores and private key files are found over the whole history by rules added to the secrets scan](0041-keystores-and-private-key-files-are-found-over-the-whole-history-by-rules-added-to-the-secrets-scan.md)
added rules that match keystores by file name. Tried with gitleaks 8.28.0: a scan of current files (`gitleaks dir`)
finds a binary keystore by its name, but a scan of the history (`gitleaks git`) skips binary files, so a binary
keystore (`.jks`, `.p12` and the like) committed and later deleted isn't found. A text key file (PEM) is. gitleaks
also skips empty files, which is why the sample repo's empty fixture files went unfound in CI.

## Considered Options

* **List every file ever added with `git log`, and treat each keystore in it as a finding**  
  Uses git, which every repo already has; one line in the skill and the CI job; finds deleted keystores whatever
  their content
* **Scan each commit's tree with `gitleaks dir`**  
  Finds them, but checks out every commit: slow on a long history
* **Accept the gap**  
  A keystore deleted years ago, still in the history with its private key, goes unnoticed

## Decision Outcome

Proposed: the first option. The key-file rules stay in the secrets scan for text key files, and for keystores in
the current files.

### Consequences

* The run-the-safety-inventory skill and the safety inventory's README run the `git log` list as a third step, and
  turn each keystore in it into a blocking finding with the commit that added it.
* `maintainer-tools/safety-inventory-rules/check.sh` checks the list finds a deleted binary keystore, and fails if a
  sample-repo file is empty.
* The sample repo's keystore, database dump and native library have a few bytes of invented binary content.

## More Information

* Builds on: [Keystores and private key files are found over the whole history by rules added to the secrets scan](0041-keystores-and-private-key-files-are-found-over-the-whole-history-by-rules-added-to-the-secrets-scan.md), [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md)
* Later decisions that build on this: none yet
* Background: none
