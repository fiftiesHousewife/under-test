# Tests that load Spring XML

Read this when the code or the tests load a Spring XML context in any of the ways below. Old repos do it in several,
often more than one at once.

## How a test loads XML

| Way | Example |
|---|---|
| `@ContextConfiguration` or `@ImportResource` naming XML, on the class, a superclass in the repo, or an annotation of the repo's own | `@ContextConfiguration(locations = "classpath:base-test-context.xml")` on an abstract base class |
| Spring's JUnit 3 base classes, listing the XML in a method | `extends AbstractDependencyInjectionSpringContextTests` (or `AbstractTransactionalSpringContextTests`, `AbstractJpaTests`, ...) with `getConfigLocations()` or `getConfigPaths()`. These classes' `test...()` methods run, with no `@Test` |
| The test builds the context itself, in the test or a set-up method | `new ClassPathXmlApplicationContext("archive-context.xml")`, `FileSystemXmlApplicationContext`, `GenericXmlApplicationContext` |

A `classpath:` path is under test or main resources; `classpath*:` with a pattern means every matching file.

## What the XML loads in turn

Follow every one, to any depth: `<import resource=...>`; property files from `<context:property-placeholder
location=...>`, a `PropertyPlaceholderConfigurer` or `PropertySourcesPlaceholderConfigurer` bean's `location` or
`locations`, and `<util:properties location=...>`. A later property file overrides an earlier one.

## Which values count

* A placeholder `${name}` takes its value from the property files; with none, from its default after `:`, as in
  `${reports.url:https://reports.corp/api}`. A placeholder neither sets is unknown: say so in the report.
* `<beans profile="...">` blocks count only for an active profile: `@ActiveProfiles` on the class or a superclass, or
  `spring.profiles.active` in a property file. Blocks outside any profile always count.
* A host in a value the test's context loads gives every test in the class a `connections` entry for that system,
  `found_by: test-settings`, the `kind` of system (`jdbc:` a database, `http`/`https` a service, `ldap`/`ldaps` a
  directory, `smtp` or a mail sender a mail server, `tcp`, `amqp` or a broker a queue, `\\` or `smb` a file share), and
  `where` at the line naming it. The same host in the application's own contexts, in main resources, is the address of
  the connection the code opens with that bean.
* `<jee:jndi-lookup jndi-name=...>` (or a `JndiObjectFactoryBean`) needs a real container's resource: its address is
  unknown before the code runs, so its node gets `address-from: "JNDI name <name>"`, the `kind` from the name
  (`jdbc/...` a database, `mail/...` mail, `jms/...` a queue), and a test that loads it a `connections` entry with
  `where` at its line.
* An XML namespace, schema location or DTD address is never a host.

```bash
grep -rnE '@(ContextConfiguration|ImportResource)|getConfig(Locations|Paths)|(ClassPath|FileSystem|Generic)XmlApplicationContext' --include='*.java' <test folders>
grep -nE '<import |property-placeholder|PlaceholderConfigurer|util:properties|location|<beans profile|jndi-lookup|JndiObjectFactoryBean' <each context file found>
grep -nE '(//|@|=)([A-Za-z0-9.-]+\.[A-Za-z]{2,}|[0-9]{1,3}(\.[0-9]{1,3}){3})|\$\{[^}]*:' <each context and property file found>
```
