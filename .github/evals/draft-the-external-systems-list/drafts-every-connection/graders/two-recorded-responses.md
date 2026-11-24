---
type: regex
pattern: '"approach"\s*:\s*"recorded-responses"'
match: count:2
target: {source: file, path: testing/external-systems.calm.json}
---
The two HTTP services, payments and configuration, each get `recorded-responses`.
