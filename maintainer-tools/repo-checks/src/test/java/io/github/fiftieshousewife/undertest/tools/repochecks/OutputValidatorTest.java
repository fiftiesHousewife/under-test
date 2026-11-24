package io.github.fiftieshousewife.undertest.tools.repochecks;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class OutputValidatorTest {

    private static final String OBJECT_WITH_NAME = """
            {"$schema": "https://json-schema.org/draft/2020-12/schema", "type": "object",
             "required": ["name"], "properties": {"name": {"type": "string"}}, "additionalProperties": false}
            """;

    @TempDir
    Path toolkit;

    @TempDir
    Path workspace;

    @BeforeEach
    void writeSchemas() throws IOException {
        final Path schemas = Files.createDirectories(toolkit.resolve("schema"));
        for (final String name : new String[] {"assessment", "source-list", "external-systems-list"}) {
            Files.writeString(schemas.resolve(name + ".schema.json"), OBJECT_WITH_NAME);
        }
        Files.createDirectories(workspace.resolve("testing"));
    }

    @Test
    void passesFilesThatMatchTheirSchemasWhateverTheirSchemaLine() throws IOException {
        Files.writeString(workspace.resolve("testing/assessment.yaml"), "# yaml-language-server: $schema=x\nname: a\n");
        Files.writeString(workspace.resolve("testing/external-systems.calm.json"), "{\"name\": \"a\"}");

        assertThat(new OutputValidator(toolkit).validate(workspace)).isEmpty();
    }

    @Test
    void reportsEachFileInTheWrongShape() throws IOException {
        Files.writeString(workspace.resolve("testing/assessment.yaml"), "name: a\nextra: 1\n");
        Files.writeString(workspace.resolve("testing/sources.yaml"), "other: 1\n");

        assertThat(new OutputValidator(toolkit).validate(workspace)).hasSize(3);
    }

    @Test
    void reportsAFileThatCantBeRead() throws IOException {
        Files.writeString(workspace.resolve("testing/external-systems.calm.json"), "{not json");

        assertThat(new OutputValidator(toolkit).validate(workspace)).singleElement()
                .extracting(Problem::message).asString().startsWith("can't be read");
    }

    @Test
    void checksNothingInAnEmptyWorkspace() {
        assertThat(new OutputValidator(toolkit).validate(workspace)).isEmpty();
    }

    @Test
    void writesOneReportLinePerWorkspace() throws IOException {
        Files.writeString(workspace.resolve("testing/assessment.yaml"), "extra: 1\n");
        final Path report = toolkit.resolve("report.tsv");

        RepoChecks.main("validate-output", toolkit.toString(), report.toString(), workspace.toString());

        final String line = Files.readString(report);
        assertAll(
                () -> assertThat(line).startsWith(workspace + "\t2\t"),
                () -> assertThat(line).endsWith("\n"));
    }
}
