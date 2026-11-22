---
type: regex
pattern: '"unique-id"\s*:\s*"[^"]*crypto'
match: not_contains
target: {source: file, path: testing/connections.calm.json}
---
The native library `crypto` belongs to the safety inventory: no node, interface or relationship is named after it.
