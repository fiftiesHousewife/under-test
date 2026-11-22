---
type: regex
pattern: 'id: "?disabled-tests"?\s+score: 3(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`disabled-tests` scores 3 by the guide's table.
