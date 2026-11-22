---
type: regex
pattern: '\bline_coverage: 64\.7(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
11 of 17 lines, from JaCoCo's report-level counter.
