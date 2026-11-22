---
type: regex
pattern: '^[ \t]*["'']?techniques/traffic-record-and-replay["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/traffic-record-and-replay` proposes defer. Its two `outside_approval` checks (the Security and Platform Owner's approval of Keploy, and approval of capture) aren't given, and `possible_when` about what Keploy understands is false for Oracle over JDBC, which no planned work changes: a defer, not a reject, since no `needed_when` is known false and no `reject_or_defer_when` is true.
