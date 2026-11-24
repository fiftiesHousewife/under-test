---
name: run-the-safety-inventory
description: Turn a repo's gitleaks reports into the safety section of its testing/assessment.yaml, before any of its tests or its application run. Use when starting work on a repo, or when asked for its safety inventory or secrets scan.
---

# Running the safety inventory

**Where the toolkit's files are:** this skill's links are relative to its folder in the toolkit, `.github/skills/run-the-safety-inventory/`. In the toolkit's own repo, follow them as they are. In a repo that installed the toolkit with APM, this skill is a copy, so read each link from the toolkit's package folder instead: `TOOLKIT="$(dirname "$(find apm_modules -path '*/.github/skills/run-the-safety-inventory/SKILL.md' | head -1)")/../../.."`, then `$TOOLKIT/<the link without its ../../../>`.

Turn two gitleaks reports and a keystore list into the `safety` section of `testing/assessment.yaml`
([its schema](../../../schema/assessment.schema.json)), then say what blocks the repo. Why:
[The safety inventory is a gitleaks rule file run over a repo's current files, with a small converter into the assessment file](../../../docs/decisions/0039-the-safety-inventory-is-a-gitleaks-rule-file-run-over-a-repos-current-files-with-a-small-converter-into-the-assessment-file.md)
and [Binary keystores are found over the whole history by listing every file ever added, because gitleaks skips binary files there](../../../docs/decisions/0043-binary-keystores-are-found-over-the-whole-history-by-listing-every-file-ever-added-because-gitleaks-skips-binary-files-there.md).

**Never** build, test or start the repo's code, or run its build tool. **Never** write a report's `Secret` or
`Match` value anywhere: not in the file, not in your reply.

## 1. Get the inputs

Use whichever of the three files exist (CI makes them); make the missing ones in the repo's root:

```bash
gitleaks git --config <toolkit>/tools/safety-inventory/secrets.gitleaks.toml \
  --report-format json --report-path secrets.json .
gitleaks dir --config <toolkit>/tools/safety-inventory/safety-inventory.gitleaks.toml \
  --report-format json --report-path safety-inventory.json .
git log --all --diff-filter=A --name-only --format='commit %h' \
  | awk '/^commit /{c=$2; next} tolower($0) ~ /\.(jks|jceks|keystore|truststore|p12|pfx|bks|pkcs12)$/ {print $0 "  " c}' \
  | sort -u > keystores-ever-added.txt
```

The rules are [the secrets rules](../../../tools/safety-inventory/secrets.gitleaks.toml) (whole history) and
[the inventory's rules](../../../tools/safety-inventory/safety-inventory.gitleaks.toml) (current files). If a report
is missing and gitleaks 8.21 or later isn't installed, stop and say so: the scan runs in CI.

* **version**: the version of gitleaks that made the reports: what `gitleaks version` prints if you made them, else
  the version the person or CI states, else `unknown`.
* **commit**: what `git rev-parse --short HEAD` prints in the repo.

Read only `RuleID`, `File`, `StartLine`, `Commit`, `Description` and `Tags` from each report (a JSON array); `Secret`
is read only by the check in step 5, which never prints it.

## 2. Make the findings

**Sources.** Every object in either report, and every line `<path>  <commit>` of `keystores-ever-added.txt`. A list
line is a finding of rule `keystore-file`, `Description` "A keystore or certificate store, which usually holds a
private key", kind `keystore-or-private-key`, effect `blocks`, found by name. Skip a list line whose path is a whole
line, or a `:`-separated field of a line, in `.gitleaksignore`. If `secrets.json` has a `keystore-file` finding for the same
path, add the list line's `where` entry to it instead of making a new finding. A list line counts as tagged, so its
id gets no `secret-`.

**Group** by `RuleID` and `File`: one finding each, even for a file now gone from the current files.

**id** (decisions point at it, so it must be the same on every run):

1. Take the last part of `File`'s path and remove its last extension, unless its only `.` is its first character.
2. Join as `<RuleID>-<name>`; a rule with no tags (one of gitleaks' own) gets `secret-` in front.
3. Lower-case; replace each run of characters other than `a-z` and `0-9` with one `-`; trim `-` from both ends.
4. If findings share an id, every one of them keeps its extension when that makes them all differ
   (`application-properties`); otherwise each adds its parent folders, nearest first, before the name without its
   extension, until they all differ. A file in the repo's root adds none.

| Finding | `kind` | `effect` |
|---|---|---|
| has `kind:` and `tier:` tags | the `kind:` tag's value | the `tier:` tag's value |
| no tags, `RuleID` contains `private-key`, `pkcs12`, `jks` or `keystore` | `keystore-or-private-key` | `blocks` |
| no tags, any other rule | `committed-secret` | `blocks` |

**what**: the `Description`, never the matched text; left out if empty.

**where**: one entry per line found, `<c7>` being the commit's first 7 characters. Drop duplicates; sort by path,
then line as a number, then commit.

| Source | `StartLine` above 0 | `StartLine` 0 (found by its name) |
|---|---|---|
| `safety-inventory.json` | `path:line` | `path` |
| `secrets.json` | `path:line, in commit <c7>` | `path, in commit <c7>` |
| `keystores-ever-added.txt` | | `path, in commit <c7>` |

## 3. Write the section

Replace the `safety` section in place, or insert it where the schema's order of sections puts it, with no blank line
between sections. Edit the text;
never rewrite the file through a YAML library. Findings sorted by id in byte order (`findings: []` if none), in
this form:

```yaml
safety:
  found_by: {tool: gitleaks, version: "<version>", commit: "<commit>"}
  findings:
    - id: publishing-build-task-build
      kind: publishing-build-task
      effect: neutralise
      what: "A build that can publish or deploy: check it can't run from an ordinary build"
      where: ["build.gradle:1", "build.gradle:2"]
```

Always double-quote `version`, `commit` and each `where` entry; double-quote any other text value that starts with
anything but a letter or contains `:` or `#`, writing `"` as `\"` and `\` as `\\`. Lists stay on one line, joined by
`, `.

A new file starts `# yaml-language-server: $schema=<schema>` (the relative path from `testing/` to the toolkit's
`schema/assessment.schema.json` if the toolkit is installed next to the repo, otherwise
`https://raw.githubusercontent.com/fiftiesHousewife/under-test/main/schema/assessment.schema.json`), then
`schema: assessment/1`, then `repo:` with `name:` the repo's folder name. Leave every other section as it is.

## 4. Keep people's decisions

`decisions` belong to people. Change a `safety/<id>` decision only to set its `state`:

* `stale` if its id has no finding now;
* `proposed` if it was `stale` and its id has a finding again: tell the person.

Then for each finding with no `safety/<id>` decision, in id order, add one at the end of `decisions` (a new section
goes where the schema's order puts it): one key per line, unquoted, as below. Kinds with no field get
only `state` and `drafted_by`.

```yaml
decisions:
  safety/scheduled-job-orderreminderjob:
    state: proposed
    drafted_by: ai
    choice: off in the test profile
```

| `kind` | Field |
|---|---|
| `real-personal-data` | `question: Do these files hold real people's details? If not, say how you know.` |
| `self-starting-job`, `migration-at-start-up` | `choice: off in the test profile` |
| `publishing-build-task` | `choice: unhooked from the ordinary build` |
| `fixed-path-or-file-share` | `choice: a temporary folder in the test profile` |
| `native-library` | `choice: not loaded in tests` |
| any other | no field: a person must rotate and remove a secret, key or credential, or excuse a false finding |

## 5. Check, then report

Check the file against [the schema](../../../schema/assessment.schema.json) if a validator is to hand, and that ids are
unique. Then check no secret is in it, which must print `0`:
`jq -r '.[].Secret | select(length > 0)' secrets.json safety-inventory.json | grep -cFf - testing/assessment.yaml`.
If it prints more than 0, find the matching line (without printing the secret) and remove the value from it; if
the match is only a path or a rule's description, say so and carry on.

Then tell the person, briefly, in this order, each item's findings by id and file, in id order, and an empty item as "none":

1. **Blocks the repo:** each `blocks` finding except personal data, by id and file. For a secret or key: rotate it,
   then remove it from the history; a real production secret is a security incident
   ([A production secret found in a repo is handled as a security incident](../../../decision-guides/0011-a-production-secret-found-in-a-repo-is-handled-as-a-security-incident.md)).
   A finding that isn't real goes in `.gitleaksignore` with a reason, in a pull request the Security and Platform
   Owner approves ([No repo's tests or application run until its secrets scan is clean](../../../decision-guides/0007-no-repos-tests-or-application-run-until-its-secrets-scan-is-clean.md)).
2. **Needs a person's answer:** suspected personal data, which blocks until answered.
3. **To neutralise:** the rest, with the proposed choices.
4. Decisions marked stale or reopened.
5. End with: "None of the repo's tests, nor its application, may run until every blocking finding is resolved; building it
   without running its tests is allowed."
