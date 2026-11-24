---
type: regex
pattern: 'MailerTest\.[A-Za-z]+"?\s*\n(?:(?!\n[ \t]*- test:)[\s\S])*?outcome: ["]?failed-every-run'
match: contains
target: {source: file, path: testing/tests.yaml}
---
The mail test failed in its run and in every rerun alone.
