---
type: regex
pattern: '^[ \t]*["'']?techniques/ai-written-tests["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/ai-written-tests` proposes adopt. `needed_when` 'Code has few tests, or tests that don't check its results' is true: 14 tests have no real assertion. `possible_when` 'Runs in a JVM test without the network' is false now, but planned work: the payments connection has no decided stand-in, so make-it-run-on-its-own is planned. Its `reject_or_defer_when` conditions aren't mentioned, so they count as false.
