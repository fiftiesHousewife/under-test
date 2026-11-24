---
type: regex
pattern: 'DiscountRulesContextTest'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
DiscountRulesContextTest is neither meaningless nor unreliable (its Spring XML holds only namespaces), so the list of tests leaves it out.
