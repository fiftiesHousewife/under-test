---
type: regex
pattern: '^[ \t]*["'']?techniques/testcontainers["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/testcontainers` proposes adopt. `needed_when` 'Infrastructure you own (database, broker, cache)' is true: the orders database, whose connection's stand-in is decided as run-in-container. `possible_when` 'A container runtime is available to tests (CI today; developer machines if WSL2 is enabled)' holds, since CI can run containers (stated in the request).
