---
type: regex
pattern: 'id="report-data">([^<]|<[^/])*?"techniques/recorded-http-responses"\s*:\s*\{'
match: contains
target: {source: file, path: testing/assessment-report.html}
---
A decision key from the assessment file is inside the data block, as the key of its entry.
