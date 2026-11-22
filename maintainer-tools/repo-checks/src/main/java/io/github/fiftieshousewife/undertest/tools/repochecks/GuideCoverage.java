package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;

/**
 * Every decision guide is linked from the journey page, which summarises them step by step; a new guide fails the
 * build until someone decides which step of the journey it belongs to. The link checker already catches guides
 * renamed or removed.
 */
public final class GuideCoverage {

    static final String GUIDES = "decision-guides";
    static final String JOURNEY = "docs/JOURNEY.md";

    public List<Problem> check(final Path root) {
        final Path guides = root.resolve(GUIDES);
        if (!Files.isDirectory(guides)) {
            return List.of();
        }
        final Path journey = root.resolve(JOURNEY);
        final String text = Files.isRegularFile(journey) ? read(journey) : "";
        return names(guides).stream()
                .filter(name -> !text.contains(GUIDES + "/" + name))
                .map(name -> new Problem(journey, "doesn't link the decision guide " + name
                        + "; add it to its step of the journey"))
                .toList();
    }

    private static List<String> names(final Path guides) {
        try (Stream<Path> files = Files.list(guides)) {
            return files.map(file -> String.valueOf(file.getFileName()))
                    .filter(name -> name.matches("\\d{4}-.+\\.md"))
                    .sorted()
                    .toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    private static String read(final Path file) {
        try {
            return Files.readString(file);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
