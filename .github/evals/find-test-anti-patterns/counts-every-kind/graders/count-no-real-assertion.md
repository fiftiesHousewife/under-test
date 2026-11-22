---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?no-real-assertion["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 2[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `no-real-assertion` (the kind itself, as the skill's rule gives) is there once, and counts 2 tests: OrderServiceTest.createsOrder, whose only assertion is assertNotNull, and OrderServiceTest.logsOrder, which has none. The test expecting an exception and the PricingServiceTest tests that verify calls do not count.
