---
type: regex
pattern: '^[ \t]*["'']?techniques/mutation-testing["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/mutation-testing` proposes defer. `reject_or_defer_when` 'Flaky suite' is true now (7 flaky tests in 5 runs), and it isn't about the framework, a vendor, a licence or who owns what: a defer, not a reject, that waits for fix-flaky-tests.
