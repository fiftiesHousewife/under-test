package io.github.fiftieshousewife.undertest.tools.repochecks;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

/**
 * Checks the files a skill wrote in a repo's {@code testing/} folder against the toolkit's own schemas, whatever
 * schema line the files carry: the skill evals use it on each run's workspace, so a run that writes a file in the
 * wrong shape fails even when every pattern check passes. Files that aren't there are not checked.
 */
public final class OutputValidator {

    private static final Map<String, String> SCHEMAS = Map.of(
            "testing/assessment.yaml", "schema/assessment.schema.json",
            "testing/sources.yaml", "schema/source-list.schema.json",
            "testing/external-systems.calm.json", "schema/external-systems-list.schema.json",
            "testing/external-calls.json", "schema/external-calls.schema.json",
            "testing/tests.yaml", "schema/tests.schema.json");

    private final Path toolkit;
    private final SchemaValidator validator = new SchemaValidator();

    public OutputValidator(final Path toolkit) {
        this.toolkit = toolkit;
    }

    /** The problems in one workspace's files, with each file named relative to the workspace. */
    public List<Problem> validate(final Path workspace) {
        return SCHEMAS.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .filter(entry -> Files.isRegularFile(workspace.resolve(entry.getKey())))
                .flatMap(entry -> validator.validate(workspace.resolve(entry.getKey()),
                        toolkit.resolve(entry.getValue())).stream())
                .toList();
    }
}
