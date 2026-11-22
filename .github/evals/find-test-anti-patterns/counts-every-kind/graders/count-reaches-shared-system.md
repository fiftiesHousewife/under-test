---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?reaches-shared-system["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 2[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `reaches-shared-system` (the kind itself, as the skill's rule gives) is there once, and counts 2 tests: both tests in OrderRepositoryIT, which names orders-uat.internal. PaymentClientTest calls localhost, so it does not count.
