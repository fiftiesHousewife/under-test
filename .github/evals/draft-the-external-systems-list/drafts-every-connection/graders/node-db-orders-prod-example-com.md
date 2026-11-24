---
type: regex
pattern: '"unique-id"\s*:\s*"db-orders-prod-example-com"'
match: count:1
target: {source: file, path: testing/external-systems.calm.json}
---
The node for db-orders.prod.example.com, the orders database is there once, with the id the skill's rule gives (the host with every character but letters and digits turned into `-`). The closing quote keeps its interface ids (`db-orders-prod-example-com-<port>`) from counting.
