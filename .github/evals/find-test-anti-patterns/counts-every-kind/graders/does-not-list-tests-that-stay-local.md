---
type: regex
pattern: 'OrderMailTest|OrderControllerTest|OrderStoreJpaTest|QuoteServiceTest'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
OrderMailTest (database in memory, mail on localhost), OrderControllerTest (@WebMvcTest), OrderStoreJpaTest (embedded database) and QuoteServiceTest (its active test profile points at localhost) reach no external system and show no anti-pattern, so the list leaves them out.
