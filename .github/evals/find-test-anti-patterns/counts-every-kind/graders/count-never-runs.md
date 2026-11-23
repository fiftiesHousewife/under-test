---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?never-runs["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 5[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `never-runs` is there once, and counts 5: in LegacyDiscountTest, appliesLoyaltyDiscount (`@Ignore` with no `@Test`), appliesStaffDiscount (its `@Test` commented out) and testAppliesSeasonalDiscount (a JUnit 3 name in a JUnit 4 class, no annotation); and both tests of CheckoutJourneyTest, in src/functionalTest, which the build doesn't name as a test source set.
