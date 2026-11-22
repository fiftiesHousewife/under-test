---
type: regex
pattern: '^[ \t]*["'']?techniques/feature-flags["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/feature-flags` proposes defer. Its only evidence level is 5, above the decided target of 4 (`level/target`), and the skill defers a technique whose every evidence level is above the target.
