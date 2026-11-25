---
type: regex
pattern: '\bgrade:\s*"?reaches\b'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
No test is graded reaches: the field trial ran every test under the airgap agent and none reached another machine.
