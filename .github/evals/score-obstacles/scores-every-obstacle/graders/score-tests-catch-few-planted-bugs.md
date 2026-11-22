---
type: regex
pattern: 'id: "?tests-catch-few-planted-bugs"?\s+score: 2(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`tests-catch-few-planted-bugs` scores 2 by the guide's table.
