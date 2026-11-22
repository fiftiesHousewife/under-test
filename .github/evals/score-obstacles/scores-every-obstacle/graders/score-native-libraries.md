---
type: regex
pattern: 'id: "?native-libraries"?\s+score: 0(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`native-libraries` scores 0 by the guide's table.
