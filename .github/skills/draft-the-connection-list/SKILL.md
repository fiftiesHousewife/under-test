---
name: draft-the-connection-list
description: Draft or update a repo's connection list (testing/connections.calm.json, CALM 1.3) from the airgap agent's reports, propose a test stand-in for each connection, and write the running_offline section of its testing/assessment.yaml. Use in discovery, after the repo's tests or application have run under the airgap agent, or when asked what a repo talks to.
---

# Drafting the connection list

The airgap agent refuses every call off the machine and reports it. Each distinct system in its reports is something
the repo depends on, and each becomes a connection in `testing/connections.calm.json`
([its schema](../../../schema/connection-list.schema.json), [an example](../../../examples/connection-list/connections.calm.json)),
for the Architecture Owner to confirm. Read the reports and the repo's files only: **never** build or run the repo.

## 1. Read the reports

Read every `build/airgap/<task>/calls.jsonl` in the repo (one per Gradle task), and any `calls.jsonl` you are given.
Each line is one JSON object ([the report's schema](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/schema/airgap-report.schema.json)):
`kind`, `target`, `outcome`, `run.kind`, `test`, `caller`, `setting.name`, `setting.from`.

Keep lines whose `kind` is `host-lookup`, `tcp`, `udp`, `database`, `http`, `jndi` or `mail`. Skip lines with
`outcome: allowed` and `allowed_by: always` (the machine itself). Lines of kind `process` go on the application's own
node as `programs-started`. `native-library`, `exit` and `file-write` lines belong to the safety inventory, not here:
mention them in your reply.

## 2. Group by system

Take the host from each `target`: `host:port`, a URL (`https://host:port/...`, port 443 or 80 by default), an LDAP URL
in a JNDI name, or a bare host for a host lookup. Lower-case it. One **node** per host:

* `unique-id`: the host with every character but letters and digits turned into `-` (`db-orders.prod.example.com`
  becomes `db-orders-prod-example-com`).
* `node-type`: `database` if any line is `database` or the port is 1521, 1433, 3306, 5432, 50000, 27017 or 6379;
  `ldap` for `jndi` lines to `ldap://` or ports 389 and 636; `service` for `http`; otherwise `system`.
* `name`: the host. `description`: what it seems to be, from the callers and settings, ending "found by the airgap
  agent".
* `interfaces`: one per port, `{"unique-id": "<node id>-<port>", "port": <port>}`.
* `metadata.under-test.addresses`: each `host:port` or URL seen, sorted.

The application's own node: `unique-id` from the repo's name, `node-type: service`.

## 3. One relationship per system

* `unique-id`: `<application node>-to-<node>`. `relationship-type.connects`: the application as `source`, the node and
  its interfaces as `destination`.
* `protocol`: `JDBC` for database lines; `HTTPS` for port 443 or an `https` URL, `HTTP` for other HTTP; `LDAP` for
  directories; `TCP` for mail and plain TCP; none for UDP.
* `metadata.under-test`:
  * `state: proposed`, `drafted_by: ai`, `found-by: [airgap-agent]` (add `settings` if a setting named it).
  * `kinds`, `runs`: each value seen, sorted. `tests`: how many different tests made the call.
  * `callers`: up to five different callers, sorted. `setting`: the first line's `setting`, if any.
  * `stand-in`: the first that fits, from
    [Order of preference for test stand-in approaches](../../../decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md):
    `run-in-container` for a database, directory, queue or mail server; `recorded-responses` for another team's or a
    vendor's HTTP service; otherwise `not-chosen`. Name a shared test kit (`kit`) only if the organisation has one for
    that system.
  * `never-reach`: the host, if it is a production address: it matches the organisation profile's
    `production_hosts` rule, or, without one, its name has `prod` or `prd` as a word. Otherwise leave it out and ask.

## 4. Merge with what is there

If `testing/connections.calm.json` exists, keep everything people decided. For a relationship already there:

* `state: decided`: keep `state`, `by`, `stand-in` and `never-reach`; add new `callers`, `kinds`, `runs` and
  `found-by` values, and update `tests`.
* `state: proposed`: replace it with the new draft.

**Never** remove or mark stale a connection the reports don't show: the agent sees only what ran. Keep nodes and
relationships in the file sorted by `unique-id`. Top-level `metadata.under-test`: `application`, the application's
`node`, the `reports` you read, and the repo's short `commit`.

## 5. Record it in the assessment file

Write the `running_offline` section of `testing/assessment.yaml` in full: `found_by`
`{tool: draft-the-connection-list, version: "<toolkit version, or unreleased>", commit: <short commit>}`, the
`reports`, and one finding per node (`id` the node's `unique-id`, `target` its first address, `kind` the most specific
seen, in the order `database`, `http`, `mail`, `jndi`, `tcp`, `host-lookup`, `udp`), with `callers`, `setting` as
`"<name>, <from>"`, `runs` and `tests`. Put every `callers` entry in double quotes. Leave the other sections as they are. If the file doesn't exist yet, create it with `schema: assessment/1`, a `repo:` with at least `name`, and the `# yaml-language-server: $schema=...` first line pointing at the toolkit's schema: a relative path to it where the toolkit is installed next to the repo, otherwise `https://raw.githubusercontent.com/fiftiesHousewife/under-test/main/schema/assessment.schema.json`.

## 6. Check, then report

Check both files against their schemas if a validator is at hand. Then tell the person, briefly:

1. Each system the code tried to reach, with its proposed stand-in, production addresses first.
2. What the Architecture Owner must confirm: every `proposed` connection, and any address you couldn't place as
   production or not.
3. Anything for the safety inventory: native libraries, exits, file writes.
4. Stand-ins that may already exist: a caller that is refused for a real system but also allowed to reach the machine
   itself (`localhost:<port>`) probably has a local stand-in some tests already use. Say which, so it can be reused.

The tests can't run offline until every connection has a stand-in.
