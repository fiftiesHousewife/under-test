package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Checks every YAML file against the JSON Schema named on its first line
 * ({@code # yaml-language-server: $schema=...}). A YAML file without that line is a problem: every YAML format here
 * must have a schema. Schemas on the web (for example the GitHub workflow schema) are not fetched; only the line is
 * checked.
 */
public final class YamlSchemaChecker {

    private static final Pattern SCHEMA_LINE = Pattern.compile("^#\\s*yaml-language-server:\\s*\\$schema=(\\S+)");

    private final SchemaValidator validator = new SchemaValidator();

    public List<Problem> check(final RepoFiles files) {
        final List<Problem> problems = new ArrayList<>();
        for (final Path file : files.withExtension(".yaml", ".yml")) {
            problems.addAll(checkFile(file));
        }
        return problems;
    }

    List<Problem> checkFile(final Path file) {
        final String text = RepoFiles.read(file);
        final Optional<String> schemaReference = schemaReference(text);
        if (schemaReference.isEmpty()) {
            return List.of(new Problem(file, "no schema: the first line must be # yaml-language-server: $schema=..."));
        }
        if (schemaReference.get().contains("://")) {
            return List.of();
        }
        final Path schemaFile = file.resolveSibling(schemaReference.get()).normalize();
        if (!Files.exists(schemaFile)) {
            return List.of(new Problem(file, "schema not found: " + schemaReference.get()));
        }
        return validator.validate(file, schemaFile);
    }

    static Optional<String> schemaReference(final String text) {
        final String firstLine = text.lines().findFirst().orElse("");
        final Matcher matcher = SCHEMA_LINE.matcher(firstLine);
        return matcher.find() ? Optional.of(matcher.group(1)) : Optional.empty();
    }
}
