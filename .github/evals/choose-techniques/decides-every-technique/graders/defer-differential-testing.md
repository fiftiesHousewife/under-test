---
type: regex
pattern: '^[ \t]*["'']?techniques/differential-testing["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/differential-testing` proposes defer. Its `outside_approval` check 'Modernisation in scope' is a scope agreement from outside the team, and it isn't given; the skill never rejects on an unknown.
