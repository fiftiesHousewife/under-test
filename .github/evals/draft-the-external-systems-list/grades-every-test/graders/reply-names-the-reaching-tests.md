---
type: regex
pattern: '(fetchesAPrice|PriceClientTest)[\s\S]*(paysThePartner|PaymentsSmokeTest)|(paysThePartner|PaymentsSmokeTest)[\s\S]*(fetchesAPrice|PriceClientTest)'
match: contains
target: last_message
---
The reply names both tests that reach a real system.
