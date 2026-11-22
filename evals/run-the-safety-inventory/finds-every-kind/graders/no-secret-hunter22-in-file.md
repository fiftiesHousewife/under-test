---
type: regex
pattern: 'hunter22'
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
The matched secret value never appears.
