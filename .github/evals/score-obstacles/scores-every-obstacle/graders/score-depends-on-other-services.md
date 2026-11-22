---
type: regex
pattern: 'id: "?depends-on-other-services"?\s+score: 1(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`depends-on-other-services` scores 1 by the guide's table.
