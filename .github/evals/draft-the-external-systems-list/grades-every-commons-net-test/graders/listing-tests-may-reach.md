---
type: regex
pattern: 'test: "?org\.apache\.commons\.net\.ftp\.ListingFunctionalTest\.\w+"?\s*\n(?:(?!- test:)[\s\S])*?grade: "?may-reach\b'
match: count:14
target: {source: file, path: testing/tests.yaml}
---
Each of ListingFunctionalTest's 14 tests may reach: its servers come from suite() at run time, and every one tried to reach them in the field trial.
