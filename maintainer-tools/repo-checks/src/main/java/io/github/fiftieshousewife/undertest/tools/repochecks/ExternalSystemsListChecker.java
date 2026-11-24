package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * Checks every external systems list ({@code *.calm.json}) against the toolkit's schema for it. An external systems
 * list names CALM's own schema in its {@code $schema} field, so it can't name the toolkit's the way a YAML file does.
 */
public final class ExternalSystemsListChecker {

    static final String SCHEMA = "schema/external-systems-list.schema.json";

    private final SchemaValidator validator = new SchemaValidator();

    public List<Problem> check(final RepoFiles files) {
        final List<Path> lists = files.withExtension(".calm.json");
        if (lists.isEmpty()) {
            return List.of();
        }
        final Path schemaFile = files.root().resolve(SCHEMA);
        if (!Files.exists(schemaFile)) {
            return List.of(new Problem(lists.get(0), "schema not found: " + SCHEMA));
        }
        return lists.stream().flatMap(list -> validator.validate(list, schemaFile).stream()).toList();
    }
}
