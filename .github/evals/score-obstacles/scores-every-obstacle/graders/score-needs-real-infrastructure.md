---
type: regex
pattern: 'id: "?needs-real-infrastructure"?\s+score: 0(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`needs-real-infrastructure` scores 0 by the guide's table.
