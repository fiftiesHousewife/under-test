---
type: regex
pattern: '"unique-id"\s*:\s*"[^"]*localhost'
match: not_contains
target: {source: file, path: testing/external-systems.calm.json}
---
The call to `localhost:8089` was allowed as the machine itself, so it is not a connection.
