---
type: regex
pattern: '^# yaml-language-server: \$schema=\.\./schema/assessment\.schema\.json'
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The assessment file still starts with the line pointing at its schema.
