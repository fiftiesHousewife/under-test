# Tests that load Spring XML

Read this when the code or the tests load a Spring XML context in any of the ways below. Old repos do it in several,
often more than one at once.

## What under-test-external-calls already does

It reaches an XML file's beans from a test whose class, or a superclass in the repo's test source, has
`@ContextConfiguration`, `@SpringJUnitConfig` or `@ImportResource` naming the file, and from code that does
`new ClassPathXmlApplicationContext("…xml")` (or the `FileSystem` or `Generic` variant), and follows each
`<import resource=...>` to the imported file's beans. A chain through the file has a
step `org.springframework.context.ApplicationContext#<xml path>()`, the file's path on the classpath (`spring/app.xml`;
a wildcard location stands for each file it matches). A bean inside a `<beans profile="...">` block has one more
step after it, `ApplicationContext#<profile dev,qa of <file>>()`: the chain goes through it only for a test whose
active profiles turn the block on, so no rule here needs to check profiles again. A bean whose class matches a connection rule
is a point, and the first of its `url`, `jdbcUrl`, `URL`, `serverURL`, `brokerURL`, `providerUrl`, `uri`, `baseUrl`,
`serviceUrl`, `connectionString`, `host` or `serverName` properties is its address. A `${name}` in it becomes the
setting `name`, looked up in all the repo's settings files, the test's own first. Take all of that from the facts file.

## What you settle by hand

Only these; for each, find the context files with the searches below.

| Case | What to do |
|---|---|
| The XML is named by an annotation of the repo's own that carries `@ContextConfiguration` | Treat the classes using that annotation as loading the file |
| Spring's JUnit 3 base classes: `extends AbstractDependencyInjectionSpringContextTests` (or `AbstractTransactionalSpringContextTests`, `AbstractJpaTests`, ...) with `getConfigLocations()` or `getConfigPaths()` | These classes' `test...()` methods run, with no `@Test`: treat them as loading the files the method lists |
| A location with `*`, every `classpath*:` one included | Every matching file, under test or main resources |
| Two files with the same name in different folders | The tool can't tell them apart: say which one the test loads |
| A placeholder `${name:default}` no settings file sets | Its value is the default after `:`. A placeholder that neither a file nor a default sets is unknown: say so in the report |
| A placeholder set in a specific file (`<context:property-placeholder location=...>`, a `PropertyPlaceholderConfigurer` or `PropertySourcesPlaceholderConfigurer` bean's `location` or `locations`, `<util:properties location=...>`) | Its value comes from that file, a later file overriding an earlier one, where it differs from what the tool found |
| `<beans profile="...">` | Its beans count only for an active profile: `@ActiveProfiles` on the class or a superclass, or `spring.profiles.active` in a property file. Blocks outside any profile always count. Drop a point the tool took from an inactive block |
| `<jee:jndi-lookup jndi-name=...>` or a `JndiObjectFactoryBean` | Needs a real container's resource: its node gets `address-from: "JNDI name <name>"`, the `kind` from the name (`jdbc/...` a database, `mail/...` mail, `jms/...` a queue), and a test that loads it an `external_systems` entry with `found_by: test-settings`, `grade: may-reach`, `reason: run-time` and `where` at its line |

A host you find this way gives every test in the class an `external_systems` entry for that system,
`found_by: test-settings`, `grade: reaches`, `reason: host`, the `kind` of system (`jdbc:` a database, `http`/`https`
`http`, `ldap`/`ldaps` a directory, `smtp` or a mail sender `mail`, `tcp`, `amqp` or a broker a queue, `\\` or `smb`
a `file-share`), and `where` at the line naming it. The host gets a node and a relationship, with `found-by`
`test-settings`, as [SKILL.md](SKILL.md)'s step 4 says for a host the tests name. An XML namespace, schema location or
DTD address is never a host.

```bash
grep -rnE 'getConfig(Locations|Paths)|classpath\*:|@interface' --include='*.java' <test folders>
grep -nE 'property-placeholder|PlaceholderConfigurer|util:properties|location|<beans profile|jndi-lookup|JndiObjectFactoryBean' <each context file found>
grep -nE '\$\{[^}]*:' <each context and property file found>
```
