---
type: regex
pattern: '[Pp]ayments[^\n]{0,120}(stand-in|not-chosen|not chosen)|(stand-in|not-chosen|not chosen)[^\n]{0,120}[Pp]ayments'
match: contains
target: last_message
---
The reply gives the reason: the payments connection has no stand-in chosen.
