---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?no-real-assertion["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+(?:[^-\s]|- ["''])[^\n]*OrderServiceTest\.java:2[89]\b'
flags: m
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
OrderServiceTest.rejectsAnOrderWithNoItems has `@Test(expected = ...)`, which the rule counts as a real assertion, so the no-real-assertion finding does not cite it.
