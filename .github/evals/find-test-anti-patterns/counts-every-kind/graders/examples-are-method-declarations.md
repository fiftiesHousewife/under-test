---
type: regex
pattern: '["'']src/test/java/com/example/orders/(?:PaymentClientTest\.java:(?!11["''])|CheckoutFlowTest\.java:(?!(?:14|20|25)["''])|OrderServiceTest\.java:(?!(?:13|19|24|29|35)["''])|OrderRepositoryIT\.java:(?!(?:13|20)["''])|RefundTest\.java:(?!(?:13|18|23)["''])|InvoiceTest\.java:(?!(?:9|23|37)["''])|ReminderJobTest\.java:(?!(?:11|18|25)["''])|PricingServiceTest\.java:(?!(?:23|30)["'']))[0-9]'
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
Every example, in any finding, is the line of a test method's declaration (not its annotation, its class, or the line showing the problem). The declaration lines are: PaymentClientTest 11; CheckoutFlowTest 14, 20, 25; OrderServiceTest 13, 19, 24, 29, 35; OrderRepositoryIT 13, 20; RefundTest 13, 18, 23; InvoiceTest 9, 23, 37; ReminderJobTest 11, 18, 25; PricingServiceTest 23, 30.
