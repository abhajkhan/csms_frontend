allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Enforce a specific NDK version for all Android subprojects.
    // This is necessary to prevent transitive dependencies (like ':jni') from trying
    // to use a different, potentially corrupted, NDK version.
    project.afterEvaluate {
        project.extensions.findByType<com.android.build.gradle.BaseExtension>()
            ?.ndkVersion = "26.1.10909125"
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
