# Tests that start a Spring Boot application

Read this when the build uses Spring Boot (`org.springframework.boot` in a build file). A test can reach an external
system through settings it never names: Spring Boot loads them for it. The same settings give the addresses of the
connections the code opens.

## Which tests start an application, and how much of it

Look at the test class, its superclasses in the repo, and any annotation of the repo's own that carries one of these.

| Annotation | What it starts |
|---|---|
| `@SpringBootTest` | Everything the application configures: every connection in the settings below |
| `@DataJpaTest`, `@JdbcTest`, `@DataJdbcTest` | Only the database, and Spring swaps it for an embedded one, unless the class also has `@AutoConfigureTestDatabase(replace = NONE)` (or `Replace.NONE`); then the real database in the settings |
| `@DataMongoTest`, `@DataRedisTest`, `@DataLdapTest` | Only that store; embedded where the build has an embedded one, otherwise the settings' address |
| `@WebMvcTest`, `@WebFluxTest`, `@JsonTest`, `@RestClientTest` | No connections: services they need are mocks |

## Which settings load, and which wins

From the lowest to the highest; a later source overrides the same setting in an earlier one:

1. `application.properties`, `application.yml` or `application.yaml` in main resources; a file of the same name in test
   resources hides the main one entirely.
2. `application-<profile>.*`, in main then test resources, for each active profile. A profile is active through
   `@ActiveProfiles` on the class or a superclass, or `spring.profiles.active` in the settings above.
3. `@TestPropertySource(locations = ...)`, then its `properties = ...`.
4. `@SpringBootTest(properties = ...)`.

## Which settings are connections

Any setting whose winning value names a host: `spring.datasource.url`, `spring.mail.host`, `spring.ldap.urls`,
`spring.rabbitmq.host`, `spring.activemq.broker-url`, `spring.kafka.bootstrap-servers`, `spring.data.mongodb.uri`,
`spring.redis.host`, and any other setting whose value holds a host, such as `*.url`, `*.base-url`, `*.host`. A value
of `localhost`, `127.0.0.1`, an in-memory database (`jdbc:h2:mem:`, `jdbc:hsqldb:mem:`, `jdbc:derby:memory:`) or an
excluded example domain is not external.

The winning value of a connection setting is that system's address: its node's `addresses`, and the `setting` of its
relationship. A test that starts an application whose winning settings name an external host gets a `connections`
entry for that system, `found_by: test-settings`, the `kind` from the setting (`datasource` a database, `mail` mail,
`ldap` a directory, `rabbitmq`, `activemq` or `kafka` a queue, otherwise from the address's scheme), and `where` at the
line of the winning setting. The same settings, in main resources and the default profile, are what the application
itself connects to.

```bash
grep -rnE '@(SpringBootTest|DataJpaTest|JdbcTest|DataJdbcTest|DataMongoTest|DataRedisTest|DataLdapTest|WebMvcTest|WebFluxTest|AutoConfigureTestDatabase|ActiveProfiles|TestPropertySource)' --include='*.java' <test folders>
find . -path '*/src/*/resources/*' -name 'application*.properties' -o -path '*/src/*/resources/*' -name 'application*.y*ml' | grep -v '/build/'
grep -nE '(//|@|=)([A-Za-z0-9.-]+\.[A-Za-z]{2,}|[0-9]{1,3}(\.[0-9]{1,3}){3})|bootstrap-servers|\.host *[=:]' <each settings file found>
```
