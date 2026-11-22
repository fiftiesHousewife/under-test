---
type: regex
pattern: '^[ \t]*["'']?techniques/mockito-well-used["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?reject["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/mockito-well-used` proposes reject. Its only `needed_when`, 'Tests mock everything, including the code's own classes and plain values (the mocks-everything anti-pattern)', is known false: the anti-pattern check ran and found no mocks-everything tests, and a check that would list them leaving them out makes the condition false, not unknown.
