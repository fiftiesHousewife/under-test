---
type: regex
pattern: '^[ \t]*["'']?techniques/tests-from-cases["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/tests-from-cases` proposes adopt. `needed_when` 'The source list names manual test scripts or tables of examples to turn into tests' is true: the orders release pack is manual test scripts, mined for examples. The anti-pattern check found no copy-pasted tests, so that need is false, but one true need is enough.
