package io.github.fiftieshousewife.undertest.tools.repochecks;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class EvalFixturesTest {

    private static final String OBJECT_WITH_NAME = """
            {"$schema": "https://json-schema.org/draft/2020-12/schema", "type": "object",
             "required": ["name"], "properties": {"name": {"type": "string"}}}
            """;

    @TempDir
    Path root;

    @BeforeEach
    void writeSchema() throws IOException {
        Files.createDirectories(root.resolve("schema"));
        Files.writeString(root.resolve("schema/assessment.schema.json"), OBJECT_WITH_NAME);
    }

    private void writeFixture(final String evalCase, final String assessment) throws IOException {
        final Path testing = Files.createDirectories(root.resolve(EvalFixtures.EVALS).resolve(evalCase)
                .resolve("fixture/testing"));
        Files.writeString(testing.resolve("assessment.yaml"), assessment);
    }

    @Test
    void reportsAFixtureFileInTheWrongShape() throws IOException {
        writeFixture("a-skill/good-case", "name: a\n");
        writeFixture("a-skill/bad-case", "other: 1\n");

        assertThat(new EvalFixtures().check(root)).singleElement()
                .extracting(Problem::toString).asString().contains("bad-case");
    }

    @Test
    void skipsTheEvalResults() throws IOException {
        writeFixture("results/a-run", "other: 1\n");

        assertThat(new EvalFixtures().check(root)).isEmpty();
    }

    @Test
    void checksNothingWithoutEvals() {
        assertThat(new EvalFixtures().check(root)).isEmpty();
    }
}
