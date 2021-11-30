import org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget
import org.jetbrains.kotlin.ir.backend.js.compile

plugins {
    kotlin("multiplatform")
    id("com.android.library")
    id("kotlin-android-extensions")
}
group = "com.divtracker"
version = "1.0"

repositories {
    gradlePluginPortal()
    google()
    mavenCentral()
    jcenter()
}
kotlin {
    android()
    ios {
        binaries {
            framework {
                baseName = "DivtrackerCommon"
            }
        }
    }
    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation("co.touchlab:stately-common:1.1.4")
                implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.3.1")
                implementation("co.touchlab:stately-concurrency:1.1.4")
                implementation("io.github.shabinder:fuzzywuzzy:1.1")
            }
        }

        val commonTest by getting {
            dependencies {
                implementation(kotlin("test-common"))
                implementation(kotlin("test-annotations-common"))
            }
        }
        val androidMain by getting {
            dependencies {
                implementation("com.google.android.material:material:1.4.0")
            }
        }
        val androidTest by getting {
            dependencies {
                implementation(kotlin("test-junit"))
                implementation("junit:junit:4.13.2")
            }
        }
        val iosMain by getting
        val iosTest by getting
    }
}
android {
    compileSdk = 31
    sourceSets["main"].manifest.srcFile("src/androidMain/AndroidManifest.xml")
    defaultConfig {
        minSdk = 26
        targetSdk = 31
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
        }
    }
}
val packForXcode by tasks.creating(Sync::class) {
    group = "build"
    var mode = System.getenv("CONFIGURATION") ?: "DEBUG"
    if (mode == "TestFlight") {
        mode = "Release"
    }

    val sdkName = System.getenv("SDK_NAME") ?: "iphonesimulator"
    val targetName = "ios" + if (sdkName.startsWith("iphoneos")) "Arm64" else "X64"
    val buildProductsDir = System.getenv("BUILT_PRODUCTS_DIR")

    println("Building for '${mode}' mode, '${targetName}' target, '${buildProductsDir}' dir")

    val framework =
        kotlin.targets.getByName<KotlinNativeTarget>(targetName).binaries.getFramework(mode)
    inputs.property("mode", mode)
    dependsOn(framework.linkTask)
    val frameworkDir = File(buildProductsDir, "xcode-frameworks")
    from({ framework.outputDirectory })
    into(frameworkDir)
}
tasks.getByName("build").dependsOn(packForXcode)

// Test Logging
tasks.withType<Test> {
    testLogging {
        events("standardOut", "started", "passed", "skipped", "failed")
    }
}
