---
type: regex
pattern: 'left_out:[^:]*MailerTest'
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The failing test is left out of the planted-bug run, and recorded.
