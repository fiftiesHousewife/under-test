---
name: draft-the-external-systems-list
description: Draft or update a repo's external systems list (testing/external-systems.calm.json, CALM 1.3), with a proposed test stand-in for each connection, and record in testing/tests.yaml which tests may reach each one. In discovery it finds connections from the code with connection-paths and from the repo's settings; after a run under the airgap agent it merges in the agent's reports. Use in discovery, after a run under the airgap agent, or when asked what a repo talks to.
---

# Drafting the external systems list

Every system outside the program that the code connects to becomes a node in `testing/external-systems.calm.json`
([schema](../../../schema/external-systems-list.schema.json), [example](../../../examples/external-systems-list/external-systems.calm.json)),
with a relationship from the application holding a proposed stand-in, for the Architecture Owner to confirm. Each test
that may reach one gets an `external_systems` entry in `testing/tests.yaml` ([schema](../../../schema/tests.schema.json)).

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

[connection-paths](https://github.com/fiftiesHousewife/connection-paths) finds, from source, every place the code opens
or uses a connection, where each address comes from, which points stay on the machine, the systems they make, and every
test that may reach each one with the chain of calls
([why](../../../docs/decisions/0074-connection-paths-does-everything-a-program-can-decide-and-the-connection-list-skill-only-what-needs-judgement.md)).
It needs Java 17 or later and its jar: the organisation profile's `tools.connection_paths_jar`, else
`$CONNECTION_PATHS_JAR`. With neither, stop and say so, unless the person says the facts file below is already there
and current: then use it, and skip to reading it.

The classpath comes from the build, which may compile but runs no test. Use the repo's wrapper (`sh mvnw`, `./gradlew`)
if it has one, else the organisation profile's `tools.maven` or `tools.gradle`, else `mvn` or `gradle`:

```bash
mvn -q -pl <module> -am -DskipTests compile dependency:build-classpath -Dmdep.outputFile=build/connection-paths-classpath.txt   # Maven; drop -pl/-am for the root
gradle -q --init-script <this skill's folder>/print-classpath.gradle connectionPathsClasspath                                 # Gradle: prints each module's file
```

If the build can't resolve them (a dependency in a repository that has gone or refuses it), say which artifact and
repository, and run without `--classpath`. Then, for each module (the repo root if there is one):

```bash
java -jar "$CONNECTION_PATHS_JAR" --module <module folder> --classpath @<its classpath file> \
  --settings <any other folder of settings files> --out <facts file>
```

The facts file is `testing/connection-paths.json`, or `testing/connection-paths/<module folder, / as ->.json` for a
module. Read only its `summary`, `systems`, `not_resolved` (the first five), and per test its `systems` and `reaches`:
with `python3 -c` or `jq`, never by printing the file. If more than 5% of calls are not resolved, say which types are
missing, from `not_resolved`.

## 2. Settle what the tool can't

Each system in `systems` is one connection. Points with a `local` reason, and `process` and `host-lookup` points, are
in no system: list them in the reply, the last two for the safety inventory. For each system:

* **Address `built-at-run-time` or `parameter`:** read only the methods in its `points` (`sed -n` from each point's
  line, to its method's end) and follow where the address comes from, at most two steps by `grep -rn` on the method or
  field; record what you find, or keep it unknown.
* **A setting with no `setting_value`:** look for its value in settings the tool wasn't given (spring-boot.md,
  spring-xml.md; deployment descriptors); none means unknown.
* **`placeholder`, and `alternatives`:** never decide these; list them for the person (alternatives are systems a
  program picks between at run time, which may be one system).

## 3. One node and one relationship per system

The **kind** of a system is the first of its `kinds` in this order: `database`, `http`, `mail`, `directory`, `queue`,
`jndi`, `socket`, `url` ([why](../../../docs/decisions/0076-a-connection-whose-address-is-not-known-is-a-system-of-its-own-per-class-that-opens-it.md)).

| Node key | Value |
|---|---|
| `unique-id` | `named_by: host`: the host as from-airgap-reports.md step 2 makes it; a setting, variable or JNDI name: `<kind>-<name>`; `class`: `<kind>-via-<the class's simple name>`; lower-cased, every character but `a-z` and `0-9` turned to `-`, runs collapsed, ends trimmed |
| `node-type` | `database` for a database; `ldap` for a directory; `service` for `http`; else `system` |
| `name` | the host; else `<A database / A directory / An HTTP service / A mail server / A queue / A system>, address from <setting / environment variable / system property / JNDI name> <name>`, or `..., address unknown, opened by <the class's simple name>` |
| `description` | `<Thing> opened by <the opening classes' simple names, sorted, joined by ", ">, found in the code by connection-paths.` |
| `metadata.under-test` | `addresses`: the literal, or a setting's value that isn't a placeholder, as written; else `address-from`: `setting <name>, which has no value in the repo`, `setting <name>, whose value in <file>:<line> is a placeholder`, `environment variable <name>`, `system property <name>`, `JNDI name <name>`, or `built at run time in <value>`; and `opened-by`, the system's `points` |

The relationship is as from-airgap-reports.md step 3 makes it, except: `found-by` `["code"]`, plus `"settings"` when
the address is a setting; `kinds` the system's kinds; `callers` its points as `<type>.<method>(<file name>:<line>)`,
each point's file and line from `connection_points`, sorted, first five; `setting` `{name, from: "<file>:<line>"}` if
the tool found its value; `tests` the system's `tests`; no `runs`; `stand-in` and `never-reach` by the same rules, with
a queue's stand-in `run-in-container` and a `url`'s `not-chosen`.

The application's node, the merge with an existing file, and how the file is written are as from-airgap-reports.md
steps 2 and 4 say; `metadata.under-test.reports` is left out when there are none.

## 4. Record each test's connections in testing/tests.yaml

For each test in the facts file's `tests`, one `external_systems` entry per name in its `systems`, keys in this order (the
reach is the one whose `point` is among the system's `points`):

* `node`: the system's `unique-id`; `kind`: its kind; `found_by: code-path`;
* `grade` and `reason`, by the first that holds
  ([why](../../../docs/decisions/0085-each-test-is-graded-reaches-may-reach-or-cannot-reach-from-the-address-its-own-settings-give.md)):

  | When | `grade` | `reason` |
  |---|---|---|
  | The reach has `through_mock` | `cannot-reach` | `through-a-mock` |
  | The test's `stand_ins` has an embedded server for the kind (its simple name holds `Ldap` for a directory; `GreenMail` or `Mail` for mail; `WireMock` or `MockWebServer` for `http` and `url`; `Postgres`, `MySql`, `Mongo`, `H2` or `Database` for a database; `Kafka`, `ActiveMQ`, `Artemis` or `Rabbit` for a queue) | `cannot-reach` | `embedded-server` |
  | `address_for_tests` is `none` | `cannot-reach` | `no-address-for-tests` |
  | `address_for_tests` is `local` | `cannot-reach` | `local` |
  | `address_for_tests` is `host` | `reaches` | `host` |
  | Otherwise (`run-time`, or a facts file before `connection-paths/4`: say to run a newer connection-paths) | `may-reach` | `run-time` |

* `through_set_up`: the reach's `through_set_up`;
* `via`: the reach's `chain` as `<Class>.<method>` steps (simple class names, no parameters), joined by ` > `.

Then the tests whose own code or the settings they load name a host (spring-boot.md, spring-xml.md, and in test code
`grep -rnE '(//|@|=)([A-Za-z0-9.-]+\.[A-Za-z]{2,}|[0-9]{1,3}(\.[0-9]{1,3}){3})' <test folders>`). A host is never
`localhost`, `127.0.0.1`, `::1`, `example.com`/`.org`/`.net` or their subdomains, one ending `.example`, `.test`,
`.invalid` or `.localhost`, an XML namespace, a schema location or a DTD address. Each gets a node by its host, if it
has none yet, and an entry with `found_by: test-code` or `test-settings`, `grade: reaches`, `reason: host`, and
`where`, the `path:line` naming it.

In `testing/tests.yaml`, replace `external_systems` in every entry and add an entry (`test`, `at` from the facts file's
`file:line`, made relative to the repo root, without a leading `./`) for a test that has none; never touch another
skill's keys. An entry left with only `test` and `at` goes. Set `found_by.draft-the-external-systems-list` (`version`, the
organisation profile's `toolkit.version` or `unreleased`; `commit`, `git rev-parse --short HEAD`). Entries sorted by
`test`; every string double-quoted. No file yet: start it as find-test-anti-patterns' step 3 says.

## 5. Check, then report

Check the files against their schemas if a validator is at hand. Then tell the person, briefly:

1. Each system, with its kind, address or where the address comes from, how many tests may reach it, and its proposed
   stand-in: production addresses first, then by node id.
   Where a system has a `shared_chain`, name the call nearest the system that every test goes through: one stand-in
   there covers them all.
2. What the Architecture Owner must confirm: every `proposed` connection, every address not known, every placeholder,
   every set of alternatives, and, without an organisation profile, every host not marked `never-reach`.
3. How much connection-paths resolved, and the dispatch points it didn't follow that a person should look at: the
   three with most implementations.
4. For the safety inventory: the `process` and `host-lookup` points, by method.
5. How many tests are graded each way, and each test graded `reaches`, with its system.
6. End with: "Measurement leaves out the tests that reach, and runs the rest once under the airgap agent, which
   confirms or clears each that may reach."
