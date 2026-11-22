---
type: regex
pattern: '^  count: 212\n  runs: 5\n  flaky: 7\n  disabled: 11$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file keeps its test counts, unchanged.
