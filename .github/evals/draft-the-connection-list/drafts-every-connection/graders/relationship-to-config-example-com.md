---
type: regex
pattern: '"unique-id"\s*:\s*"orders-service-to-config-example-com"'
match: count:1
target: {source: file, path: testing/connections.calm.json}
---
The relationship to config.example.com, the configuration server is there once, with the id the skill's rule gives (`<application node>-to-<node>`, the application's node named after the repo, `orders-service`).
