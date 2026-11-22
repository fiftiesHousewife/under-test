---
type: regex
pattern: '"unique-id"\s*:\s*"orders-service-to-db-orders-prod-example-com"'
match: count:1
target: {source: file, path: testing/connections.calm.json}
---
The relationship to db-orders.prod.example.com, the orders database is there once, with the id the skill's rule gives (`<application node>-to-<node>`, the application's node named after the repo, `orders-service`).
