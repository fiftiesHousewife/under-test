---
type: regex
pattern: '<script[^>]*\ssrc\s*='
match: not_contains
target: {source: file, path: testing/assessment-report.html}
---
No script is loaded from anywhere: the template has none, and the page must work with no network.
