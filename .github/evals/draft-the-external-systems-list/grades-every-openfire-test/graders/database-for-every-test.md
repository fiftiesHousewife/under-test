---
type: regex
pattern: '\bnode:\s*"?database-database-defaultprovider-serverurl\b'
match: count:228
target: {source: file, path: testing/tests.yaml}
---
Every one of those tests reaches the database whose address is the setting database.defaultProvider.serverURL.
