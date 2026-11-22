---
type: regex
pattern: '\bbranch_coverage: 62\.5(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
5 of 8 branches.
