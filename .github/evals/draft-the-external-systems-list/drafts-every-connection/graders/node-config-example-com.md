---
type: regex
pattern: '"unique-id"\s*:\s*"config-example-com"'
match: count:1
target: {source: file, path: testing/external-systems.calm.json}
---
The node for config.example.com, the configuration server is there once, with the id the skill's rule gives (the host with every character but letters and digits turned into `-`). The closing quote keeps its interface ids (`config-example-com-<port>`) from counting.
