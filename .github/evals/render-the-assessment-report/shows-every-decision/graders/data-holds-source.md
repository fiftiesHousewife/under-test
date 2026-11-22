---
type: regex
pattern: 'id="report-data">([^<]|<[^/])*?"id"\s*:\s*"refund-policy"'
match: contains
target: {source: file, path: testing/assessment-report.html}
---
A source id from the source list is inside the data block.
