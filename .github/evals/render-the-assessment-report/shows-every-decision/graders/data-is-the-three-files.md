---
type: regex
pattern: 'id="report-data">\s*\{\s*"assessment"\s*:\s*\{'
match: contains
target: {source: file, path: testing/assessment-report.html}
---
The data block is the one JSON object the skill makes, starting with the assessment file.
