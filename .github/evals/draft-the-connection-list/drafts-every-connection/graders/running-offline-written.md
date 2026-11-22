---
type: regex
pattern: '^running_offline:'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file has a top-level `running_offline` section.
