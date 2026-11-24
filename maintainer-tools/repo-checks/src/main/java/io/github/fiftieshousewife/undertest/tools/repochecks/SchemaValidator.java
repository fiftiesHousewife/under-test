package io.github.fiftieshousewife.undertest.tools.repochecks;

import com.networknt.schema.Schema;
import com.networknt.schema.SchemaRegistry;
import com.networknt.schema.SpecificationVersion;
import java.nio.file.Path;
import java.util.List;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.dataformat.yaml.YAMLMapper;

// Checks a JSON or YAML file against a draft 2020-12 JSON Schema. A schema or file that can't be read is reported as
// a problem with the file, never thrown, so one bad file doesn't stop the other checks.
final class SchemaValidator {

    private final SchemaRegistry registry = SchemaRegistry.withDefaultDialect(SpecificationVersion.DRAFT_2020_12);
    private final JsonMapper json = new JsonMapper();
    private final YAMLMapper yaml = new YAMLMapper();

    List<Problem> validate(final Path file, final Path schemaFile) {
        final Schema schema;
        try {
            schema = registry.getSchema(RepoFiles.read(schemaFile));
        } catch (RuntimeException e) {
            return List.of(new Problem(file, "schema " + schemaFile.getFileName() + " can't be read: "
                    + e.getMessage()));
        }
        try {
            return schema.validate(parse(file)).stream().map(error -> new Problem(file, error.toString())).toList();
        } catch (RuntimeException e) {
            return List.of(new Problem(file, "can't be read: " + e.getMessage()));
        }
    }

    private JsonNode parse(final Path file) {
        final String text = RepoFiles.read(file);
        return String.valueOf(file.getFileName()).endsWith(".json") ? json.readTree(text) : yaml.readTree(text);
    }
}
