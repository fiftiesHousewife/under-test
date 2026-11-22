---
type: regex
pattern: 'id: "?may-hold-real-personal-data"?\s+score: 3(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`may-hold-real-personal-data` scores 3 by the guide's table.
