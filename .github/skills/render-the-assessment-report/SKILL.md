---
name: render-the-assessment-report
description: Make a repo's assessment report, one self-contained HTML page from its testing/assessment.yaml, testing/connections.calm.json and testing/sources.yaml, and apply the changes people make on it back to those files. Use when asked for a repo's report, its status page or a summary for its owners, or when someone pastes changes copied from the report.
---

# Rendering the assessment report

The report is [a fixed template](../../../templates/repo-assessment-report.html). Its script draws every section from
one JSON block, so the page looks the same for every repo and needs no network or server. Your part is mechanical:
put the repo's data in the block, and later put people's changes back in the files. **Don't** write the page by hand,
change the template's script or styles, or add anything to the data that isn't in the files.

## 1. Make the report

1. Read, from the repo: `testing/assessment.yaml`, and if they exist `testing/connections.calm.json` and
   `testing/sources.yaml`.
2. Make one JSON object: `{"assessment": <assessment file>, "connections": <connection list or null>,
   "sources": <source list or null>}`. Convert the YAML exactly, keeping every key and value; leave out only the
   `# yaml-language-server` comment line. Use a YAML library or a converter where one is to hand (for example
   `ruby -ryaml -rjson -e 'puts JSON.generate(YAML.safe_load(File.read(ARGV[0])))' testing/assessment.yaml`), rather than
   converting by eye.
3. Replace every `</` in the JSON with `<\/`, so nothing in the data can end the script block.
4. Copy the template to `testing/assessment-report.html` and replace the contents of
   `<script type="application/json" id="report-data">` with the JSON. Change nothing else in the file.
5. Check the block parses as JSON. Tell the person where the page is, and the summary's three answers: is it safe to
   run, does it run on its own, can its tests be trusted.

The page is generated: it is rebuilt from the files each time, and is not edited.

## 2. Apply the changes people paste back

On the page, people choose their role, change decisions and stand-ins, and copy the changes. What they paste has
two parts, each headed by the file it belongs to.

* **`testing/assessment.yaml`:** each entry goes under `decisions`, replacing any entry with the same key in full.
  Keep the file's other sections, its first line, and the order of the other decisions.
* **`testing/connections.calm.json`:** for each relationship named, set `stand-in`, `state` and `by` in its
  `metadata.under-test`, keeping every other field.

Then check both files against their schemas if a validator is at hand, make the report again, and tell the person
what changed. If a pasted change names a key or relationship that isn't in the files, say so and don't add it: the
report only changes what it showed.

A change is made by a person, in a pull request; the role on each entry is the one they chose on the page. If the
person pasting it isn't in that role, say so: the role that decides each kind of entry is set by the decision guides.
