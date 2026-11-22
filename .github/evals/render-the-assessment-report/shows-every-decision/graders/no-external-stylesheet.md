---
type: regex
pattern: '<link[^>]*stylesheet|@import'
match: not_contains
target: {source: file, path: testing/assessment-report.html}
---
No stylesheet is loaded from anywhere: the template has none.
