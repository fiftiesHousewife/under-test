---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?order-dependent["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 3[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `order-dependent` (the kind itself, as the skill's rule gives) is there once, and counts 3 tests: every test in CheckoutFlowTest, which has @FixMethodOrder.
