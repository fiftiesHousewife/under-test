---
type: regex
pattern: '^[ \t]*["'']?techniques/stand-in-commands["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/stand-in-commands` proposes adopt. The external systems list records that the application starts sendmail, which can reach real customers, so its `needed_when` is true; it has no `possible_when`, its `reject_or_defer_when` isn't mentioned, and its checks are part of the work.
