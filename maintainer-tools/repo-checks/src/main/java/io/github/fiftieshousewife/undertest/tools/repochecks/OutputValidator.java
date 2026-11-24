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
import java.util.Map;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.dataformat.yaml.YAMLMapper;

/**
 * Checks the files a skill wrote in a repo's {@code testing/} folder against the toolkit's own schemas, whatever
 * schema line the files carry: the skill evals use it on each run's workspace, so a run that writes a file in the
 * wrong shape fails even when every pattern check passes. Files that aren't there are not checked.
 */
public final class OutputValidator {

    private static final Map<String, String> SCHEMAS = Map.of(
            "testing/assessment.yaml", "schema/assessment.schema.json",
            "testing/sources.yaml", "schema/source-list.schema.json",
            "testing/external-systems.calm.json", "schema/external-systems-list.schema.json",
            "testing/external-calls.json", "schema/external-calls.schema.json",
            "testing/tests.yaml", "schema/tests.schema.json");

    private final Path toolkit;
    private final SchemaRegistry registry = SchemaRegistry.withDefaultDialect(SpecificationVersion.DRAFT_2020_12);

    public OutputValidator(final Path toolkit) {
        this.toolkit = toolkit;
    }

    /** The problems in one workspace's files, with each file named relative to the workspace. */
    public List<Problem> validate(final Path workspace) {
        final List<Problem> problems = new ArrayList<>();
        SCHEMAS.entrySet().stream().sorted(Map.Entry.comparingByKey()).forEach(entry -> {
            final Path file = workspace.resolve(entry.getKey());
            if (Files.isRegularFile(file)) {
                problems.addAll(validate(file, toolkit.resolve(entry.getValue())));
            }
        });
        return problems;
    }

    private List<Problem> validate(final Path file, final Path schemaFile) {
        final Schema schema = registry.getSchema(read(schemaFile));
        final List<Problem> problems = new ArrayList<>();
        try {
            for (final Error error : schema.validate(parse(file))) {
                problems.add(new Problem(file, error.toString()));
            }
        } catch (RuntimeException e) {
            problems.add(new Problem(file, "can't be read: " + e.getMessage()));
        }
        return problems;
    }

    private static JsonNode parse(final Path file) {
        final String text = read(file);
        return file.toString().endsWith(".json") ? new JsonMapper().readTree(text) : new YAMLMapper().readTree(text);
    }

    private static String read(final Path file) {
        try {
            return Files.readString(file);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
