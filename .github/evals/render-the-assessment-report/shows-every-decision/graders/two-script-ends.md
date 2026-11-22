---
type: regex
pattern: '</script>'
match: count:2
target: {source: file, path: testing/assessment-report.html}
---
The page has the template's two `</script>` tags and no more: an unescaped `</script>` in the data would add one.
