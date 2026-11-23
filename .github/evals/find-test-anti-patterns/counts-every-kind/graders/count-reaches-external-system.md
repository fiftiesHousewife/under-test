---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?reaches-external-system["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 9[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `reaches-external-system` (the kind itself, as the skill's rule gives) is there once, and counts 9 tests: both tests in OrderRepositoryIT (orders-uat.internal, in its code); ShippingClientTest (shipping-uat.internal, in a properties file its Spring XML loads); OrderApiTest (a @SpringBootTest whose test profile overrides only the mail host, so the database orders-db.internal stays); OrderStoreRealDbTest (@DataJpaTest with replace NONE, so the real database); InvoiceApiTest (inherits @SpringBootTest from AbstractIntegrationTest); LegacyRepositoryTest (Spring's JUnit 3 base class, getConfigLocations naming legacy-context.xml with ordersdb01.corp); ReportClientTest (a placeholder's default, reports.corp); ArchiveJobTest (builds a context whose XML looks up jdbc/ArchiveDS through JNDI). Not counted: PaymentClientTest (localhost), DiscountRulesContextTest (namespaces only), OrderMailTest (database in memory, mail on localhost), OrderControllerTest (@WebMvcTest), OrderStoreJpaTest (embedded database), QuoteServiceTest (the test profile's localhost).
