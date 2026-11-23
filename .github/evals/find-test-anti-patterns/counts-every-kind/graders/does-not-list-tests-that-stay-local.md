---
type: regex
pattern: 'OrderMailTest|OrderControllerTest|OrderStoreJpaTest'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
OrderMailTest (database in memory, mail on localhost), OrderControllerTest (@WebMvcTest), OrderStoreJpaTest (embedded database) reach no external system and show no anti-pattern, so the list leaves them out.
