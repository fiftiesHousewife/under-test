---
type: regex
pattern: '"unique-id"\s*:\s*"payments-example-com"'
match: count:1
target: {source: file, path: testing/connections.calm.json}
---
The node for payments.example.com, the payments service is there once, with the id the skill's rule gives (the host with every character but letters and digits turned into `-`). The closing quote keeps its interface ids (`payments-example-com-<port>`) from counting.
