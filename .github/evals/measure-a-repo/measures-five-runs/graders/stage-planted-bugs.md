---
type: regex
pattern: '\bstage: ["]?planted-bugs["]?\s*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
Measurement went through all four stages: build, one run, repeats, planted bugs.
