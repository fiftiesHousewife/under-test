---
type: regex
pattern: '^# yaml-language-server: \$schema=\.\.\/schema\/source-list\.schema\.json\napplication: orders\ncurator: Orders and Fulfilment, knowledge curator\nsources:\n  - id: uat-regression-suite\n    kind: test-automation-suite\n    location: qa-automation repo, orders\/ folder \(Selenium, run against the shared test environment\)\n    owner: QA team\n    currency: mostly-current\n    notes: Covers placing, changing and cancelling an order\. Keeps running until repo tests cover the same journeys\.\n  - id: orders-release-pack\n    kind: manual-test-scripts\n    location: Test management tool, "Orders release pack", exported to exports\/orders-release-pack\.csv\n    owner: QA team\n    currency: out-of-date\n    notes: Refunds and partial shipments; mined for examples\.\n  - id: refund-policy\n    kind: specification-document\n    location: Wiki, Orders space, "Refund policy"\n    owner: Orders and Fulfilment\n    currency: current\n$'
match: contains
target: {source: file, path: testing/sources.yaml}
---
testing/sources.yaml is exactly as the scaffold wrote it: the pattern is the whole file.
