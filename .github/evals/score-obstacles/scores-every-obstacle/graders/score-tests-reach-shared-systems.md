---
type: regex
pattern: 'id: "?tests-reach-shared-systems"?\s+score: 2(\s|,|\})'
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
`tests-reach-shared-systems` scores 2 by the guide's table.
