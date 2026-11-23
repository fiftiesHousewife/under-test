---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?reaches-external-system["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 3[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `reaches-external-system` (the kind itself, as the skill's rule gives) is there once, and counts 3 tests: both tests in OrderRepositoryIT, which names orders-uat.internal, and ShippingClientTest, whose Spring XML context loads shipping.properties, which names shipping-uat.internal. PaymentClientTest calls localhost, and DiscountRulesContextTest's XML holds only namespace URLs, so neither counts.
