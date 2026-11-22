---
type: regex
pattern: '^[ \t]*["'']?techniques/post-release-checks["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/post-release-checks` proposes defer. Its only evidence level is 5, above the decided target of 4 (`level/target`), so it is deferred, not adopted for the high criticality.
