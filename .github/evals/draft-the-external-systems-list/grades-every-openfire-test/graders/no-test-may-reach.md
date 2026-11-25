---
type: regex
pattern: '\bgrade:\s*"?may-reach\b'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
No test is graded may reach: every reach the facts give a system has no address for tests or goes through a mock.
