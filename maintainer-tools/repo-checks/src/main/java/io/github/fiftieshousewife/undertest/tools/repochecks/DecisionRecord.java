package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.nio.file.Path;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** The parts of one decision record the index needs, read from its front matter and title. */
public record DecisionRecord(Path file, String title, Metadata metadata) {

    /** Front matter fields shown in the index. */
    public record Metadata(String status, String decisionMakers, String group) {
    }

    private static final Pattern TITLE = Pattern.compile("(?m)^# (.+)$");
    private static final Pattern STATUS_LINE = Pattern.compile("(?m)\\*\\*Status:\\*\\* (.+)$");
    private static final Pattern FRONT_MATTER =
            Pattern.compile("\\A---\\R(.*?)^---$", Pattern.DOTALL | Pattern.MULTILINE);

    public static DecisionRecord read(final Path file) {
        final String text = RepoFiles.read(file);
        final String frontMatter = frontMatter(file, text);
        final Matcher statusLine = STATUS_LINE.matcher(text);
        final String status = statusLine.find() ? statusLine.group(1).trim() : field(file, frontMatter, "status");
        final Metadata metadata = new Metadata(status, field(file, frontMatter, "decision-makers"),
                field(file, frontMatter, "group"));
        return new DecisionRecord(file, title(file, text), metadata);
    }

    static String title(final Path file, final String text) {
        final Matcher title = TITLE.matcher(text);
        if (!title.find()) {
            throw new IllegalStateException(file + " has no title");
        }
        return title.group(1).trim();
    }

    private static String frontMatter(final Path file, final String text) {
        final Matcher matcher = FRONT_MATTER.matcher(text);
        if (!matcher.find()) {
            throw new IllegalStateException(file + " has no front matter between --- lines");
        }
        return matcher.group(1);
    }

    private static String field(final Path file, final String frontMatter, final String name) {
        final Matcher matcher = Pattern.compile("(?m)^" + Pattern.quote(name) + ":\\s*(.+)$").matcher(frontMatter);
        if (!matcher.find()) {
            throw new IllegalStateException(file + ": front matter has no " + name);
        }
        return matcher.group(1).trim();
    }
}
