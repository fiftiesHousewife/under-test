---
type: regex
pattern: '^[ \t]*["'']?techniques/repeatable-tests["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/repeatable-tests` proposes adopt. `needed_when` 'Tests pass in some runs and fail in others (tests.flaky above 0)' is true: 7 flaky tests in 5 runs. It has no `possible_when` and no `reject_or_defer_when`, and its five-run check is part of the work.
