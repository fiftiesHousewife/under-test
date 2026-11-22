---
type: regex
pattern: '"never-reach"'
match: count:1
target: {source: file, path: testing/connections.calm.json}
---
Only the production database is marked never-reach: no other host has `prod` or `prd` as a word, so the skill leaves them out and asks.
