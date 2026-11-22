---
type: regex
pattern: 'left_out:[^:]*ReminderMarkerTest'
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The flaky test is left out of the planted-bug run, and recorded.
