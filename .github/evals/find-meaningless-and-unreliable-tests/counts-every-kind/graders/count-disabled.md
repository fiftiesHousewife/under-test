---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?disabled["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 5[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `disabled` (the kind itself, as the skill's rule gives) is there once, and counts 5 tests: OrderServiceTest.cancelsOrder, ignored on its own, the three tests of RefundTest, which is ignored as a class, and the Cucumber scenario tagged `@ignore` in features/refunds.feature.
