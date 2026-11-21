// Conventions for every Java project in this repository. The standards they enforce are listed in AGENTS.md.
// `./gradlew check` runs: tests with coverage verification, Checkstyle, PMD (including complexity and the
// assertAll rule), copy-paste detection, SpotBugs with FindSecBugs, and forbidden-API checks.
// Dependency vulnerability checks run with `./gradlew dependencyCheckAnalyze`, and as part of `check` in CI.
// Mutation testing is opt-in: `./gradlew pitest`.

import com.github.spotbugs.snom.Confidence
import com.github.spotbugs.snom.Effort
import com.github.spotbugs.snom.SpotBugsTask
import de.aaschmid.gradle.plugins.cpd.Cpd

plugins {
    java
    jacoco
    checkstyle
    pmd
    id("com.github.spotbugs")
    id("de.thetaphi.forbiddenapis")
    id("org.owasp.dependencycheck")
    id("de.aaschmid.cpd")
    id("info.solidsoft.pitest")
}

group = "io.github.fiftieshousewife.undertest"

val libs = the<VersionCatalogsExtension>().named("libs")
fun version(alias: String) = libs.findVersion(alias).get().requiredVersion
fun library(alias: String) = libs.findLibrary(alias).get()
val qualityConfig = rootProject.layout.projectDirectory.dir("config/quality")

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(version("java"))
    }
}

dependencies {
    // Logging: Lombok's @Slf4j on the SLF4J API, with Log4j 2 behind it at run time.
    compileOnly(library("lombok"))
    annotationProcessor(library("lombok"))
    testCompileOnly(library("lombok"))
    testAnnotationProcessor(library("lombok"))
    implementation(library("slf4j-api"))
    runtimeOnly(library("log4j-core"))
    runtimeOnly(library("log4j-slf4j2-impl"))

    testImplementation(platform(library("junit-bom")))
    testImplementation(library("junit-jupiter"))
    testImplementation(library("assertj-core"))
    testRuntimeOnly(library("junit-platform-launcher"))

    spotbugsPlugins(library("findsecbugs"))
}

tasks.withType<JavaCompile>().configureEach {
    options.encoding = "UTF-8"
    options.compilerArgs.addAll(listOf("-Xlint:all,-processing", "-Werror", "-parameters"))
}

tasks.withType<AbstractArchiveTask>().configureEach {
    isPreserveFileTimestamps = false
    isReproducibleFileOrder = true
}

// ---------- Tests and coverage ----------
tasks.test {
    useJUnitPlatform()
    finalizedBy(tasks.jacocoTestReport)
}

jacoco {
    toolVersion = version("jacoco")
}

tasks.jacocoTestReport {
    dependsOn(tasks.test)
    reports {
        xml.required = true
        html.required = true
    }
}

val minLineCoverage = providers.gradleProperty("quality.minLineCoverage")
    .orElse(version("min-line-coverage"))
    .map { it.toBigDecimal() }

tasks.jacocoTestCoverageVerification {
    dependsOn(tasks.test)
    violationRules {
        rule {
            limit {
                counter = "LINE"
                minimum = minLineCoverage.get()
            }
        }
    }
}

tasks.check {
    dependsOn(tasks.jacocoTestCoverageVerification)
}

// ---------- Style, size and complexity ----------
checkstyle {
    toolVersion = version("checkstyle")
    configDirectory = qualityConfig.dir("checkstyle")
    isIgnoreFailures = false
    maxWarnings = 0
}

pmd {
    toolVersion = version("pmd")
    ruleSetFiles = files(qualityConfig.file("pmd/ruleset.xml"))
    ruleSets = emptyList()
    isConsoleOutput = true
    isIgnoreFailures = false
}

// ---------- Copy-paste detection ----------
cpd {
    toolVersion = version("pmd")
    minimumTokenCount = 75
    isIgnoreFailures = false
}

tasks.withType<Cpd>().configureEach {
    reports {
        text.required = true
        xml.required = false
    }
    source = fileTree("src") { include("**/*.java") }
}

tasks.check {
    dependsOn(tasks.withType<Cpd>())
}

// ---------- Bugs and security bugs ----------
spotbugs {
    toolVersion = version("spotbugs")
    effort = Effort.MAX
    reportLevel = Confidence.LOW
    ignoreFailures = false
}

tasks.withType<SpotBugsTask>().configureEach {
    reports.create("html") { required = true }
}

// ---------- Forbidden APIs ----------
forbiddenApis {
    bundledSignatures = setOf(
        "jdk-unsafe",
        "jdk-deprecated",
        "jdk-internal",
        "jdk-non-portable",
        "jdk-system-out",
        "jdk-reflection",
    )
    signaturesFiles = files(qualityConfig.file("forbidden-apis/signatures.txt"))
    ignoreFailures = false
}

// ---------- Dependency vulnerabilities ----------
dependencyCheck {
    failBuildOnCVSS = version("dependency-check-fail-cvss").toFloat()
    formats = listOf("HTML", "JSON")
    nvd {
        apiKey = providers.environmentVariable("NVD_API_KEY").orNull
    }
}

if (providers.environmentVariable("CI").isPresent) {
    tasks.check {
        dependsOn(tasks.named("dependencyCheckAnalyze"))
    }
}

// ---------- Mutation testing (opt-in) ----------
pitest {
    pitestVersion = version("pitest")
    junit5PluginVersion = version("pitest-junit5")
    targetClasses = listOf("io.github.fiftieshousewife.*")
    outputFormats = listOf("HTML", "XML")
    timestampedReports = false
}
