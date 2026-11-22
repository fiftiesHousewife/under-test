---
type: regex
pattern: 'id: "?holds-production-secrets"?\s+score: 1(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`holds-production-secrets` scores 1 by the guide's table.
