package io.github.fiftieshousewife.undertest.tools.repochecks;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class SchemaFilesCheckerTest {

    private static final String GOOD = """
            {"$schema": "https://json-schema.org/draft/2020-12/schema", "type": "object",
             "properties": {"name": {"type": "string"}}}
            """;

    @TempDir
    Path root;

    private List<Problem> check(final String schema) throws IOException {
        Files.createDirectories(root.resolve(SchemaFilesChecker.FOLDER));
        Files.writeString(root.resolve("schema/thing.schema.json"), schema);
        return new SchemaFilesChecker().check(root);
    }

    @Test
    void acceptsAValidSchema() throws IOException {
        assertThat(check(GOOD)).isEmpty();
    }

    @Test
    void reportsAFileFilledWithCopiesOfOneBlock() throws IOException {
        assertThat(check("{\"type\": \"object\"},\n{\"type\": \"object\"}\n")).singleElement()
                .extracting(Problem::toString).asString().contains("thing.schema.json");
    }

    @Test
    void reportsAFileThatIsNotJson() throws IOException {
        assertThat(check("{\"type\": ")).singleElement()
                .extracting(Problem::message).asString().startsWith("not a draft 2020-12 schema");
    }

    @Test
    void reportsASchemaThatBreaksTheMetaSchema() throws IOException {
        assertThat(check("{\"type\": 5, \"required\": \"name\"}")).isNotEmpty();
    }

    @Test
    void checksNothingWithoutASchemaFolder() {
        assertThat(new SchemaFilesChecker().check(root)).isEmpty();
    }
}
