// android/build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// --- CORRECTED PLUGINS BLOCK ---
plugins {
    // 1. We REMOVED "com.android.application" and "com.android.library"
    //    because Flutter is already loading them for you.

    // 2. Keep Kotlin (This is usually safe to define)
   

    // 3. Keep Google Services (This is what we need for Firebase)
    id("com.google.gms.google-services") version "4.4.2" apply false
}