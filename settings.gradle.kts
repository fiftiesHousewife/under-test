pluginManagement {
    repositories {
        gradlePluginPortal() // the plugin's own Gradle plugins (SpotBugs', PIT's, the versions report's) are only here
        mavenCentral()
    }
    plugins {
        // Our code-quality standards (decision 0100): https://github.com/fiftiesHousewife/under-test-java-conventions
        id("io.github.fiftieshousewife.java-conventions") version "0.1.0"
    }
}

plugins {
    // Where Gradle downloads a JDK 25 if none is installed. An organisation without internet access switches downloads
    // off in its init script or gradle.properties (org.gradle.java.installations.auto-download=false) and points
    // Gradle at its installed JDKs (org.gradle.java.installations.paths); see ADOPTION.md.
    id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"
}

dependencyResolutionManagement {
    repositoriesMode = RepositoriesMode.FAIL_ON_PROJECT_REPOS
    repositories {
        mavenCentral()
    }
}

rootProject.name = "under-test"

// Each directory that holds a build.gradle.kts becomes a project, named by its path:
//   tools/<id>               -> :tools:<id>             (tools adopting organisations run)
//   maintainer-tools/<id>    -> :maintainer-tools:<id>  (tools that keep this repo itself in order)
fun includeAll(root: String, subdir: String? = null) {
    rootDir.resolve(root).listFiles()?.sorted()?.forEach { dir ->
        val projectDir = if (subdir == null) dir else dir.resolve(subdir)
        if (projectDir.resolve("build.gradle.kts").isFile) {
            val path = ":$root:${dir.name}"
            include(path)
            project(path).projectDir = projectDir
        }
    }
}

includeAll("tools")
includeAll("maintainer-tools")
