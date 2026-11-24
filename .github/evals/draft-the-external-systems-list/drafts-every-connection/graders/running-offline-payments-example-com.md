---
type: regex
pattern: 'id: ["'']?payments-example-com["'']?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The `running_offline` section of the assessment file has one finding for payments.example.com, the payments service, its id the node's `unique-id`.
