package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * Keeps each decision record's line {@code * Later decisions that build on this: ...} in step with the other records'
 * {@code * Builds on: ...} lines, across docs/decisions/ and decision-guides/: a record in one folder may build on one
 * in the other. The line links each later record by its title, in number order, or says "none yet". Nothing else in a
 * record is changed, and a record without the line is left alone.
 */
public final class DecisionBackLinks {

    static final String LATER = "* Later decisions that build on this: ";

    private static final Pattern BUILDS_ON = Pattern.compile("(?m)^\\* Builds on: (.*)$");
    private static final Pattern LATER_LINE = Pattern.compile("(?m)^" + Pattern.quote(LATER) + ".*$");
    private static final Pattern LINK = Pattern.compile("\\]\\(([^)#\\s]+)");
    private static final Comparator<Path> BY_NUMBER =
            Comparator.comparing((Path file) -> String.valueOf(file.getFileName())).thenComparing(Path::toString);

    /** The new text of every record whose later-decisions line is out of date, by file. */
    public Map<Path, String> changes(final Path root) {
        final Map<Path, String> texts = texts(root);
        final Map<Path, List<Path>> later = laterRecords(texts);
        final Map<Path, String> changed = new TreeMap<>();
        texts.forEach((file, text) -> {
            final String line = line(file, later.getOrDefault(file, List.of()), texts);
            final String updated = LATER_LINE.matcher(text).replaceFirst(Matcher.quoteReplacement(line));
            if (!updated.equals(text)) {
                changed.put(file, updated);
            }
        });
        return changed;
    }

    public void write(final Path root) {
        changes(root).forEach(RepoFiles::write);
    }

    public List<Problem> check(final Path root) {
        return changes(root).keySet().stream()
                .map(file -> new Problem(file, "its line '" + LATER.substring(2).trim()
                        + "' is out of date with the other records' 'Builds on' lines;"
                        + " run ./gradlew buildDecisionIndexes"))
                .toList();
    }

    private static Map<Path, String> texts(final Path root) {
        final Map<Path, String> texts = new TreeMap<>();
        RepoChecks.decisionFolders(root).stream()
                .flatMap(folder -> DecisionIndex.recordFiles(folder).stream())
                .map(file -> file.toAbsolutePath().normalize())
                .forEach(file -> texts.put(file, RepoFiles.read(file)));
        return texts;
    }

    private static Map<Path, List<Path>> laterRecords(final Map<Path, String> texts) {
        final Map<Path, List<Path>> later = new HashMap<>();
        texts.forEach((file, text) -> buildsOn(file, text).stream()
                .filter(texts::containsKey)
                .forEach(earlier -> later.computeIfAbsent(earlier, key -> new ArrayList<>()).add(file)));
        return later;
    }

    static List<Path> buildsOn(final Path file, final String text) {
        final Matcher line = BUILDS_ON.matcher(text);
        final List<Path> earlier = new ArrayList<>();
        final Matcher link = LINK.matcher(line.find() ? line.group(1) : "");
        while (link.find()) {
            if (!link.group(1).contains("://")) {
                earlier.add(file.resolveSibling(link.group(1)).normalize());
            }
        }
        return earlier;
    }

    private static String line(final Path file, final List<Path> later, final Map<Path, String> texts) {
        final String links = later.stream()
                .distinct()
                .filter(other -> !other.equals(file))
                .sorted(BY_NUMBER)
                .map(other -> "[" + DecisionRecord.title(other, texts.get(other)) + "]("
                        + RepoFiles.withSlashes(file.resolveSibling("").relativize(other)) + ")")
                .collect(Collectors.joining(", "));
        return LATER + (links.isEmpty() ? "none yet" : links);
    }
}
