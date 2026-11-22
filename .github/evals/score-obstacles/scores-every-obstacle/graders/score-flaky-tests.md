---
type: regex
pattern: 'id: "?flaky-tests"?\s+score: 2(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`flaky-tests` scores 2 by the guide's table.
