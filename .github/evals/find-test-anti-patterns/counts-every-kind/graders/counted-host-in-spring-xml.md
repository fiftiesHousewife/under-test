---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?reaches-shared-system["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+(?:[^-\s]|- ["''])[^\n]*ShippingClientTest\.java:18'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The reaches-shared-system finding cites ShippingClientTest.java:18. Its class names no host itself: the host is in shipping.properties, which only its Spring XML context loads.
