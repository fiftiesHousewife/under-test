---
type: regex
pattern: 'penny\.</p>'
match: not_contains
target: {source: file, path: testing/assessment-report.html}
---
The `</p>` in the notes is not left unescaped inside the data.
