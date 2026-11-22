---
type: regex
pattern: '^  techniques/[a-z-]+:$'
flags: m
match: count:23
target: {source: file, path: testing/assessment.yaml}
---
The assessment file keeps all 23 technique decisions.
