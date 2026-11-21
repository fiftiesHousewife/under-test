plugins {
    id("io.github.fiftieshousewife.java-conventions")
}

// Tools for lesson videos: checks, captions and (to come) rendering. Kept inside lessons/ so it moves with the lessons when they get their own repo.
//   checkVideoScripts: catches video-script mistakes that otherwise only show up as a recording that hangs.
//   testVideoHelpers:  tests the shell helpers and render script against a stand-in for VHS (needs bash).

dependencies {
    compileOnly(libs.spotbugs.annotations)
    testCompileOnly(libs.spotbugs.annotations)
}

val repoRoot = rootDir.absolutePath
val lesson = providers.gradleProperty("lesson")
// The voice: any command that turns a text file into a WAV file. Default: the offline Kokoro voice (see speak-kokoro.py).
val voiceCommand = providers.gradleProperty("lessonVoiceCommand").map { it.split(" ") }.orElse(
    listOf("$repoRoot/build/voice/venv/bin/python", "$repoRoot/lessons/_shared/video-tools/speak-kokoro.py"))

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

val buildLessonVoice = tasks.register<JavaExec>("buildLessonVoice") {
    group = "documentation"
    description = "Reads each scene's narration aloud and builds the narration track (-Plesson=<id>)."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = "io.github.fiftieshousewife.undertest.lessons.video.LessonVideo"
    workingDir = rootDir
    environment("KOKORO_MODELS", "$repoRoot/build/voice")
    val root = repoRoot
    val lessonId = lesson
    val voice = voiceCommand
    argumentProviders.add(CommandLineArgumentProvider { listOf("voice", root, lessonId.getOrElse("")) + voice.get() })
}

tasks.register<JavaExec>("assembleLessonVideo") {
    group = "documentation"
    description = "Combines the silent video, narration and captions into the finished MP4 (-Plesson=<id>)."
    classpath = sourceSets.main.get().runtimeClasspath
    mainClass = "io.github.fiftieshousewife.undertest.lessons.video.LessonVideo"
    val root = repoRoot
    val lessonId = lesson
    argumentProviders.add(CommandLineArgumentProvider { listOf("assemble", root, lessonId.getOrElse("")) })
    dependsOn("buildLessonCaptions", buildLessonVoice)
}

tasks.check {
    dependsOn(checkVideoScripts, testVideoHelpers)
}
