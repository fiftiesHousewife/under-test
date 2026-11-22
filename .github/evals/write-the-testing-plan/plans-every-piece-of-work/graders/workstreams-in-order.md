---
type: regex
pattern: '### 1\. Make it run on its own[\s\S]*### 2\. Fix flaky tests[\s\S]*### 3\. Record current behaviour[\s\S]*### 4\. Make code testable[\s\S]*### 5\. Test against requirements[\s\S]*### 6\. Strengthen tests'
match: contains
target: {source: file, path: testing/TESTING-PLAN.md}
---
The workstreams are in the order of the decision guide.
