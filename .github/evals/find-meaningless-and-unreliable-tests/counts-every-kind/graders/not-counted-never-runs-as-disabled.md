---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?disabled["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+(?:[^-\s]|- ["''])[^\n]*LegacyDiscountTest'
flags: m
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
LegacyDiscountTest.appliesLoyaltyDiscount has `@Ignore` but no `@Test`: it never runs, so it counts under never-runs, not disabled.
