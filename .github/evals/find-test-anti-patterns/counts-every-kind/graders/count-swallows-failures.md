---
type: regex
pattern: '^[ \t]*(?:- )?id: ["'']?swallows-failures["'']?[ \t]*\n(?:[ \t]+(?:[^-\s]|- ["''])[^\n]*\n)*?[ \t]+tests: 2[ \t]*$'
flags: m
match: count:1
target: {source: file, path: testing/assessment.yaml}
---
The finding with id `swallows-failures` is there once, and counts 2: NotificationTest.sendsAConfirmation, whose assertion sits in a try with an empty catch (Exception), and countsWhatItSent, which catches AssertionError and only prints it. rejectsAnEmptyAddress is the try, fail, catch idiom for an expected exception, so it doesn't count.
