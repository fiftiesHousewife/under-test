---
type: regex
pattern: '^[ \t]*["'']?techniques/business-rule-tests["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/business-rule-tests` proposes adopt. `needed_when` 'A high- or medium-criticality application whose key user journeys are named in the source list or by the Application Owner' is true (criticality high, and the source list names the journeys), and `reject_or_defer_when` 'No subject-matter expert (SME) is available and there is no specification' is false: the source list has a knowledge curator and a current refund policy. Its evidence level 3 is within the target.
