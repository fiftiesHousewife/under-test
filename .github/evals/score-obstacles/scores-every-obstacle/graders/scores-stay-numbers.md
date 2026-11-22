---
type: regex
pattern: 'score: "'
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
Scores are bare numbers, as the schema requires.
