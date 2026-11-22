---
name: run-the-safety-inventory
description: Run a repo's safety inventory with gitleaks, before any of its code is built or run, and write the safety section of its testing/assessment.yaml. Use when starting work on a repo, when asked for its safety inventory or secrets scan, or when gitleaks reports need turning into the assessment file.
---

# Running the safety inventory

The safety inventory finds what in a repo could reach production or real data, before any of its code is built or
run. Two gitleaks scans find it; you turn their reports into the `safety` section of `testing/assessment.yaml`
([its schema](../../../schema/assessment.schema.json)) and tell the person what blocks the repo.

**Never** build, test or start the repo's code, or run its build tool: a Gradle or Maven build runs the repo's own
scripts. **Never** copy a report's `Secret` or `Match` value anywhere: not into the file, not into your reply.

## 1. Get the reports

If the reports already exist (CI makes them), use them. Otherwise, where gitleaks 8.21 or later is installed:

```bash
gitleaks git --config <toolkit>/tools/safety-inventory/secrets.gitleaks.toml \
  --report-format json --report-path secrets.json .
gitleaks dir --config <toolkit>/tools/safety-inventory/safety-inventory.gitleaks.toml \
  --report-format json --report-path safety-inventory.json .
git log --all --diff-filter=A --name-only --format='commit %h' \
  | awk '/^commit /{c=$2; next} tolower($0) ~ /\.(jks|jceks|keystore|truststore|p12|pfx|bks|pkcs12)$/ {print $0 "  " c}' \
  | sort -u > keystores-ever-added.txt
gitleaks version
git rev-parse --short HEAD
```

The first scans the whole history with [the secrets rules](../../../tools/safety-inventory/secrets.gitleaks.toml):
gitleaks' own, plus key files by name. The second scans current files with
[the inventory's rules](../../../tools/safety-inventory/safety-inventory.gitleaks.toml). Both honour the repo's
`.gitleaksignore`. The third lists every keystore ever added, with the commit that added it: gitleaks skips binary
files when it scans the history, and keystores are binary, so a keystore committed and later deleted is found only
by this list. If gitleaks isn't available, stop and say so: the scan runs in CI.

Each line of the keystore list is a `keystore-file` finding (kind `keystore-or-private-key`, effect `blocks`), the
same as one from the secrets report, with `where` as `path, in commit <commit>`. If the secrets report found the
same file, keep one finding with every `where`. A listed keystore that the repo's `.gitleaksignore` names by its
path is left out.

## 2. Turn findings into the safety section

Each report is a JSON array; use `RuleID`, `File`, `StartLine`, `Commit`, `Description` and `Tags` only.

**Group** by rule and file: one finding per rule per file, with every line in `where`.

**Ids** must come out the same on every run, because decisions point at them:
`<RuleID>-<file name without its extension>`, lower case, anything but letters and digits turned into `-`, repeated
`-` collapsed. If two findings would share an id, add the parent folder's name before the file name. A finding
from one of gitleaks' own rules (it has no tags) gets `secret-` in front. Examples: `keystore-file-payments-client`,
`scheduled-job-orderreminderjob`, `secret-aws-access-token-application`.

| Finding | `kind` | `effect` |
|---|---|---|
| has `kind:` and `tier:` tags (either report) | from the `kind:` tag | from the `tier:` tag |
| no tags, rule id contains `private-key`, `pkcs12`, `jks` or `keystore` | `keystore-or-private-key` | `blocks` |
| no tags, any other rule | `committed-secret` | `blocks` |

A keystore or secret deleted from the current files is still a finding while it is in the history: it blocks until
the history is rewritten and the scan no longer finds it.

Fill each finding:

* `what`: the rule's `Description`, never the matched text.
* `where`: `path:line` for each line, sorted. For a finding from the secrets report add the commit, as
  `path:line, in commit <first 7 characters>`, or `path, in commit <first 7 characters>` for a file found by its
  name alone. For a file the inventory found by its name alone, just the path.

Write the section in full, replacing any `safety` section already there, findings sorted by id:

```yaml
safety:
  found_by: {tool: gitleaks, version: "<gitleaks version>", commit: "<short commit>"}
  findings:
    - id: keystore-file-payments-client
      kind: keystore-or-private-key
      effect: blocks
      what: A keystore or certificate store, which usually holds a private key
      where: ["src/main/resources/certs/payments-client.jks, in commit c0ffee1"]
    - id: scheduled-job-orderreminderjob
      kind: self-starting-job
      effect: neutralise
      what: A job that starts by itself on a timer or at start-up
      where: ["src/main/java/com/example/OrderReminderJob.java:3"]
```

Put every `where` entry in double quotes: a `path:line` left bare breaks some YAML readers.

If the file doesn't exist yet, create it with `schema: assessment/1`, a `repo:` with at least `name`, and the
`# yaml-language-server: $schema=...` first line pointing at the toolkit's schema: a relative path to it where the toolkit is installed next to the repo, otherwise `https://raw.githubusercontent.com/fiftiesHousewife/under-test/main/schema/assessment.schema.json`. Leave every other section as it is.

## 3. Keep people's decisions

`decisions` belong to people. Don't change one, except:

* a `safety/<id>` decision whose finding has gone: set `state: stale`, keep the rest;
* a stale decision whose finding is back: set `state: proposed`, and tell the person.

Then add a **proposed** decision, only where none exists for that id, marked `state: proposed` and `drafted_by: ai`:

| Kind | Proposed |
|---|---|
| `real-personal-data` | `question:` "Do these files hold real people's details? If not, say how you know." (no `choice`) |
| `self-starting-job`, `migration-at-start-up` | `choice:` "off in the test profile" |
| `publishing-build-task` | `choice:` "unhooked from the ordinary build" |
| `fixed-path-or-file-share` | `choice:` "a temporary folder in the test profile" |
| `native-library` | `choice:` "not loaded in tests" |

Propose nothing for secrets, keys and credentials: a person must rotate and remove them, or excuse a false finding.

## 4. Check, then report

Check the file against [the schema](../../../schema/assessment.schema.json) with a JSON Schema validator if one is to
hand (an editor reading the first line does it). Either way, check that every `kind` and `effect` is one the schema
lists, every id is unique and follows the rule above, and no secret value appears.

Then tell the person, briefly, blocking findings first:

1. **Blocks the repo:** each finding, by id and file. For a secret or key: rotate it, then remove it from the
   history; if it is a real production secret, it is a security incident
   ([A production secret found in a repo is handled as a security incident](../../../decision-guides/0011-a-production-secret-found-in-a-repo-is-handled-as-a-security-incident.md)).
   A finding that isn't real goes in `.gitleaksignore` with a reason, in a pull request the Security and Platform Owner
   approves ([No repo's code is built or run until its secrets scan is clean](../../../decision-guides/0007-no-repos-code-is-built-or-run-until-its-secrets-scan-is-clean.md)).
2. **Needs a person's answer:** suspected personal data.
3. **To neutralise:** the rest, with the proposed choices.
4. Decisions marked stale or reopened.

Nothing in the repo may be built or run until every blocking finding is resolved.
