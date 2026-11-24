package io.github.fiftieshousewife.undertest.tools.repochecks;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class ExternalSystemsListCheckerTest {

    private static final String SCHEMA = """
            {"$schema": "https://json-schema.org/draft/2020-12/schema", "type": "object",
             "required": ["nodes"], "properties": {"nodes": {"type": "array", "minItems": 1}}}
            """;

    @TempDir
    Path root;

    private List<Problem> check(final String list, final boolean withSchema) throws IOException {
        if (withSchema) {
            Files.createDirectories(root.resolve("schema"));
            Files.writeString(root.resolve(ExternalSystemsListChecker.SCHEMA), SCHEMA);
        }
        Files.createDirectories(root.resolve("testing"));
        Files.writeString(root.resolve("testing/external-systems.calm.json"), list);
        return new ExternalSystemsListChecker().check(new RepoFiles(root));
    }

    @Test
    void acceptsAConnectionListThatMatchesTheSchema() throws IOException {
        assertThat(check("{\"nodes\": [{}]}", true)).isEmpty();
    }

    @Test
    void reportsAConnectionListThatBreaksTheSchema() throws IOException {
        final List<Problem> problems = check("{\"nodes\": []}", true);
        assertAll(
                () -> assertThat(problems).hasSize(1),
                () -> assertThat(problems.get(0).toString()).contains("external-systems.calm.json"));
    }

    @Test
    void reportsAMissingSchema() throws IOException {
        assertThat(check("{\"nodes\": [{}]}", false)).singleElement()
                .satisfies(problem -> assertThat(problem.toString()).contains("schema not found"));
    }

    @Test
    void ignoresARepoWithNoConnectionList() {
        assertThat(new ExternalSystemsListChecker().check(new RepoFiles(root))).isEmpty();
    }
}
