plugins {
    id("io.github.fiftieshousewife.java-conventions")
}

// Checks this repository's own files, and rebuilds the decision indexes. See AGENTS.md.
dependencies {
    implementation(libs.json.schema.validator)
    implementation(libs.jackson3.yaml)
}

val repoRoot = rootDir.absolutePath
val mainClassName = "io.github.fiftieshousewife.undertest.tools.repochecks.RepoChecks"

val checkRepoFiles = tasks.register<JavaExec>("checkRepoFiles") {
    group = "verification"
    description = "Fails on broken links, invalid schemas, YAML files and eval fixtures that don't match their schema," +
        " and out-of-date decision indexes and later-decisions lines."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = mainClassName
    args("check", repoRoot)
}

tasks.register<JavaExec>("buildDecisionIndexes") {
    group = "documentation"
    description = "Rebuilds docs/decisions/README.md, decision-guides/README.md and each record's later-decisions line" +
        " from the records."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = mainClassName
    args("index", repoRoot)
}

tasks.register<JavaExec>("fixDecisionLinks") {
    group = "documentation"
    description = "Re-points links to decision records at their current files, after renumbering or moving them."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = mainClassName
    args("fix-links", repoRoot)
}

// Used by maintainer-tools/skill-evals/run-all.sh: -PoutputReport=<file> -Pworkspaces=<dir>:<dir>:..., the folders
// separated by the platform's path separator (":", or ";" on Windows).
tasks.register<JavaExec>("validateSkillOutput") {
    group = "verification"
    description = "Checks the files skills wrote in eval workspaces against the toolkit's schemas."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = mainClassName
    val report = providers.gradleProperty("outputReport").getOrElse("")
    val workspaces = providers.gradleProperty("workspaces").getOrElse("").split(File.pathSeparator).filter { it.isNotBlank() }
    args(listOf("validate-output", repoRoot, report) + workspaces)
}

checkRepoFiles.configure {
    mustRunAfter("fixDecisionLinks", "buildDecisionIndexes")
}

tasks.check {
    dependsOn(checkRepoFiles)
}
