---
type: regex
pattern: '^[ \t]*["'']?techniques/batch-file-in-file-out["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/batch-file-in-file-out` proposes defer. The nightly reminder job and the invoice export may or may not be batch jobs that read and write files or tables: that depends on code the run wasn't given, so its only `needed_when` is unknown, and the skill never rejects on an unknown.
