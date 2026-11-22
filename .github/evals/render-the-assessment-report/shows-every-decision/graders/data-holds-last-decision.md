---
type: regex
pattern: 'id="report-data">([^<]|<[^/])*?"questions/order-notes-markup"\s*:\s*\{'
match: contains
target: {source: file, path: testing/assessment-report.html}
---
The last decision, the one whose question quotes `</script>`, is inside the data block: nothing after the escaped value is lost.
