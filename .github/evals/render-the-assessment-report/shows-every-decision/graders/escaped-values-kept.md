---
type: regex
pattern: 'penny\.(<\\/|\\u003[cC]/)p>'
match: contains
target: {source: file, path: testing/assessment-report.html}
---
The notes are kept, with their `</` escaped (`<\/`, or the JSON escape `\u003c/`), not dropped.
