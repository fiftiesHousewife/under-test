---
type: regex
pattern: '["'']src/test/java/com/example/orders/[A-Za-z]+\.java:[0-9]+["'']'
match: contains
target: {source: file, path: testing/assessment.yaml}
---
Examples are given as quoted `"path:line"`, the path from the repo root.
