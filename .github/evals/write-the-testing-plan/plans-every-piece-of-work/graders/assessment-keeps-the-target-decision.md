---
type: regex
pattern: '^  level/target:\n    state: decided\n    by: Test Quality Lead\n    choice: ''4''\n    reason: High business criticality\.$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file keeps the target level decision, unchanged.
