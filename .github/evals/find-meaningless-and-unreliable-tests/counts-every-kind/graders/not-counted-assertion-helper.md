---
type: regex
pattern: 'OrderTotalsTest\.addsUpAPlacedOrder|OrderTotalsTest\.java:9["'']'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
OrderTotalsTest.addsUpAPlacedOrder asserts through the shared helper OrderChecks.checkTotals, so it has a real assertion and the list of tests leaves it out.
