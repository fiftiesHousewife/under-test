---
type: regex
pattern: 'tests\.flaky 7 of 212'
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The flaky-tests evidence gives the count and the total.
