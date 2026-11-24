---
type: regex
pattern: '"state"\s*:\s*"proposed"'
match: count:6
target: {source: file, path: testing/external-systems.calm.json}
---
Every one of the six connections is drafted as `proposed`, for the Architecture Owner to confirm.
