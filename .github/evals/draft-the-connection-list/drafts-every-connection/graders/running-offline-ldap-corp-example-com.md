---
type: regex
pattern: 'id: ["'']?ldap-corp-example-com["'']?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The `running_offline` section of the assessment file has one finding for ldap.corp.example.com, the directory reached through JNDI, its id the node's `unique-id`.
