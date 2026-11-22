---
type: regex
pattern: '^[ \t]*["'']?techniques/refactoring-for-testability["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/refactoring-for-testability` proposes defer. Its only `needed_when`, about many hard-wired dependencies, is unknown until they are counted, and a precondition check never settles a `needed_when`, so it is deferred with the count to make, never adopted or rejected.
