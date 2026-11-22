---
type: regex
pattern: 'id: "?tests-check-nothing"?\s+score: 2(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`tests-check-nothing` scores 2 by the guide's table.
