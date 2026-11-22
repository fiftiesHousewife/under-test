---
type: regex
pattern: '\bflaky: 1(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The marker test passes and fails on alternate runs.
