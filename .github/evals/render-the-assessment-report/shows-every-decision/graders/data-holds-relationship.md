---
type: regex
pattern: 'id="report-data">([^<]|<[^/])*?"unique-id"\s*:\s*"orders-service-to-payments-example-com"'
match: contains
target: {source: file, path: testing/assessment-report.html}
---
A relationship's unique-id from the connection list is inside the data block.
