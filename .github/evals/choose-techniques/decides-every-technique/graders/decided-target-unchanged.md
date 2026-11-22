---
type: regex
pattern: '^[ \t]*["'']?level/target["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+state:[ \t]*["'']?decided["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The target level people decided is still `state: decided`; the skill never changes a decision people have made.
