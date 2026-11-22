---
type: regex
pattern: '^[ \t]*["'']?techniques/server-rendered-ui-tests["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?reject["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/server-rendered-ui-tests` proposes reject. Its only `needed_when`, 'Pages are built on the server (JSP, JSF, Struts, templates) and the logic behind them is hard to reach', is known false: a web service with no JSP, JSF, Struts or template engine in its build.
