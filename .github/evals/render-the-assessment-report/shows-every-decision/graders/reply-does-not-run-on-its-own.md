---
type: regex
pattern: '(on its own|offline)[^\n]{0,40}(\n+[^\n]{0,10})?(\b[Nn]o\b|[Nn]ot\b)'
match: contains
target: last_message
---
The reply says it does not run on its own yet.
