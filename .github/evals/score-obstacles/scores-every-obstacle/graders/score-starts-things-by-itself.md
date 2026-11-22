---
type: regex
pattern: 'id: "?starts-things-by-itself"?\s+score: 2(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`starts-things-by-itself` scores 2 by the guide's table.
