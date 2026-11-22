---
type: regex
pattern: 'tool:\s*["'']?draft-the-connection-list'
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The `running_offline` section names the skill as the tool that found its contents.
