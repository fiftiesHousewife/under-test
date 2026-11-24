---
type: regex
pattern: '"unique-id"\s*:\s*"orders-service-to-payments-example-com"'
match: count:1
target: {source: file, path: testing/external-systems.calm.json}
---
The relationship to payments.example.com, the payments service is there once, with the id the skill's rule gives (`<application node>-to-<node>`, the application's node named after the repo, `orders-service`).
