---
type: regex
pattern: '^[ \t]*["'']?techniques/fake-behind-an-interface["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/fake-behind-an-interface` proposes adopt. Developers' machines can't run containers (stated in the request), so `needed_when` 'A connection's stand-in needs a container or a real system, and the machines local tests run on can't provide one' is true for the Oracle database, whose stand-in is decided as run-in-container; it has no `possible_when` and no `reject_or_defer_when`.
