# From the airgap agent's reports

Read this when there are airgap agent reports to read (step 1 says which files), or reports the person gives you.
That is after measurement's runs, or whenever the repo's tests or application have run under the agent. It
works the same whether or not the code has been read for connections first: a system the code search found gets the
reports' addresses, kinds and callers merged in as step 4 says, and a node whose address wasn't known (one with
`address-from`) takes the host of a report line whose `caller` is in one of its `opened-by` classes.

Each system in the airgap agent's reports becomes a connection in `testing/external-systems.calm.json`
([its schema](../../../schema/external-systems-list.schema.json), [an example](../../../examples/external-systems-list/external-systems.calm.json))
for the Architecture Owner to confirm, and each test the agent refused a call to another machine gets an
`external_systems` entry in `testing/tests.yaml` ([its schema](../../../schema/tests.schema.json)). Read the reports
and the repo's files only: **never** build or run the repo.
The example's layout is the one to follow; it overrides any older layout in
[The external systems list says what tests use for each connection and which addresses tests must never reach](../../../decision-guides/0031-the-external-systems-list-says-what-tests-use-for-each-system-and-which-addresses-tests-must-never-reach.md).

**Sorted**, everywhere in this skill, means by code point, as Python's `sorted` does.

The **organisation profile** is the organisation repo's `organisation-profile.yaml`, which the person names. Without
one, use the defaults this skill gives.

## 1. Read the reports

For each task, read its one full run's report: after measurement, `build/under-test/runs/1/<task>/calls.jsonl`, in
each project's build folder, since measurement deletes `build/airgap/<task>/calls.jsonl` at the start of every run it
keeps, leaving there only its last rerun's calls; for a task measurement didn't run (such as `bootRun`), or with no
measurement, `build/airgap/<task>/calls.jsonl`. Read those and any `calls.jsonl` you are given, paths in byte order,
lines in file order (**reading order**). Each line is a JSON object
([the report's schema](https://github.com/fiftiesHousewife/under-test-airgap/blob/main/schema/airgap-report.schema.json)).
Check the rows in order; a line goes to the first row that fits. A line allowed for any reason other than `always`
is treated like a refused one.

| Line | Goes to |
|---|---|
| `outcome: allowed`, `allowed_by: always` (the machine itself) | nowhere; note its `caller` for the reply |
| `kind` `host-lookup`, `tcp`, `udp`, `database`, `http`, `jndi`, `mail` | its system's node |
| `kind` `process` | the application's node, as `programs-started` |
| `kind` `native-library`, `exit`, `file-write` | the reply, for the safety inventory |

## 2. One node per system

Each `target` gives a host, lower-cased, and a port: from `host:port`; from a URL (also an LDAP URL in a JNDI name),
defaulting to 80 for `http`, 443 for `https`, 389 for `ldap`, 636 for `ldaps`; none from a bare host. A target with no
host makes no node: mention it in the reply. One node per host, keys in this order:

| Key | Value |
|---|---|
| `unique-id` | the host with each character but `a-z` and `0-9` turned into `-`, runs of `-` collapsed to one and `-` trimmed from both ends (`db-ledger.prd.example.net` becomes `db-ledger-prd-example-net`); if two hosts get the same id, add `-<lowest port>` to each (nothing for a host with no port), and their interface ids use the new id |
| `node-type` | the first that fits: `database` (a `database` line, or port 1521, 1433, 3306, 5432, 50000, 27017 or 6379); `ldap` (a `jndi` line to `ldap://` or `ldaps://`, or port 389 or 636); `service` (an `http` line); `system` |
| `name` | the host |
| `description` | `<Thing> reached from <callers' classes, distinct, sorted, joined by ", ">, found by the airgap agent.`; a caller's class is the part of the `caller` before the method, after the last `.` (`OrderRepository` from `com.example.orders.OrderRepository.connect(OrderRepository.java:41)`); `<Thing>` is `A database`, `A directory`, `An HTTP service`, `A mail server` (a `system` with a `mail` line) or `A system` |
| `interfaces` | per port, by number: `{"unique-id": "<node id>-<port>", "port": <port>}`; left out if none |
| `metadata.under-test.addresses` | each distinct `target` as written, sorted |

The application's node: `unique-id` from `repo.name` in the assessment file (else the repo's folder name), made the
same way; `node-type` `service`; `name` that name; `description` its `repo.summary`, else `The application in this
repo.`; `metadata.under-test.programs-started` the distinct `process` targets, sorted, left out if none; if that leaves
`metadata` empty, leave `metadata` out.

Each line's **kind** is its `kind` turned into the external systems list's kinds by [SKILL.md](SKILL.md)'s step 3
(`tcp` to port 5672, 9092 or 61616 is a `queue`; other `tcp`, and `udp`, a `socket`; `jndi` to `ldap://` or
`ldaps://` a `directory`). The **most specific kind** of a system is the first of its lines' kinds in that step's
order, used everywhere: `database`, `http`, `mail`, `directory`, `queue`, `jndi`, `socket`, `url`, `host-lookup`.

## 3. One relationship per system

Keys in this order, no `description`:

* `unique-id`: `<application node>-to-<node>`.
* `protocol`, by the most specific kind: `database` `JDBC`; `http` `HTTPS` if a line or address uses port 443 or
  `https`, else `HTTP`; `mail` and `queue` `TCP`; `directory` `LDAP`; `socket` `LDAP` to an `ldap` node, else `TCP`,
  unless every line is `udp`; otherwise (`udp` only, `jndi`, `url`, `host-lookup`) none (left out).
* `relationship-type`: `{"connects": {"source": {"node": "<application node>"}, "destination": {"node": "<node>",
  "interfaces": [<its interface ids>]}}}`, `interfaces` left out if none.
* `metadata.under-test`:

| Key | Value |
|---|---|
| `state`, `drafted_by` | `proposed`, `ai` |
| `found-by` | `["airgap-agent"]`, or `["airgap-agent", "settings"]` if a line has a `setting` |
| `kinds`, `runs` | each line's kind (as step 2 turns it), each `run.kind`, distinct, sorted |
| `callers` | distinct `caller` values, sorted, first five |
| `setting` | `name` and `from` of the first line in reading order that has one; left out if none |
| `tests` | how many distinct `test` values (0 if none) |
| `stand-in` | `{"approach": ...}`, the first that fits from [Order of preference for test stand-in approaches](../../../decision-guides/0036-order-of-preference-for-test-stand-in-approaches.md): `run-in-container` for a `database` or `ldap` node, or a `mail` or `queue` kind; `recorded-responses` for a `service` node; `in-process-server` for a `socket` kind ([An in-process server the test starts is a stand-in](../../../decision-guides/0067-an-in-process-server-the-test-starts-is-a-stand-in-and-comes-first-where-developers-machines-cannot-run-containers.md)); else `not-chosen`. Leave `kit` out unless the person names a shared test kit for that system. They come from [Testcontainers](../../../techniques/testcontainers/technique.yaml) and [recorded HTTP responses](../../../techniques/recorded-http-responses/technique.yaml) |
| `never-reach` | `["<host>"]` if the host is a production host, else left out. Use the organisation profile's `production_hosts` only if it lists host names or patterns; otherwise split the host on `.` and `-`, and it is a production host if one part is `prod` or `prd` |

## 4. Merge with what is there

If `testing/external-systems.calm.json` exists, keep what people decided:

* relationship `decided`: keep every field, but merge in new `kinds`, `runs` and `found-by`, sorted; keep every
  existing `callers` entry and add new ones, sorted, until there are five; set `tests` to the new count;
* relationship `stale` seen again: treat it as `proposed`;
* relationship `proposed`: replace it with the new draft only if its `drafted_by` is `ai`; leave one a person drafted
  as it is, and say so in the reply;
* node: keep it, merging in new `interfaces`, `addresses` and `programs-started`, sorted; **never** change its other
  fields;
* top-level `reports` and `commit`: replace them with this run's;
* anything the reports don't show: **never** remove it or mark it stale, as the agent sees only what ran.

Write it as `json.dumps(data, indent=2, ensure_ascii=False)` does, plus a newline. Top-level keys: `$schema`
(`https://calm.finos.org/release/1.3/meta/calm.json`), `metadata`, `nodes`, `relationships`; nodes and relationships
sorted by `unique-id`. `metadata.under-test`: `application` (`repo.application`, else the repo name), `node` (the
application's node), `reports` (paths read, sorted), `commit` (what `git rev-parse --short HEAD` prints).

## 5. Record each refused test in testing/tests.yaml

Each line with `outcome: refused` that names a `test` (a line with no `test` (the agent names the test on the JUnit
Platform and, from airgap 0.4.0, under Surefire's JUnit 4 provider too, but not for a call in `@BeforeClass` or
`@AfterClass`) gets its test
from its `stack`: the first frame in a class from the repo's test sources, as `<class>.<method>`.), to a host other than `localhost`, `127.0.0.1` or `::1`, gives
that test an `external_systems` entry for the line's node, one per test and node, keys in this order:

* `node`: the node's `unique-id`; `kind`: the most specific kind of that test's lines to the node;
* `found_by: airgap-report`, `grade: reaches`, `reason: airgap-report`;
* `where`: the first such line's `caller`, as `<path>:<line>`: the file and line in its parentheses, the path being the
  one `git ls-files` lists that ends in the caller's package as folders and that file
  (`src/main/java/com/example/orders/OrderRepository.java:41` from
  `com.example.orders.OrderRepository.connect(OrderRepository.java:41)`), or the file name alone if none does.

A test that already has an entry for that node from the code, graded `reaches` or `may-reach`, keeps it and gets none
from here; one graded `cannot-reach` gets this entry beside it. Replace every `found_by: airgap-report` entry each time,
and leave the others as they are. Add an entry for a test with none (`test` as the line names it, `at` the
`"path:line"` of its method, found with `grep -n`); an entry left with only `test` and `at` goes. Set
`found_by.draft-the-external-systems-list` as [SKILL.md](SKILL.md)'s step 4 says, and write the file the same way.

## 6. Record it in the assessment file

Replace `running_offline` in `testing/assessment.yaml` in place, or insert it directly before the next section the
schema lists after it, with no blank line, editing the text, not rewriting the file through a YAML library. Leave
the other sections as they are. One finding per node seen in these reports except the application's, sorted by id; its `id` is the node's
`unique-id`, and `reports` are the same as in the external systems list's `metadata`:

```yaml
running_offline:
  found_by: {tool: draft-the-external-systems-list, version: "<version>", commit: "<commit>"}
  reports: ["build/airgap/bootRun/calls.jsonl", "build/airgap/test/calls.jsonl"]
  findings:
    - id: db-ledger-prd-example-net
      target: db-ledger.prd.example.net
      kind: database
      callers: ["com.example.ledger.LedgerStore.open(LedgerStore.java:22)"]
      setting: "ledger.jdbc.url, ledger.properties:3"
      runs: [application, test]
      tests: 3
```

`version` is the organisation profile's `toolkit.version` if you have it, else `unreleased`; `commit` as above.
`target` is the first of the node's `addresses`, sorted; `kind` the agent's own `kind` of the first line, in reading
order, whose kind (as step 2 turns it) is the most specific kind; `runs`, `tests` as in its
relationship; `callers` as a new draft of it would have them, from these reports only; `setting`
`"<name>, <from>"` (or `"<name>"`), left out if none. Always double-quote `version`, `commit`, `setting` and each
`reports` and `callers` entry; double-quote any other text value (not a number, `true`, `false` or `null`) that starts with anything but a letter or contains `:`
or `#`, writing `"` as `\"` and `\` as `\\`. Lists stay on one line, joined by `, `.

If the file doesn't exist, start it as [run-the-safety-inventory](../run-the-safety-inventory/SKILL.md) says in its
step 3.

## 7. Check, then report

Check the files against their schemas if a validator is at hand. Then tell the person, briefly:

1. Each system the code tried to reach, with its proposed stand-in: production addresses first, then the rest by node id.
2. What the Architecture Owner must confirm: every `proposed` connection, and, without an organisation profile, every
   host not marked `never-reach`.
3. For the safety inventory: native libraries, exits, file writes, each by target and caller.
4. Stand-ins that may already exist: a caller refused for a real system but allowed to reach `localhost:<port>`
   probably has a local stand-in some tests use. Say which, so it can be reused.
5. End with: "The tests can't run offline until every connection has a stand-in."
