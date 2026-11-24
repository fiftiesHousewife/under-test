---
type: regex
pattern: '"unique-id"\s*:\s*"ldap-corp-example-com"'
match: count:1
target: {source: file, path: testing/external-systems.calm.json}
---
The node for ldap.corp.example.com, the directory reached through JNDI is there once, with the id the skill's rule gives (the host with every character but letters and digits turned into `-`). The closing quote keeps its interface ids (`ldap-corp-example-com-<port>`) from counting.
