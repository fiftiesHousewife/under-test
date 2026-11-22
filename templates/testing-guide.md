# Testing guide: <technology stack or application type>

<!-- Template from the toolkit (under-test), templates/testing-guide.md. Copy it into your organisation repo, as
     testing-guides/technology-stacks/<id>.md or testing-guides/application-types/<id>.md, once a pilot application of
     this kind has been through discovery, measurement and planning. The ids come from the toolkit's decision on the
     lists of technology stacks and application types. Words follow the toolkit's GLOSSARY.md. Delete these comments. -->

**Kind:** technology stack | application type · **Id:** `<id>` · **Worked out on:** <pilot application, by name>

## What this covers

<The repos this guide applies to, in a sentence or two, and how to tell one when you see it (what the repo classifier
reports for it).>

## Default techniques

Techniques are named by their id in the toolkit's `techniques/`; this guide never copies their rules.

| Workstream | Technique | Default | Why, for this kind of repo |
|---|---|---|---|
| make it run on its own | `<technique-id>` | adopt / defer / reject | <reason> |
| record current behaviour | `<technique-id>` | adopt / defer / reject | <reason> |
| strengthen tests | `<technique-id>` | adopt / defer / reject | <reason> |

## Where the edges are

<What this kind of repo talks to, and what tests use instead of each (from the connection lists of the pilot): which
shared test kits apply, and which addresses tests must never reach.>

## Target test mix

<Application types only: the target share of local tests, container tests and broad tests, and how far a repo at
test maturity level 2 may lean on broad tests before it moves down the mix.>

## Known obstacles

<Obstacles to testing that the pilot met, how each was scored, and what got past it.>

## Departures

<How a repo records that it departs from this guide: a short decision in its own assessment file, approved by its
Application Owner.>
