---
type: regex
pattern: '"unique-id":\s*"prices-acme-internal"'
match: contains
target: {source: file, path: testing/connections.calm.json}
---
The price service is a node of the connection list, by its host.
