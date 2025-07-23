// Top-level build file where you can add configuration options common to all sub-projects/modules.

plugins {
    // No application or android plugins here!
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
