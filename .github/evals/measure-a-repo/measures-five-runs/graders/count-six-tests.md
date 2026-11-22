---
type: regex
pattern: '\bcount: 6(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
Six tests, the disabled one included.
