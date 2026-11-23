# Tests that load Spring XML

Read this when a test class names an XML file in `@ContextConfiguration` or `@ImportResource`.

* A file the class loads includes that Spring XML context, and the files it loads in turn: each
  `<import resource=...>`, and each property placeholder's `location` (`<context:property-placeholder location=...>`
  or a `PropertySourcesPlaceholderConfigurer` bean's locations). Follow them all; a `classpath:` path is under the
  test or main resources.
* A host named in any of them makes every test in the class count as `reaches-shared-system`, with `through:
  spring-xml` and `where` at the line naming the host.
* An XML namespace, schema location or DTD address is never a host, here as in any XML file.

```bash
grep -rnE '@(ContextConfiguration|ImportResource)' --include='*.java' <test folders>
grep -nE '<import |property-placeholder|location' <each context file found>
```
