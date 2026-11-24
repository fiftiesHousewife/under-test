---
type: regex
pattern: 'id: ["'']?smtp-example-com["'']?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The `running_offline` section of the assessment file has one finding for smtp.example.com, the mail server, its id the node's `unique-id`.
