plugins {
    // AGP and Kotlin plugins are declared with `apply false` in settings.gradle.kts
}

subprojects {
    buildDir = File(rootProject.projectDir.parentFile, "build/${project.name}")
}
