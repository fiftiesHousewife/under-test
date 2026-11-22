---
type: regex
pattern: '\bdisabled: 1(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
One test is ignored.
