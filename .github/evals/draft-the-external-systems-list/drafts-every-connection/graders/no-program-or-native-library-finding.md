---
type: regex
pattern: '^\s*-?\s*kind:\s*["'']?(process|native-library)'
flags: m
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
The `running_offline` findings are one per system reached: the program started and the native library loaded are not among them.
