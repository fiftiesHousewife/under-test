---
type: regex
pattern: '"never-reach"\s*:\s*\[[^\]]*"db-orders\.prod\.example\.com'
match: contains
target: {source: file, path: testing/connections.calm.json}
---
The production database's address is marked as never to be reached: its host has `prod` as a word, and there is no organisation profile. The address may carry its port.
