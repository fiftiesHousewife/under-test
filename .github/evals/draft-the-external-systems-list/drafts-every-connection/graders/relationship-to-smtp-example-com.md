---
type: regex
pattern: '"unique-id"\s*:\s*"orders-service-to-smtp-example-com"'
match: count:1
target: {source: file, path: testing/external-systems.calm.json}
---
The relationship to smtp.example.com, the mail server is there once, with the id the skill's rule gives (`<application node>-to-<node>`, the application's node named after the repo, `orders-service`).
