---
type: regex
pattern: '"unique-id":\s*"prices-acme-internal"'
match: contains
target: {source: file, path: testing/external-systems.calm.json}
---
The price service is a node of the external systems list, by its host.
