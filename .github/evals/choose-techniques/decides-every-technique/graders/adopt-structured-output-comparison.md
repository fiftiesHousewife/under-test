---
type: regex
pattern: '^[ \t]*["'']?techniques/structured-output-comparison["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/structured-output-comparison` proposes adopt. `needed_when` 'Structured output such as JSON, files or reports' is true for a web service's JSON responses, and web-service is one of its application types. `possible_when` 'Output is deterministic or can be normalised' is settled by its own check 'Run twice and diff the outputs', so it counts as planned work and doesn't defer.
