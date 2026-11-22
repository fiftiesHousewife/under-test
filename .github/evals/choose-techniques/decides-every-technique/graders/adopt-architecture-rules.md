---
type: regex
pattern: '^[ \t]*["'']?techniques/architecture-rules["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/architecture-rules` proposes adopt. `needed_when` 'Code has been or will be put behind interfaces, or its layers are to be kept apart' is true, because fake-behind-an-interface is adopted in the same run, and that adopt makes `possible_when` 'The layers or interfaces the rules would protect exist' planned work. 'Tiny repos' isn't mentioned, so it counts as false.
