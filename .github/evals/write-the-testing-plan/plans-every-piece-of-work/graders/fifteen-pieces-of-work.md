---
type: regex
pattern: '^\| `orders-service:'
flags: m
match: count:15
target: {source: file, path: testing/TESTING-PLAN.md}
---
Exactly 15 pieces of work: nothing invented, nothing missed.
