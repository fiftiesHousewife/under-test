package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.databind.node.ObjectNode;
import tools.jackson.dataformat.yaml.YAMLMapper;

/**
 * Keeps {@code techniques/rules.json} in step with the {@code techniques/<id>/technique.yaml} files: one technique per
 * line, with only the fields the choose-techniques skill reads, so a skill reads every rule in one small file.
 */
public final class TechniqueRules {

    public static final String FILE = "techniques/rules.json";

    static final List<String> FIELDS = List.of("id", "workstream", "evidence_for_maturity_levels",
            "application_types", "needed_when", "possible_when", "reject_or_defer_when", "precondition_checks",
            "fallback", "test_stand_in_approach");

    private static final String NOTE = "Generated from techniques/<id>/technique.yaml by maintainer-tools/repo-checks"
            + " (./gradlew buildDecisionIndexes), with only the fields the choose-techniques skill reads. Don't edit.";

    private final YAMLMapper yaml = new YAMLMapper();
    private final JsonMapper json = new JsonMapper();

    public String render(final Path root) {
        final String techniques = techniqueFiles(root).stream()
                .map(this::compact)
                .map(json::writeValueAsString)
                .collect(Collectors.joining(",\n"));
        return "{\"generated\": " + json.writeValueAsString(NOTE) + ",\n\"techniques\": [\n" + techniques + "\n]}\n";
    }

    public void write(final Path root) {
        RepoFiles.write(root.resolve(FILE), render(root));
    }

    public boolean isCurrent(final Path root) {
        final Path file = root.resolve(FILE);
        return Files.isRegularFile(file) && RepoFiles.read(file).equals(render(root));
    }

    // True where the repo has technique rules: not every repo that reuses these checks does.
    static boolean applies(final Path root) {
        return Files.isDirectory(root.resolve("techniques"));
    }

    private ObjectNode compact(final Path file) {
        final JsonNode technique = yaml.readTree(RepoFiles.read(file));
        final ObjectNode kept = json.createObjectNode();
        FIELDS.stream().filter(technique::has).forEach(field -> kept.set(field, technique.get(field)));
        return kept;
    }

    private static List<Path> techniqueFiles(final Path root) {
        try (Stream<Path> folders = Files.list(root.resolve("techniques"))) {
            return folders.map(folder -> folder.resolve("technique.yaml"))
                    .filter(Files::isRegularFile)
                    .sorted()
                    .toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
