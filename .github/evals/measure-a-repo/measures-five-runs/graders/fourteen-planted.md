---
type: regex
pattern: '\bplanted: 14(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
Bugs planted in the code only, not in the test classes.
