pluginManagement {
    val flutterSdkPath = providers.gradleProperty("flutter.sdk").getOrNull()
        ?: run {
            val localProperties = java.util.Properties()
            val propertiesFile = file("local.properties")
            if (propertiesFile.exists()) {
                propertiesFile.inputStream().use { localProperties.load(it) }
                localProperties.getProperty("flutter.sdk")
            } else {
                null
            }
        } ?: throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
