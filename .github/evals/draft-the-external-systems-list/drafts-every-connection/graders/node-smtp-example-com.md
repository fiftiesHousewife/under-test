---
type: regex
pattern: '"unique-id"\s*:\s*"smtp-example-com"'
match: count:1
target: {source: file, path: testing/external-systems.calm.json}
---
The node for smtp.example.com, the mail server is there once, with the id the skill's rule gives (the host with every character but letters and digits turned into `-`). The closing quote keeps its interface ids (`smtp-example-com-<port>`) from counting.
