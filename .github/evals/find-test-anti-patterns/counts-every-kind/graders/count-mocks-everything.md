---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?mocks-everything["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 2[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `mocks-everything` (the kind itself, as the skill's rule gives) is there once, and counts 2 tests: both tests in PricingServiceTest, which has six @Mock fields.
