---
type: regex
pattern: 'id: "?talks-to-unplanned-systems"?\s+score: 1(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`talks-to-unplanned-systems` scores 1 by the guide's table.
