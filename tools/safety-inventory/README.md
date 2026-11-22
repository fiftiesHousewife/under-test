# Safety inventory

Finds what in a repo could reach production or real data, before any of its code is built or run. It is two rule
files for [gitleaks](https://github.com/gitleaks/gitleaks), the secrets scanner every repo's CI already runs, so there
is nothing new to install or approve:

* [`secrets.gitleaks.toml`](secrets.gitleaks.toml), run over the whole history: gitleaks' own rules, plus keystores and
  private key files by name, which gitleaks' own rules don't all find. gitleaks skips binary files in the history, so
  a binary keystore committed and later deleted is found by listing every file ever added with `git log` instead;
* [`safety-inventory.gitleaks.toml`](safety-inventory.gitleaks.toml), run over the current files: everything else.

## What it finds

| Kind | Effect | Rules |
|---|---|---|
| Keystores and private keys, over the whole history | blocks | `keystore-file`, `private-key-file`, in the secrets rules |
| Production credentials in settings | blocks | `password-in-settings`, `credentials-in-jdbc-url` |
| Real personal data in fixtures and dumps | blocks until a person decides | `email-addresses-in-data-files`, `database-dump-file` |
| Jobs that start by themselves | neutralise | `scheduled-job`, `batch-job-runs-at-start-up` |
| Database migrations at start-up | neutralise | `migration-tool`, `schema-changed-at-start-up` |
| Build tasks that publish or deploy | neutralise | `publishing-build-task` |
| Fixed file paths and Windows file shares | neutralise | `windows-file-share`, `fixed-file-path` |
| Native libraries | neutralise | `native-library-loaded`, `native-library-file` |

*Blocks* means no run until it's resolved. *Neutralise* means it is made harmless in the test profile or the build,
and recorded.

## Running it

In CI, before the repo's code is built, next to the secrets scan over the whole history:

```bash
gitleaks git --config secrets.gitleaks.toml --report-format json --report-path secrets.json .
gitleaks dir --config safety-inventory.gitleaks.toml --report-format json --report-path safety-inventory.json .
git log --all --diff-filter=A --name-only --format='commit %h' \
  | awk '/^commit /{c=$2; next} tolower($0) ~ /\.(jks|jceks|keystore|truststore|p12|pfx|bks|pkcs12)$/ {print $0 "  " c}' \
  | sort -u > keystores-ever-added.txt
```

The [run-the-safety-inventory](../../.github/skills/run-the-safety-inventory/SKILL.md) skill turns the reports and the list into the `safety` section of `testing/assessment.yaml`. A finding
that isn't real goes in the repo's `.gitleaksignore` with a reason, in a pull request the Security and Platform Owner
approves.

## Checking the rules

[`sample-repo/`](sample-repo) holds files that should and shouldn't match, and
[`sample-repo-expected-findings.txt`](sample-repo-expected-findings.txt) lists the rule and file of every finding the
inventory's rules must produce over it, and
[`sample-repo-expected-secrets-findings.txt`](sample-repo-expected-secrets-findings.txt) the findings the secrets
rules add to gitleaks' own. The files in it are made up: no secret or address in them is real. This repo's CI runs
gitleaks over it with both rule files and compares the findings (see
[`maintainer-tools/safety-inventory-rules/check.sh`](../../maintainer-tools/safety-inventory-rules/check.sh)).

The reasoning is in [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](../../docs/decisions/0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md).
