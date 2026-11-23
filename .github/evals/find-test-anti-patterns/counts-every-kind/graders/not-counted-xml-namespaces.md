---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?reaches-external-system["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+(?:[^-\s]|- ["''])[^\n]*DiscountRulesContextTest'
flags: m
match: not_contains
target: {source: file, path: testing/assessment.yaml}
---
DiscountRulesContextTest's Spring XML holds only namespace and schema URLs (www.springframework.org, www.w3.org), which are names in the XML, not systems the test reaches, so the reaches-external-system finding does not cite it.
