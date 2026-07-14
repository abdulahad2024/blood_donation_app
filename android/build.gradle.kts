buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // 🔔 Kotlin DSL সিনট্যাক্সে ব্র্যাকেট এবং ডাবল কোটেশন ব্যবহার করা হয়েছে
        classpath("com.android.tools.build:gradle:8.2.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ফ্লার্টার বিল্ড ডিরেক্টরি কনফিগারেশন (Kotlin DSL সিনট্যাক্সে ফিক্সড)
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