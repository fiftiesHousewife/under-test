---
type: regex
pattern: '^[ \t]*["'']?techniques/openapi-response-checks["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?defer["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/openapi-response-checks` proposes defer. Neither `needed_when` is known: nothing in the files says whether the service's own API or the payments API has a published OpenAPI document. No need is known true and one is unknown, and the skill never rejects on an unknown.
