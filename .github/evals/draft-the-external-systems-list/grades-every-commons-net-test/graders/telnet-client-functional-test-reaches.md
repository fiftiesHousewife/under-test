---
type: regex
pattern: 'test: "?org\.apache\.commons\.net\.telnet\.TelnetClientFunctionalTest\.testFunctionalTest"?\s*\n(?:(?!- test:)[\s\S])*?grade: "?reaches\b'
match: contains
target: {source: file, path: testing/tests.yaml}
---
TelnetClientFunctionalTest has its server's address in the code and tried to reach it in the field trial, so it is graded reaches.
