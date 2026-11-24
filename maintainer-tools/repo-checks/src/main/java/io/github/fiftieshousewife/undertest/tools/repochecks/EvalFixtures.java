package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;

/**
 * Checks the {@code testing/} files in every skill eval case's fixture ({@code .github/evals/<skill>/<case>/fixture/})
 * against the toolkit's schemas, the same way the evals check what a skill writes, so a fixture can't drift out of
 * the shape the skills are asked to read.
 */
public final class EvalFixtures {

    static final String EVALS = ".github/evals";

    public List<Problem> check(final Path root) {
        final OutputValidator validator = new OutputValidator(root);
        return fixtures(root.resolve(EVALS)).stream().flatMap(fixture -> validator.validate(fixture).stream()).toList();
    }

    private static List<Path> fixtures(final Path evals) {
        if (!Files.isDirectory(evals)) {
            return List.of();
        }
        try (Stream<Path> paths = Files.walk(evals, 3)) {
            return paths.filter(path -> evals.relativize(path).getNameCount() == 3)
                    .filter(path -> "fixture".equals(String.valueOf(path.getFileName())))
                    .filter(path -> !path.startsWith(evals.resolve("results")))
                    .filter(Files::isDirectory)
                    .sorted()
                    .toList();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
