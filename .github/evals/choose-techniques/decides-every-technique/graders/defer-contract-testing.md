---
type: regex
pattern: '^[ \t]*["'']?techniques/contract-testing["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/contract-testing` proposes defer. Payments is another team's service, not a vendor's, so its `needed_when` is true and `reject_or_defer_when` 'The provider is an external vendor's API' is false, but its `outside_approval` check 'Provider team agreement' has not been given: a defer, never a reject.
