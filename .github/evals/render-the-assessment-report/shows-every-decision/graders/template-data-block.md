---
type: regex
pattern: '<script type="application/json" id="report-data">'
match: count:1
target: {source: file, path: testing/assessment-report.html}
---
The page is the template: it holds the template's one data block, with the id its script reads.
