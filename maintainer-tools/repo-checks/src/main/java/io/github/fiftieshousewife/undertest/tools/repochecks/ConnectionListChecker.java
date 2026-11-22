package io.github.fiftieshousewife.undertest.tools.repochecks;

import com.networknt.schema.Error;
import com.networknt.schema.Schema;
import com.networknt.schema.SchemaRegistry;
import com.networknt.schema.SpecificationVersion;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import tools.jackson.databind.json.JsonMapper;

/**
 * Checks every connection list ({@code *.calm.json}) against the toolkit's connection-list schema. A connection list
 * names CALM's own schema in its {@code $schema} field, so it can't name the toolkit's the way a YAML file does.
 */
public final class ConnectionListChecker {

    static final String SCHEMA = "schema/connection-list.schema.json";

    private final JsonMapper json = new JsonMapper();
    private final SchemaRegistry registry = SchemaRegistry.withDefaultDialect(SpecificationVersion.DRAFT_2020_12);

    public List<Problem> check(final RepoFiles files) {
        final List<Path> lists = files.withExtension(".calm.json");
        if (lists.isEmpty()) {
            return List.of();
        }
        final Path schemaFile = files.root().resolve(SCHEMA);
        if (!Files.exists(schemaFile)) {
            return List.of(new Problem(lists.get(0), "schema not found: " + SCHEMA));
        }
        final Schema schema = registry.getSchema(read(schemaFile));
        final List<Problem> problems = new ArrayList<>();
        for (final Path list : lists) {
            for (final Error error : schema.validate(json.readTree(read(list)))) {
                problems.add(new Problem(list, error.toString()));
            }
        }
        return problems;
    }

    private static String read(final Path file) {
        try {
            return Files.readString(file);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
