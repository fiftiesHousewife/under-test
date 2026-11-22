---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?disabled["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 4[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `disabled` (the kind itself, as the skill's rule gives) is there once, and counts 4 tests: OrderServiceTest.cancelsOrder, ignored on its own, and the three tests of RefundTest, which is ignored as a class.
