---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?copy-pasted["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 6[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `copy-pasted` (the kind itself, as the skill's rule gives) is there once, and counts 6 tests: InvoiceTest.invoicesAUkCustomer and invoicesAnIrishCustomer, whose ten-line bodies differ only in literals, and both tests of TaxTableTest in each of src/test and src/integrationTest, where the class is copied whole.
