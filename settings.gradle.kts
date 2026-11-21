pluginManagement {
    includeBuild("build-logic")
    repositories {
        gradlePluginPortal()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositoriesMode = RepositoriesMode.FAIL_ON_PROJECT_REPOS
    repositories {
        mavenCentral()
    }
}

rootProject.name = "under-test"

// Each directory that holds a build.gradle.kts becomes a project, named by its path:
//   techniques/<id>/example  -> :techniques:<id>     (reference example for people learning the technique)
//   tools/<id>               -> :tools:<id>          (automated tools: assessment-file validator, convention plugin, scanners)
//   shared-test-kits/<id>    -> :shared-test-kits:<id> (stand-ins for one widely shared system)
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

includeAll("techniques", subdir = "example")
includeAll("tools")
includeAll("shared-test-kits")
