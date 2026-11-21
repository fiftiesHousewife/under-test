plugins {
    id("io.github.fiftieshousewife.java-conventions")
}

// Tools for lesson videos: checks, captions and (to come) rendering. Kept inside lessons/ so it moves with the lessons when they get their own repo.
//   checkVideoScripts: catches video-script mistakes that otherwise only show up as a recording that hangs.
//   testVideoHelpers:  tests the shell helpers and render script against a stand-in for VHS (needs bash).

val repoRoot = rootDir.absolutePath

val checkVideoScripts = tasks.register<JavaExec>("checkVideoScripts") {
    group = "verification"
    description = "Fails on lesson video scripts (.tape) with mistakes that would make a recording hang."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = "io.github.fiftieshousewife.undertest.lessons.video.VideoChecks"
    args(repoRoot)
}

val testVideoHelpers = tasks.register<Exec>("testVideoHelpers") {
    group = "verification"
    description = "Tests lessons/_shared/callout.sh and render.sh with a stand-in for VHS."
    workingDir = rootDir
    commandLine("bash", "lessons/_shared/video-tools/test-video-helpers.sh")
}

tasks.register<JavaExec>("buildLessonCaptions") {
    group = "documentation"
    description = "Writes WebVTT and SRT captions for each lesson video from its narration (-Plesson=<id> for one)."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = "io.github.fiftieshousewife.undertest.lessons.video.Captions"
    args(listOfNotNull(repoRoot, providers.gradleProperty("lesson").orNull))
}

tasks.check {
    dependsOn(checkVideoScripts, testVideoHelpers)
}
