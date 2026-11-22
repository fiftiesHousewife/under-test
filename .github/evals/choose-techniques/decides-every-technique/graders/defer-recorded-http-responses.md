---
type: regex
pattern: '^[ \t]*["'']?techniques/recorded-http-responses["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/recorded-http-responses` proposes defer. `needed_when` 'Dependency you do not own, over HTTP' is true for the payments service, but nothing says whether `possible_when` 'A non-prod instance is reachable to record from' holds; no planned work makes it true and none of its own checks settles it.
