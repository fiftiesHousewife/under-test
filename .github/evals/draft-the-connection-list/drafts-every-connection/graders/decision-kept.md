---
type: regex
pattern: '^\s*choice: ["'']?off in the test profile["'']?\s*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The earlier decision on that finding is still there.
