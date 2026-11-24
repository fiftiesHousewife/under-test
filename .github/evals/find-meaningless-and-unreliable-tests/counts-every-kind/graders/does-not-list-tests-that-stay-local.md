---
type: regex
pattern: 'OrderControllerTest|OrderStoreJpaTest'
match: not_contains
target: {source: file, path: testing/tests.yaml}
---
OrderControllerTest (@WebMvcTest, asserting with MockMvc's andExpect) and OrderStoreJpaTest (embedded database) reach no external system and show no anti-pattern, so the list leaves them out.
