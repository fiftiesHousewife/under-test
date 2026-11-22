# Safety inventory

Finds what in a repo could reach production or real data, before any of its code is built or run. It is a rule file
for [gitleaks](https://github.com/gitleaks/gitleaks), the secrets scanner every repo's CI already runs, so there is
nothing new to install or approve.

## What it finds

| Kind | Effect | Rules |
|---|---|---|
| Keystores and private keys | blocks | `keystore-file`, `private-key-file` |
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
gitleaks git --report-format json --report-path secrets.json .
gitleaks dir --config safety-inventory.gitleaks.toml --report-format json --report-path safety-inventory.json .
```

The converter, still to be built, writes both reports into the `safety` section of `testing/assessment.yaml`. A finding
that isn't real goes in the repo's `.gitleaksignore` with a reason, in a pull request the Security and Platform Owner
approves.

## Checking the rules

[`sample-repo/`](sample-repo) holds files that should and shouldn't match, and
[`sample-repo-expected-findings.txt`](sample-repo-expected-findings.txt) lists the rule and file of every finding it
must produce. The files in it are made up: no secret or address in them is real.

The reasoning is in [The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](../../docs/decisions/0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md).
