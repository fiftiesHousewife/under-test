---
type: regex
pattern: '^[ \t]*["'']?techniques/junit-tags["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/junit-tags` proposes adopt. All three `needed_when` conditions are true: 6 tests reach an external system, broad tests are 29 per cent of the mix, and the orders database's decided stand-in runs in a container. It has no `possible_when`.
