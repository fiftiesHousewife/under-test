package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import lombok.extern.slf4j.Slf4j;

/**
 * Entry point. {@code check <root>} fails on broken links, YAML files that don't match their schema, and out-of-date
 * decision indexes. {@code index <root>} rebuilds the decision indexes. {@code fix-links <root>} re-points links to
 * decision records at their current files, after renumbering or moving them.
 */
@Slf4j
public final class RepoChecks {

    static final List<String> DECISION_FOLDERS = List.of("docs/decisions", "decision-guides");

    private RepoChecks() {
    }

    public static void main(final String... args) {
        if (args.length != 2) {
            throw new IllegalArgumentException("usage: RepoChecks check|index|fix-links <repository root>");
        }
        final Path root = Path.of(args[1]);
        switch (args[0]) {
            case "check" -> failOn(check(root));
            case "index" -> DECISION_FOLDERS.forEach(folder -> new DecisionIndex().write(root.resolve(folder)));
            case "fix-links" -> log.info("{} file(s) relinked", new DecisionLinkFixer().fix(new RepoFiles(root)));
            default -> throw new IllegalArgumentException("unknown command: " + args[0]);
        }
    }

    static List<Problem> check(final Path root) {
        final RepoFiles files = new RepoFiles(root);
        final List<Problem> problems = new ArrayList<>(new LinkChecker().check(files));
        problems.addAll(new YamlSchemaChecker().check(files));
        for (final String folder : DECISION_FOLDERS) {
            if (!new DecisionIndex().isCurrent(root.resolve(folder))) {
                problems.add(new Problem(root.resolve(folder).resolve("README.md"),
                        "index is out of date; run ./gradlew buildDecisionIndexes"));
            }
        }
        return problems;
    }

    private static void failOn(final List<Problem> problems) {
        problems.forEach(problem -> log.error("{}", problem.toString().replace('\r', ' ').replace('\n', ' ')));
        if (!problems.isEmpty()) {
            throw new IllegalStateException(problems.size() + " problem(s) in the repository's own files");
        }
        log.info("Repository files are in order: links, YAML schemas and decision indexes.");
    }
}
