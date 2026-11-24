---
type: regex
pattern: 'MailerTest\.[A-Za-z]+"?\s*\n(?:(?!\n[ \t]*- test:)[\s\S])*?missed_by_discovery: true'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The mail test called a host no external system of its names: discovery missed it.
