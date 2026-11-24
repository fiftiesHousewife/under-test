package io.github.fiftieshousewife.undertest.tools.repochecks;

import com.networknt.schema.Error;
import com.networknt.schema.Schema;
import com.networknt.schema.SchemaLocation;
import com.networknt.schema.SchemaRegistry;
import com.networknt.schema.SpecificationVersion;
import com.networknt.schema.dialect.DialectId;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;
import tools.jackson.databind.DeserializationFeature;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

/**
 * Checks that every schema in {@code schema/} is one JSON document, valid against the draft 2020-12 meta-schema, that
 * compiles: a schema that doesn't would otherwise pass every file checked against it, or fail them all.
 */
public final class SchemaFilesChecker {

    static final String FOLDER = "schema";

    private final SchemaRegistry registry = SchemaRegistry.withDefaultDialect(SpecificationVersion.DRAFT_2020_12);
    private final JsonMapper json = JsonMapper.builder().enable(DeserializationFeature.FAIL_ON_TRAILING_TOKENS).build();

    public List<Problem> check(final Path root) {
        final Path folder = root.resolve(FOLDER);
        if (!Files.isDirectory(folder)) {
            return List.of();
        }
        final Schema metaSchema = registry.getSchema(SchemaLocation.of(DialectId.DRAFT_2020_12));
        return schemaFiles(folder).stream().flatMap(file -> checkFile(file, metaSchema).stream()).toList();
    }

    private List<Problem> checkFile(final Path file, final Schema metaSchema) {
        try {
            final JsonNode schema = json.readTree(RepoFiles.read(file));
            final List<Error> errors = metaSchema.validate(schema);
            if (errors.isEmpty()) {
                registry.getSchema(schema).initializeValidators();
            }
            return errors.stream().map(error -> new Problem(file, "not a draft 2020-12 schema: " + error)).toList();
        } catch (RuntimeException e) {
            return List.of(new Problem(file, "not a draft 2020-12 schema: " + e.getMessage()));
        }
    }

    private static List<Path> schemaFiles(final Path folder) {
        try (Stream<Path> files = Files.list(folder)) {
            return files.filter(file -> String.valueOf(file.getFileName()).endsWith(".json")).sorted().toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
