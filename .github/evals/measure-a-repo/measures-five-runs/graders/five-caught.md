---
type: regex
pattern: '\bcaught: 5(\s*$|\s*,|\s*\})'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
With the flaky and failing tests left out, the tests catch 5: the same every run.
