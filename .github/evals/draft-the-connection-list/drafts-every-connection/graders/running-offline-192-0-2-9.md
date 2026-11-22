---
type: regex
pattern: 'id: ["'']?192-0-2-9["'']?\s*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The `running_offline` section of the assessment file has one finding for 192.0.2.9, the metrics collector reached over UDP, its id the node's `unique-id`.
