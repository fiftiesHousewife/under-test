---
type: regex
pattern: '^(?=[\s\S]*^schema:)(?=[\s\S]*^repo:)(?=[\s\S]*^level:)(?=[\s\S]*^safety:)(?=[\s\S]*^running_offline:)(?=[\s\S]*^tests:)(?=[\s\S]*^anti_patterns:)(?=[\s\S]*^decisions:)(?=[\s\S]*^notes:)'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
Every section that was there before is still there: `schema`, `repo`, `level`, `safety`, `running_offline`, `tests`, `anti_patterns`, `decisions`, `notes`.
