---
type: regex
pattern: 'id: "?can-reach-production"?\s+score: 0(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`can-reach-production` scores 0 by the guide's table.
