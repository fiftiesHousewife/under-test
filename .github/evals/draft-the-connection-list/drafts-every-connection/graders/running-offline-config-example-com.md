---
type: regex
pattern: 'id: ["'']?config-example-com["'']?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The `running_offline` section of the assessment file has one finding for config.example.com, the configuration server, its id the node's `unique-id`.
