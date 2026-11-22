---
type: regex
pattern: '^[ \t]*["'']?techniques/machine-state-checks["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/machine-state-checks` proposes defer. No file the run was given would list install, deploy or configuration scripts, so whether there are any is unknown, not false; no other `needed_when` is known true, and the skill never rejects on an unknown.
