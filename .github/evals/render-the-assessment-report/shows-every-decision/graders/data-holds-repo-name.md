---
type: regex
pattern: 'id="report-data">([^<]|<[^/])*?"repo"\s*:\s*\{\s*"name"\s*:\s*"orders-service"'
match: contains
target: {source: file, path: testing/assessment-report.html}
---
The assessment file's repo name is inside the data block (the pattern can't cross a `</`, so it stays inside the block).
