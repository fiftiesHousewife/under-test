---
type: regex
pattern: '"unique-id"\s*:\s*"[^"]*sendmail'
match: not_contains
target: {source: file, path: testing/connections.calm.json}
---
`sendmail` is a program the code starts, not a system it reaches: no node, interface or relationship is named after it.
