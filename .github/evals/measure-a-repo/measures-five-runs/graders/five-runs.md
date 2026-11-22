---
type: regex
pattern: '\bruns: 5(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The tests ran five times.
