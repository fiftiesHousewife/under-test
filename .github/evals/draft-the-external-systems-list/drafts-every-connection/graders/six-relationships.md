---
type: regex
pattern: '"unique-id"\s*:\s*"orders-service-to-'
match: count:6
target: {source: file, path: testing/external-systems.calm.json}
---
Exactly six relationships, one per system in the reports. The allowed call to the machine itself, the program started and the native library add none.
