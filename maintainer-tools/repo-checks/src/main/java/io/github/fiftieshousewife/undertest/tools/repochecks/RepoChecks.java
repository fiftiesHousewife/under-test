package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import lombok.extern.slf4j.Slf4j;

/**
 * Entry point. {@code check <root>} fails on broken links, YAML files that don't match their schema, and out-of-date
 * decision indexes and technique rules. {@code index <root>} rebuilds the decision indexes and
 * {@code techniques/rules.json}. {@code fix-links <root>} re-points links to
 * decision records at their current files, after renumbering or moving them. {@code validate-output <root> <report>
 * <workspace>...} checks the files skills wrote in each workspace against the schemas in {@code <root>}, and writes
 * one line per workspace to {@code <report>}: the workspace, its number of problems, and the first.
 */
@Slf4j
public final class RepoChecks {

    static final List<String> DECISION_FOLDERS = List.of("docs/decisions", "decision-guides");

    private RepoChecks() {
    }

    public static void main(final String... args) {
        if (args.length >= 3 && "validate-output".equals(args[0])) {
            writeOutputReport(Path.of(args[1]), Path.of(args[2]), List.of(args).subList(3, args.length));
            return;
        }
        if (args.length != 2) {
            throw new IllegalArgumentException("usage: RepoChecks check|index|fix-links <repository root>, or"
                    + " RepoChecks validate-output <repository root> <report file> <workspace>...");
        }
        run(args[0], Path.of(args[1]));
    }

    private static void run(final String command, final Path root) {
        switch (command) {
            case "check" -> failOn(check(root));
            case "index" -> index(root);
            case "fix-links" -> log.info("{} file(s) relinked", new DecisionLinkFixer().fix(new RepoFiles(root)));
            default -> throw new IllegalArgumentException("unknown command: " + command);
        }
    }

    static List<Problem> check(final Path root) {
        final RepoFiles files = new RepoFiles(root);
        final List<Problem> problems = new ArrayList<>(new LinkChecker().check(files));
        problems.addAll(new YamlSchemaChecker().check(files));
        problems.addAll(new ConnectionListChecker().check(files));
        problems.addAll(new GuideCoverage().check(root));
        for (final Path folder : decisionFolders(root)) {
            if (!new DecisionIndex().isCurrent(folder)) {
                problems.add(new Problem(folder.resolve("README.md"),
                        "index is out of date; run ./gradlew buildDecisionIndexes"));
            }
        }
        if (TechniqueRules.applies(root) && !new TechniqueRules().isCurrent(root)) {
            problems.add(new Problem(root.resolve(TechniqueRules.FILE),
                    "out of date with the technique files; run ./gradlew buildDecisionIndexes"));
        }
        return problems;
    }

    static void index(final Path root) {
        decisionFolders(root).forEach(folder -> new DecisionIndex().write(folder));
        if (TechniqueRules.applies(root)) {
            new TechniqueRules().write(root);
        }
    }

    static void writeOutputReport(final Path root, final Path report, final List<String> workspaces) {
        final OutputValidator validator = new OutputValidator(root);
        final StringBuilder lines = new StringBuilder();
        for (final String workspace : workspaces) {
            final List<Problem> problems = validator.validate(Path.of(workspace));
            final String first = problems.isEmpty() ? ""
                    : problems.get(0).toString().replace('\t', ' ').replace('\n', ' ');
            lines.append(workspace).append('\t').append(problems.size()).append('\t').append(first).append('\n');
        }
        try {
            Files.writeString(report, lines.toString());
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    // The decision folders this repo has: not every repo that reuses these checks has decision guides.
    static List<Path> decisionFolders(final Path root) {
        return DECISION_FOLDERS.stream().map(root::resolve).filter(Files::isDirectory).toList();
    }

    private static void failOn(final List<Problem> problems) {
        problems.forEach(problem -> log.error("{}", problem.toString().replace('\r', ' ').replace('\n', ' ')));
        if (!problems.isEmpty()) {
            throw new IllegalStateException(problems.size() + " problem(s) in the repository's own files");
        }
        log.info("Repository files are in order: links, YAML schemas, decision indexes, and every decision guide"
                + " linked from the journey page.");
    }
}
