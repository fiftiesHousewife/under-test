---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?copy-pasted["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 2[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `copy-pasted` (the kind itself, as the skill's rule gives) is there once, and counts 2 tests: InvoiceTest.invoicesAUkCustomer and invoicesAnIrishCustomer, whose ten-line bodies differ only in literal values.
