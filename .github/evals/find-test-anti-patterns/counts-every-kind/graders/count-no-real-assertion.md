---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?no-real-assertion["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 5[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `no-real-assertion` (the kind itself, as the skill's rule gives) is there once, and counts 5 tests: OrderTotalsTest.describesAPlacedOrder, whose only call is to a helper that doesn't assert, PriceRoundingTest.keepsThePrice, whose only assertion is a bare assertThat with nothing after it, StockLevelTest.reservesStock, whose body is empty, OrderServiceTest.createsOrder, whose only assertion is assertNotNull, and OrderServiceTest.logsOrder, which has none. The test expecting an exception and the PricingServiceTest tests that verify calls do not count. OrderTotalsTest.addsUpAPlacedOrder doesn't count: it asserts through the shared helper OrderChecks.checkTotals.
