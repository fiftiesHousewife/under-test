---
type: regex
pattern: '"tests":\s*[1-9]'
match: not_contains
target: {source: file, path: testing/external-systems.calm.json}
---
No relationship counts a test, since none reaches or may reach its system.
