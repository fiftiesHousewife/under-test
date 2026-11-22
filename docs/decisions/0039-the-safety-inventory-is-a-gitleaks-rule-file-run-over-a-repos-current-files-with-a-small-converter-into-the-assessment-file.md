---
status: accepted
decision-makers: Toolkit maintainers
group: Using the toolkit in an organisation
---

# The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file

## Context and Problem Statement

[Before any code runs, a safety inventory records what could reach production or real data, and some findings block the run](../../decision-guides/0057-before-any-code-runs-a-safety-inventory-records-what-could-reach-production-or-real-data-and-some-findings-block-the-run.md)
lists what to look for beyond secrets: keystores and private keys, production credentials in settings, real personal
data in fixtures and dumps, jobs that start by themselves, migrations at start-up, build tasks that publish or deploy,
fixed paths and Windows file shares, and native libraries. All of it must be found without running any of the repo's
code, and the toolkit maintainers want no more custom code than needed. gitleaks already runs in CI on every repo, before
anything is built (see [On developer machines, secrets are checked by FindSecBugs for now, and gitleaks in CI stays the gate](0038-on-developer-machines-secrets-are-checked-by-findsecbugs-for-now-and-gitleaks-in-ci-stays-the-gate.md)),
and its rule files accept custom rules: a pattern on file contents, a pattern on file paths, or both, with tags.

## Considered Options

* **A gitleaks rule file for the inventory, run over the repo's current files (`gitleaks dir`) next to the secrets
  scan, and a small converter from gitleaks' JSON report into the assessment file**  
  Nothing new to approve or run; one tool and one report format for the whole safety inventory. Every finding is a
  file and line, and a finding that isn't real is excused the same way as a secret, in `.gitleaksignore`. Patterns
  can't understand code, so a few findings need a person's judgement, and real personal data can only be suspected
* **A Java tool with a check per kind, parsing code and build files**  
  More precise for code (it could tell a test profile from a production one), but it is the custom code we want to
  avoid
* **OpenRewrite search recipes for the code-level checks**  
  Precise and reusable, but running them through a build runs the repo's build scripts, which is running its code
* **Semgrep or another rule-based code scanner**  
  Good at code patterns, but needs Python or a native program and its own approval

## Decision Outcome

Accepted: the first option. It was chosen in discussion by the toolkit maintainers. The rules are in
[`tools/safety-inventory/safety-inventory.gitleaks.toml`](../../tools/safety-inventory/safety-inventory.gitleaks.toml).
Each rule is tagged with the kind of finding from the assessment file's schema and with its effect: `tier:blocks`
or `tier:neutralise`. The inventory runs over current files, not the history: the history is the secrets scan's job,
and gitleaks' own rules already find keys and keystores committed in the past. For real personal data the rules find
files to look at, data files with addresses that aren't reserved for examples and database dumps, and a person
decides, as a decision in the assessment file.

### Consequences

* The rule file, with a [sample repo](../../tools/safety-inventory/sample-repo) and the
  [findings it must produce](../../tools/safety-inventory/sample-repo-expected-findings.txt); this repo's CI checks
  them with gitleaks itself.
* A small converter writes the `safety` section of the assessment file from gitleaks' report, using each rule's tags.
* The CI template for a repo's first scan runs both: `gitleaks git` with gitleaks' own rules, and `gitleaks dir` with
  the inventory's.
* A Java check is the option to revisit if patterns give too many false findings for a kind.

## More Information

* Builds on: [We reuse existing tools before building new ones](0021-we-reuse-existing-tools-before-building-new-ones.md), [On developer machines, secrets are checked by FindSecBugs for now, and gitleaks in CI stays the gate](0038-on-developer-machines-secrets-are-checked-by-findsecbugs-for-now-and-gitleaks-in-ci-stays-the-gate.md), [The assessment file: where it lives, who writes which fields, and its schema version](../../decision-guides/0023-the-assessment-file-where-it-lives-who-writes-which-fields-and-its-schema-version.md)
* Later decisions that build on this: none yet
* Background: [production-safety](../REFERENCES.md#production-safety); [gitleaks configuration](https://github.com/gitleaks/gitleaks#configuration)
