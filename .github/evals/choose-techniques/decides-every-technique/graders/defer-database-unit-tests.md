---
type: regex
pattern: '^[ \t]*["'']?techniques/database-unit-tests["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/database-unit-tests` proposes defer. Its `outside_approval` check 'The database licence allows running the engine in a test container' isn't given (the decided container stand-in is not that approval), and that sub-rule comes before the one for an unknown `needed_when`, so the reason uses the `needs` form; whether 'Business rules live in stored procedures, functions or triggers' is true is also unknown, and the skill never rejects on an unknown.
