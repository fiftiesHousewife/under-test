---
type: regex
pattern: '^[ \t]*["'']?techniques/in-memory-databases["'']?:[ \t]*\n(?:(?![ \t]*["'']?[a-z-]+/[a-z0-9-]+["'']?:)(?:[ \t]+[^\n]*)?\n)*?[ \t]+choice:[ \t]*["'']?adopt["'']?[ \t]*$'
flags: m
match: contains
target: {source: file, path: testing/assessment.yaml}
---
The decision `techniques/in-memory-databases` proposes adopt. `needed_when` 'The code reads or writes a relational database, and the machines local tests run on can't run containers' is true: the orders database over JDBC, and developers' machines can't run containers (stated in the request). 'The code's SQL uses only features the in-memory database shares with the real one' is unknown but settled by its own check, so it counts as planned work; 'Tests on the real database engine (testcontainers or a disposable test schema) are in place or planned' holds because testcontainers is adopted. Its evidence is level 0 only, so it never stands in for the Oracle tests.
