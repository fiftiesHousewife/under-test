---
type: regex
pattern: '["'']src/test/(?:resources/features/refunds\.feature:(?!(?:3|9|14|2[1-3])["''])|java/com/example/orders/(?:PaymentClientTest\.java:(?!11["''])|CheckoutFlowTest\.java:(?!(?:14|20|25)["''])|OrderServiceTest\.java:(?!(?:13|19|24|29|35)["''])|OrderRepositoryIT\.java:(?!(?:13|20)["''])|RefundTest\.java:(?!(?:13|18|23)["''])|InvoiceTest\.java:(?!(?:9|23|37)["''])|ReminderJobTest\.java:(?!(?:11|18|25)["''])|PricingServiceTest\.java:(?!(?:23|30)["''])|ShippingClientTest\.java:(?!18["''])|DiscountRulesContextTest\.java:(?!18["''])))[0-9]'
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
Every example, in any finding, is the line of a test method's declaration (not its annotation, its class, or the line showing the problem). The declaration lines are: PaymentClientTest 11; CheckoutFlowTest 14, 20, 25; OrderServiceTest 13, 19, 24, 29, 35; OrderRepositoryIT 13, 20; RefundTest 13, 18, 23; InvoiceTest 9, 23, 37; ReminderJobTest 11, 18, 25; PricingServiceTest 23, 30; ShippingClientTest 18; DiscountRulesContextTest 18. A Cucumber scenario's line is its `Scenario:` line (refunds.feature 3, 9, 14), or for one row of a Scenario Outline's examples, that row's line (21, 22, 23) or the outline's line, 14.
