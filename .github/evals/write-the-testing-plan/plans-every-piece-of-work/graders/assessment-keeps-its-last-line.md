---
type: regex
pattern: '^notes: ''''$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file still ends with its notes line.
