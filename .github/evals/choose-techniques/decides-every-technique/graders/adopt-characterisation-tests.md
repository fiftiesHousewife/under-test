---
type: regex
pattern: '^[ \t]*["'']?techniques/characterisation-tests["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/characterisation-tests` proposes adopt. `needed_when` 'Many tests run the code without checking results, or few planted bugs are caught' is true: 14 tests with no real assertion, and 23 of 100 planted bugs caught. That it waits for the code to run on its own is ordering, not a reason to defer, and choosing a test point is part of the work.
