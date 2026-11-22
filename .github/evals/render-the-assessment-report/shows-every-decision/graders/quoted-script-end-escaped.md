---
type: regex
pattern: '\\"</script>'
match: not_contains
target: {source: file, path: testing/assessment-report.html}
---
The question quoting `"</script>"` is not left as it is inside the JSON, where it would end the data block.
