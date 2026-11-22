---
type: regex
pattern: '\b23\b[^\n]{0,15}(of|/|out of) ?100\b|\b23 ?%'
match: contains
target: last_message
---
The reply gives the reason: the tests caught 23 of 100 planted bugs.
