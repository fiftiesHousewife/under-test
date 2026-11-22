---
type: regex
pattern: '\blocal: 100(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
Every test runs in the test task.
