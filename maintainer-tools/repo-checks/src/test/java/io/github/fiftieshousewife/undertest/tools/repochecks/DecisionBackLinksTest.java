package io.github.fiftieshousewife.undertest.tools.repochecks;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class DecisionBackLinksTest {

    private static final String LATER = DecisionBackLinks.LATER;

    @TempDir
    Path root;

    private Path first;
    private Path second;
    private Path third;

    private static String record(final String title, final String buildsOn, final String later) {
        return "---\nstatus: accepted\ndecision-makers: x\ngroup: y\n---\n\n# " + title + "\n\nBody.\n\n"
                + "## More Information\n\n* Builds on: " + buildsOn + "\n" + LATER + later + "\n* Last line\n";
    }

    @BeforeEach
    void writeRecords() throws IOException {
        Files.createDirectories(root.resolve("docs/decisions"));
        Files.createDirectories(root.resolve("decision-guides"));
        first = Files.writeString(root.resolve("docs/decisions/0001-first.md"),
                record("First", "nothing (a foundation decision)", "none yet"));
        second = Files.writeString(root.resolve("decision-guides/0002-second.md"),
                record("Second", "[First](../docs/decisions/0001-first.md), [web](https://example.com/0001-x.md)",
                        "[Stale](0009-gone.md)"));
        third = Files.writeString(root.resolve("docs/decisions/0003-third.md"),
                record("Third", "[Second](../../decision-guides/0002-second.md), [First](0001-first.md)", "none yet"));
    }

    @Test
    void listsLaterRecordsAcrossBothFoldersInNumberOrder() throws IOException {
        new DecisionBackLinks().write(root);

        assertAll(
                () -> assertThat(Files.readString(first)).contains(LATER
                        + "[Second](../../decision-guides/0002-second.md), [Third](0003-third.md)\n"),
                () -> assertThat(Files.readString(second)).contains(LATER
                        + "[Third](../docs/decisions/0003-third.md)\n"),
                () -> assertThat(Files.readString(third)).contains(LATER + "none yet\n"));
    }

    @Test
    void leavesEverythingElseInARecordUntouched() throws IOException {
        new DecisionBackLinks().write(root);

        assertThat(Files.readString(second)).isEqualTo(record("Second",
                "[First](../docs/decisions/0001-first.md), [web](https://example.com/0001-x.md)",
                "[Third](../docs/decisions/0003-third.md)"));
    }

    @Test
    void reportsOutOfDateRecordsUntilTheyAreRewritten() {
        final DecisionBackLinks backLinks = new DecisionBackLinks();
        final int before = backLinks.check(root).size();
        backLinks.write(root);

        assertAll(
                () -> assertThat(before).isEqualTo(2),
                () -> assertThat(backLinks.check(root)).isEmpty());
    }

    @Test
    void tellsHowToFixAnOutOfDateRecord() {
        assertThat(new DecisionBackLinks().check(root)).first()
                .extracting(Problem::message).asString().contains("run ./gradlew buildDecisionIndexes");
    }

    @Test
    void leavesARecordWithoutTheLineAlone() throws IOException {
        final String text = "---\nstatus: accepted\ndecision-makers: x\ngroup: y\n---\n\n# Fourth\n";
        final Path fourth = Files.writeString(root.resolve("docs/decisions/0004-fourth.md"),
                text + "\n* Builds on: [Third](0003-third.md)\n");
        new DecisionBackLinks().write(root);

        assertAll(
                () -> assertThat(Files.readString(fourth)).doesNotContain(LATER),
                () -> assertThat(Files.readString(third)).contains(LATER + "[Fourth](0004-fourth.md)\n"));
    }
}
