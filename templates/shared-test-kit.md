# Shared test kit: <system name>

<!-- Template from the toolkit (under-test), templates/shared-test-kit.md. Copy it into your organisation repo as
     shared-test-kits/<system-id>/README.md when a shared system (a database, a queue, an internal service) is used
     by enough repos that every one standing in for it separately would cost more than one kit. Words follow the
     toolkit's GLOSSARY.md. Delete these comments. -->

**System:** <name and owner> · **Kit owner:** <role or team> · **Version:** <the kit's own version>

## What it stands in for

<The real system, the parts of it the kit covers, and the parts it doesn't. Name the system's connection-list entry.>

## Two parts

| Part | For | What it is |
|---|---|---|
| Local tests | Every developer machine, no container runtime needed | <a fake behind an interface, or recorded responses> |
| Container tests | CI, and machines with a container runtime | <the real product in a container, with seed data> |

## How a repo uses it

<The dependency to add, the settings, and a short example test.>

## Staying true to the real system

- **Checked against the real system:** <how and how often: a contract test, or re-recording against a test instance>
- **Seed data:** synthetic only, never copied from production
- **Recordings:** personal data removed before they are committed

## Changes

<How teams ask for a change, who approves it, and how a new version is announced.>
