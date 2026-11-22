---
type: regex
pattern: '- id: '
match: count:18
target: {source: file, path: testing/assessment.yaml}
---
Exactly 18 findings: one per rule per file, nothing invented and nothing missed.
