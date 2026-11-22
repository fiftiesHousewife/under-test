---
type: regex
pattern: 'id: "?little-code-run-by-tests"?\s+score: 1(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`little-code-run-by-tests` scores 1 by the guide's table.
