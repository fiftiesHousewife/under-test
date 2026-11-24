---
type: regex
pattern: 'ReminderMarkerTest\.[A-Za-z]+"?\s*\n(?:(?!\n[ \t]*- test:)[\s\S])*?outcome: ["]?(?:flaky|order-dependent)'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The reminder marker test passed and failed with nothing changed.
