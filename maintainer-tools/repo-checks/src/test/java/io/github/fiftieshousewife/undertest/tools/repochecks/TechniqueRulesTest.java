package io.github.fiftieshousewife.undertest.tools.repochecks;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class TechniqueRulesTest {

    @TempDir
    Path root;

    private void writeTechnique(final String id, final String extra) throws IOException {
        Files.createDirectories(root.resolve("techniques/" + id));
        Files.writeString(root.resolve("techniques/" + id + "/technique.yaml"),
                "# a comment\nid: " + id + "\nname: The " + id + "\nworkstream: strengthen-tests\n"
                        + "needed_when:\n  - Business criticality is high\nreferences: [x]\n" + extra);
    }

    @Test
    void keepsOnlyTheFieldsTheSkillReadsOneTechniquePerLineInIdOrder() throws IOException {
        writeTechnique("zeta", "");
        writeTechnique("alpha", "fallback: Wait\n");

        final String rules = new TechniqueRules().render(root);

        assertAll(
                () -> assertThat(rules).contains("{\"id\":\"alpha\",\"workstream\":\"strengthen-tests\","
                        + "\"needed_when\":[\"Business criticality is high\"],\"fallback\":\"Wait\"},\n"
                        + "{\"id\":\"zeta\""),
                () -> assertThat(rules).doesNotContain("name", "references", "a comment"));
    }

    @Test
    void isOutOfDateUntilWrittenAndAfterATechniqueChanges() throws IOException {
        writeTechnique("alpha", "");
        final TechniqueRules rules = new TechniqueRules();
        final boolean beforeWriting = rules.isCurrent(root);
        rules.write(root);
        final boolean afterWriting = rules.isCurrent(root);
        writeTechnique("alpha", "fallback: Wait\n");

        assertAll(
                () -> assertThat(beforeWriting).isFalse(),
                () -> assertThat(afterWriting).isTrue(),
                () -> assertThat(rules.isCurrent(root)).isFalse());
    }
}
