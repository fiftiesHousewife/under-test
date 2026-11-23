---
type: regex
pattern: 'ShippingClientTest\.java:18["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?host:[ \t]*["'']?shipping-uat\.internal["'']?(?:(?!\n[ \t]*- test:)[\s\S])*?through:[ \t]*["'']?spring-xml'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has ShippingClientTest.java:18 reaching shipping-uat.internal through Spring XML: the host is in shipping.properties, which only its Spring XML context loads.
