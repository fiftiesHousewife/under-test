---
type: regex
pattern: '^\| [^|`]+ \| (defer|reject) \((proposed|decided)\) \|'
flags: m
match: count:14
target: {source: file, path: testing/TESTING-PLAN.md}
---
Ten deferred and four rejected techniques, each with its state.
