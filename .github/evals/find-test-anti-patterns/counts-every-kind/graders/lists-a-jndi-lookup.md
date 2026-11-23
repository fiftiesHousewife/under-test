---
type: regex
pattern: 'ArchiveJobTest\.java:19["'']{1}(?:(?!\n[ \t]*- test:)[\s\S])*?jdbc/ArchiveDS(?:(?!\n[ \t]*- test:)[\s\S])*?kind:[ \t]*["'']?database'
match: count:1
target: {source: file, path: testing/tests.yaml}
---
The list of tests has ArchiveJobTest.java:19, whose context looks up the database jdbc/ArchiveDS through JNDI.
