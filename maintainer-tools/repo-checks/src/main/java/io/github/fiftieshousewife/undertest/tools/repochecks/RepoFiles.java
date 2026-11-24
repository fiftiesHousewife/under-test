package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

/**
 * The repository's own files that the checks look at, skipping build output, working notes and installed AI assistant
 * skills ({@code .claude/}: external skills installed by APM, and links to this repo's own skills, which are checked
 * where they live, in {@code .github/skills/}), and the skill evals' results ({@code .github/evals/results/}: each
 * run's output, kept as it was written, not committed).
 */
public record RepoFiles(Path root) {

    private static final Set<String> SKIPPED = Set.of("build", ".gradle", ".git", ".idea", "node_modules",
            "research_notes", "reports", "apm_modules", ".kotlin", ".claude");
    private static final Path EVAL_RESULTS = Path.of(".github", "evals", "results");

    public List<Path> withExtension(final String... extensions) {
        try (Stream<Path> paths = Files.walk(root)) {
            return paths.filter(Files::isRegularFile)
                    .filter(this::notSkipped)
                    .filter(path -> hasExtension(path, extensions))
                    .sorted()
                    .toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    /** The text of a file, as UTF-8. */
    public static String read(final Path file) {
        try {
            return Files.readString(file);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    /** Writes a file's text, as UTF-8. */
    public static void write(final Path file, final String text) {
        try {
            Files.writeString(file, text);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    /** A relative path written with forward slashes, as links and YAML paths are, whatever the platform. */
    public static String withSlashes(final Path path) {
        return path.toString().replace('\\', '/');
    }

    private boolean notSkipped(final Path path) {
        final Path relative = root.relativize(path);
        if (relative.startsWith(EVAL_RESULTS)) {
            return false;
        }
        for (final Path part : relative) {
            if (SKIPPED.contains(part.toString())) {
                return false;
            }
        }
        return true;
    }

    private static boolean hasExtension(final Path path, final String... extensions) {
        final String name = String.valueOf(path.getFileName());
        for (final String extension : extensions) {
            if (name.endsWith(extension)) {
                return true;
            }
        }
        return false;
    }
}
