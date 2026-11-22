---
type: regex
pattern: '^[ \t]*["'']?techniques/property-based-testing["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/property-based-testing` proposes adopt. `needed_when` 'The code has calculations, parsers or serialisation round-trips' is true: the refund-rounding question describes how partial refunds are calculated. `possible_when` 'A domain expert can state an invariant (a rule that holds for every input)' is unknown, but its own check 'SME names an invariant' would settle it, so it counts as planned work; its evidence level 3 is within the target.
