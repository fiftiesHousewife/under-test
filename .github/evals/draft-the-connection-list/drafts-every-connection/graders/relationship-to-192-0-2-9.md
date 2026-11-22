---
type: regex
pattern: '"unique-id"\s*:\s*"orders-service-to-192-0-2-9"'
match: count:1
target: {source: file, path: testing/connections.calm.json}
---
The relationship to 192.0.2.9, the metrics collector reached over UDP is there once, with the id the skill's rule gives (`<application node>-to-<node>`, the application's node named after the repo, `orders-service`).
