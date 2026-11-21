package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

/** The repository's own files that the checks look at, skipping build output and working notes. */
public record RepoFiles(Path root) {

    private static final Set<String> SKIPPED = Set.of("build", ".gradle", ".git", ".idea", "node_modules",
            "research_notes", "reports", "apm_modules", ".kotlin");

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

    private boolean notSkipped(final Path path) {
        final Path relative = root.relativize(path);
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
