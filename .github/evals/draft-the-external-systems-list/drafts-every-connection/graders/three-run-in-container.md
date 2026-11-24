---
type: regex
pattern: '"approach"\s*:\s*"run-in-container"'
match: count:3
target: {source: file, path: testing/external-systems.calm.json}
---
The database, the directory and the mail server each get `run-in-container`, the first stand-in in the order of preference that fits them.
