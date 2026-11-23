---
name: draft-the-connection-list
description: Draft or update a repo's connection list (testing/connections.calm.json, CALM 1.3), with a proposed test stand-in for each connection, and record in testing/tests.yaml which tests may reach each one. In discovery it finds connections from the code with connection-paths and from the repo's settings; after a run under the airgap agent it merges in the agent's reports. Use in discovery, after a run under the airgap agent, or when asked what a repo talks to.
---

# Drafting the connection list

Every system outside the program that the code connects to becomes a node in `testing/connections.calm.json`
([schema](../../../schema/connection-list.schema.json), [example](../../../examples/connection-list/connections.calm.json)),
with a relationship from the application holding a proposed stand-in, for the Architecture Owner to confirm. Each test
that may reach one gets a `connections` entry in `testing/tests.yaml` ([schema](../../../schema/tests.schema.json)).

Run nothing of the repo's but its build's dependency resolution: **never** compile it, run its tests or start it
([why](../../../docs/decisions/0073-a-repo-may-be-built-without-running-its-tests-before-the-safety-gate.md)). Never
copy a secret's value into a file or the reply; point at its file and line.

**Sorted** means by code point, as Python's `sorted` does. The **organisation profile** is the organisation repo's
`organisation-profile.yaml`, which the person names; without one, use the defaults here.

## 0. Read what applies

| When | Read |
|---|---|
| There are airgap agent reports (`build/airgap/*/calls.jsonl`) or the person gives you some | [from-airgap-reports.md](from-airgap-reports.md), and do what it says after this file's steps, or alone if the person asks only for that |
| The build has more than one module | [modules.md](modules.md), first |
| The build uses Spring Boot (`org.springframework.boot` in a build file) | [spring-boot.md](spring-boot.md) |
| The code or tests load Spring XML (`<beans` in a resource, `@ImportResource`, `@ContextConfiguration` naming XML, `XmlApplicationContext(`) | [spring-xml.md](spring-xml.md) |

```bash
ls settings.gradle* build.gradle* pom.xml build/airgap/*/calls.jsonl 2>/dev/null
grep -lE '^\s*include|<modules>' settings.gradle* pom.xml 2>/dev/null
grep -lE 'org\.springframework\.boot' build.gradle* pom.xml */build.gradle* */pom.xml 2>/dev/null
grep -rlE '<beans|@ImportResource|@ContextConfiguration\(.*\.xml|XmlApplicationContext\(' --include='*.xml' --include='*.java' src */src 2>/dev/null | head -3
```

## 1. Run connection-paths

[connection-paths](https://github.com/fiftiesHousewife/connection-paths) finds, from source, every method that opens or
uses a connection and every test that may reach one, with a chain of calls for each. It needs Java 17 or later and its
jar: the organisation profile's `tools.connection_paths_jar`, else `$CONNECTION_PATHS_JAR`. With neither, stop and say
so: the jar is built from its repo with `./gradlew allInOneJar`.

The classpath comes from the build, which only resolves dependencies:

```bash
mvn -q dependency:build-classpath -Dmdep.outputFile=build/connection-paths-classpath.txt          # Maven
./gradlew -q --init-script <this skill's folder>/print-classpath.gradle connectionPathsClasspath   # Gradle: prints the file per module
```

If the build can't resolve them, run without `--classpath` and say so in the reply. Then, for each module (the repo
root if there is one):

```bash
java -jar "$CONNECTION_PATHS_JAR" --module <module folder> --classpath @<its classpath file> --out <facts file>
```

The facts file is `testing/connection-paths.json`, or `testing/connection-paths/<module folder, / as ->.json` for a
module. Read only its `summary`, `connection_points`, `not_resolved` (the first five) and, for the tests, what step 4
needs: with `python3 -c` or `jq`, never by printing the file. If more than 5% of calls are not resolved, say which
types are missing, from `not_resolved`.

## 2. Find each connection's address

For each method in `connection_points`, read that method only (`sed -n '<line>,<line + 40>p' <file>`, stopping at its
end) and follow where the address it connects to comes from, as far as the repo goes:

| It comes from | Then |
|---|---|
| A literal | its host (lower-cased; no scheme, port or path) |
| A setting, by name: a properties or YAML key, a Spring placeholder, `@Value`, a key passed to a settings class | its value in the repo's main settings files (and see spring-boot.md or spring-xml.md); no value anywhere means unknown, `address-from: "setting <name>, which has no value in the repo"` |
| A parameter or field | its callers or assignments, by `grep -rn` on the method or field name; at most two steps, then unknown |
| An environment variable, a system property, a JNDI name | unknown: `address-from: "environment variable <name>"`, `"system property <name>"`, `"JNDI name <name>"` |
| Built at run time, or anything else | unknown: `address-from: "built at run time in <Class>.<method>"` |

`process` and `host-lookup` points make no node: list them in the reply, for the safety inventory.

## 3. One node and one relationship per system

Group the connection points into systems: the same host is one system; else the same setting name is one; else each
class that opens a connection is one. A method with two kinds (a JNDI lookup that returns a database) belongs to one
system, whose **kind** is the first of its kinds in this order: `database`, `http`, `mail`, `directory`, `queue`,
`jndi`, `socket`, `url`.

| Node key | Value |
|---|---|
| `unique-id` | from the host as from-airgap-reports.md step 2 makes it; else `<kind>-<setting name>` or `<kind>-via-<class's simple name>`, lower-cased, every character but `a-z` and `0-9` turned to `-`, runs collapsed, ends trimmed |
| `node-type` | `database` for a database; `ldap` for a directory; `service` for `http`; else `system` |
| `name` | the host; else `<A database / A directory / An HTTP service / A mail server / A queue / A system>, address unknown, opened by <class's simple name>` |
| `description` | `<Thing> opened by <the opening classes' simple names, sorted, joined by ", ">, found in the code by connection-paths.` |
| `metadata.under-test` | `addresses` (the hosts or URLs as written, sorted) if known, else `address-from`; and `opened-by`, the methods as connection-paths names them, sorted |

The relationship is as from-airgap-reports.md step 3 makes it, except: `found-by` `["code"]`, plus `"settings"` when
the address came from a setting; `kinds` the system's kinds, sorted; `callers` its connection points as
`<type>.<method>(<file name>:<line>)`, sorted, first five; `setting` the setting's `name` and `from` (`path:line`) if
any; `tests` how many tests step 4 gives a `connections` entry for it; no `runs`; `stand-in` and `never-reach` by the
same rules, with a queue's stand-in `run-in-container` and a `url`'s `not-chosen`.

The application's node, the merge with an existing file, and how the file is written are as from-airgap-reports.md
steps 2 and 4 say; `metadata.under-test.reports` is left out when there are none.

## 4. Record each test's connections in testing/tests.yaml

For each test in the facts file's `tests`, one `connections` entry per system it may reach (the system holding the
reach's `point`), keys in this order:

* `node`: the system's `unique-id`; `kind`: its kind; `found_by: code-path`;
* `through_set_up`: the reach's `through_set_up`;
* `via`: the reach's `chain` as `<Class>.<method>` steps (simple class names, no parameters), joined by ` > `.

Then the tests whose own code or the settings they load name a host (spring-boot.md, spring-xml.md, and in test code
`grep -rnE '(//|@|=)([A-Za-z0-9.-]+\.[A-Za-z]{2,}|[0-9]{1,3}(\.[0-9]{1,3}){3})' <test folders>`). A host is never
`localhost`, `127.0.0.1`, `::1`, `example.com`/`.org`/`.net` or their subdomains, one ending `.example`, `.test`,
`.invalid` or `.localhost`, an XML namespace, a schema location or a DTD address. Each gets a node by its host, if it
has none yet, and an entry with `found_by: test-code` or `test-settings` and `where`, the `path:line` naming it.

In `testing/tests.yaml`, replace `connections` in every entry and add an entry (`test`, `at` from the facts file's
`file:line`, made relative to the repo root) for a test that has none; never touch another skill's keys. An entry left
with only `test` and `at` goes. Set `found_by.draft-the-connection-list` (`version`, the organisation profile's
`toolkit.version` or `unreleased`; `commit`, `git rev-parse --short HEAD`). Entries sorted by `test`; every string
double-quoted. No file yet: start it as find-test-anti-patterns' step 3 says.

## 5. Check, then report

Check the files against their schemas if a validator is at hand. Then tell the person, briefly:

1. Each system, with its kind, address or where the address comes from, how many tests may reach it, and its proposed
   stand-in: production addresses first, then by node id.
2. What the Architecture Owner must confirm: every `proposed` connection, every address not known, and, without an
   organisation profile, every host not marked `never-reach`.
3. How much connection-paths resolved, and the dispatch points it didn't follow that a person should look at: the
   three with most implementations.
4. For the safety inventory: the `process` and `host-lookup` points, by method.
5. End with: "Every test listed may reach a real system until measurement confirms or clears it."
