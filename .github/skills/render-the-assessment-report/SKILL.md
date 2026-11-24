---
name: render-the-assessment-report
description: Make a repo's assessment report, one self-contained HTML page from its testing/assessment.yaml, testing/external-systems.calm.json and testing/sources.yaml, and apply the changes people paste back from it to those files. Use when asked for a repo's report, status page or a summary for its owners, or when someone pastes changes copied from the report.
---

# Rendering the assessment report

The report is [a fixed template](../../../templates/repo-assessment-report.html) whose script draws the page from one
JSON data block. Fill that block and change nothing else: don't write the page by hand, edit the template's script or
styles, or put anything in the data that isn't in the files. The files follow
[the assessment file's schema](../../../schema/assessment.schema.json),
[the external systems list's](../../../schema/external-systems-list.schema.json) and
[the source list's](../../../schema/source-list.schema.json). The page is never edited: make it again instead.

Never copy a secret's value (a password, key or token met in code, settings or a report) into a file you write or
your reply: point at its file and line instead
([why](../../../docs/decisions/0069-the-safety-inventory-is-a-gate-before-the-first-run-and-no-skill-ever-copies-a-secret.md)).

## 1. Make the report

Run this from the repo's root, with `TEMPLATE` set to the template's path: the toolkit's root is three folders up
from this skill's folder (`<skill folder>/../../..`), and the template is `templates/repo-assessment-report.html` there:

```bash
ruby -ryaml -rjson -e '
r = ->(f) { File.exist?(f) ? File.read(f, encoding: "UTF-8") : nil }
a, c, s = r["testing/assessment.yaml"], r["testing/external-systems.calm.json"], r["testing/sources.yaml"]
abort "testing/assessment.yaml is missing" unless a
j = JSON.generate({"assessment" => YAML.safe_load(a), "connections" => c && JSON.parse(c),
  "sources" => s && YAML.safe_load(s)}).gsub("</", "<\\/")
h = File.read(ARGV[0], encoding: "UTF-8").sub(/(id="report-data">\n).*?(\n<\/script>)/m) { $1 + j + $2 }
JSON.parse(h[/id="report-data">\n(.*?)\n<\/script>/m, 1])
File.write("testing/assessment-report.html", h)
puts h[/---- Summary.*?var reached/m]' "$TEMPLATE"
```

Without Ruby, give the same bytes another way, reading the YAML as YAML 1.1 does (as Ruby's parser does) and writing numbers as Ruby does
(`61.0` stays `61.0`): `{"assessment":…,"connections":…,"sources":…}` on one line, those
three keys in that order and every other key in file order, `null` for a missing connection or source list, no spaces after `,` or `:`,
non-ASCII characters as they are, and every `</` as `<\/`; put it between the data block's tags, keeping their line
breaks, and check it parses. If `testing/assessment.yaml` is missing or the command fails, write no page and say why.
No `testing/sources.yaml` (or no external systems list) is not a failure: there is no source list yet, so `sources` is
`null`, the page says "No source list yet.", and you carry on.

The command ends by printing the template's summary script. Work out its three answers for these files, exactly as
that script does, and reply with exactly these lines, as plain text, not in a code block, and nothing else:

```
The report is at testing/assessment-report.html.

* Is it safe to run? <answer>
* Does it run on its own? <answer>
* Can its tests be trusted? <answer>
```

Each `<answer>` is the script's text for that question, word for word, with its counts filled in and its `(s)` and
`(es)` kept as they are. Then:

* Where the branch the script chose shows a count of findings or relationships (`blocking`, `toNeutralise`,
  `toProduction`, `noStandIn`, `unconfirmed`), add " They are: " and each one counted, in file order, separated by ", ", ending with ".": a
  finding as its `id`, followed by " (<what>)" if it has a `what`; a relationship as its `unique-id`. With
  `toProduction` and `blocking` both counted, the relationships come first.
* Start the tests answer with the light it gives: "No. " for `block`, "Not fully. " for `warn`, "Yes. " for `ok`, nothing for no light.

## 2. Apply the changes people paste back

What people paste has up to two parts, each headed by a comment naming its file. Keep every other byte of each file.

* **`testing/assessment.yaml`:** each pasted entry replaces, in full and in place, the entry under `decisions` with
  the same key, written as pasted (two-space indent).
* **`testing/external-systems.calm.json`:** every `#   <unique-id>: …` line is one entry. In that relationship's
  `metadata.under-test`, replace `stand-in` in full with the pasted one, written one key per line at the file's
  two-space indentation, and set `state` and `by`; a key not there yet goes at the end, in that order. Leave
  `drafted_by` as it is.

A decision key with no entry yet is added at the end of `decisions` when what it decides is in the files: a finding
(`safety/`, `running-offline/`, `meaningless/`, `unreliable/`), a technique (`techniques/`), `level/target`, a `repo/` field, or a
question. Any other key, and any relationship not in the external systems list, is refused: say so.

The `by` on each entry is the role the person chose on the page. The role that decides each kind is:

| Entry | Decided by |
|---|---|
| `safety/` | Security and Platform Owner |
| a connection's stand-in, `running-offline/` | Architecture Owner |
| `meaningless/`, `unreliable/`, `questions/`, `repo/` | Application Owner |
| `techniques/`, `level/target` | Test Quality Lead |

If an entry's `by` isn't the role that decides it, or the person pasting has said they're in another role, apply it
and say so: the pull request's reviewer decides.

Then check each changed file against its schema if a JSON Schema validator is installed (say if none is); if one
fails, undo that file's changes and report the error. Make the report again as in step 1, and reply with step 1's
lines, then a blank line, then "Changed: " and "Refused: " on lines of their own, each a comma-separated list of keys and relationships in paste order, or
"none".
