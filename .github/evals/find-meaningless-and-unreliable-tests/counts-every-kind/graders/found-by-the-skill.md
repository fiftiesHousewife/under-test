---
type: regex
pattern: '^[ \t]*found_by:[\s\S]{0,80}tool: ["'']?find-meaningless-and-unreliable-tests["'']?'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The section names the skill as the tool that wrote it, so a re-run can be compared with the last.
