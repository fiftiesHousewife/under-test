---
type: regex
pattern: 'Template note'
match: not_contains
target: {source: file, path: testing/TESTING-PLAN.md}
---
The template's own note is left out of the plan.
