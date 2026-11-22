---
type: regex
pattern: 'Sup3rSecret'
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
The matched secret value never appears.
