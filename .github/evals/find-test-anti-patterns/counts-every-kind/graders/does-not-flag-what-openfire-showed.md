---
type: regex
pattern: 'OrderLookupTest'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
OrderLookupTest holds three patterns a real repo (Openfire) showed PMD's own rules misreading: findsNoOrderForAStranger's only assertion is assertNull, which is the check; looksUpBothWays asserts through testLookupByCustomer and testLookupByNumber, helpers in its class that it calls, so they run; cancelsWithoutError catches Throwable to record it and asserts on it, which swallows nothing. None shows an anti-pattern.
