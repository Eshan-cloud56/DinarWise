import java.io.FileInputStream
import java.util.Properties
import java.security.KeyStore
import java.security.MessageDigest
import java.security.PrivateKey

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use(keystoreProperties::load)
}

// CI may supply the same permanent key through environment variables. Never log values.
fun signingValue(property: String, environment: String): String? =
    providers.environmentVariable(environment).orNull
        ?: keystoreProperties.getProperty(property)

val releaseStorePath = signingValue("storeFile", "DINARWISE_UPLOAD_STORE_FILE")
val releaseStorePassword = signingValue("storePassword", "DINARWISE_UPLOAD_STORE_PASSWORD")
val releaseKeyAlias = signingValue("keyAlias", "DINARWISE_UPLOAD_KEY_ALIAS")
val releaseKeyPassword = signingValue("keyPassword", "DINARWISE_UPLOAD_KEY_PASSWORD")
// Public certificate fingerprint, not a secret. Changing keys requires an explicit migration.
val permanentUploadSha256 = "dd13b7cb07d0057f0a5aeee0247e2e8e159738ef936910589cad3ee2eebbe05b"

val validatePermanentReleaseSigning = tasks.register("validatePermanentReleaseSigning") {
    group = "verification"
    description = "Reject missing, debug, or changed DinarWise release signing keys."
    doLast {
        if (listOf(releaseStorePath, releaseStorePassword, releaseKeyAlias, releaseKeyPassword)
                .any { it.isNullOrBlank() }) {
            throw GradleException("Release signing requires the permanent upload key: configure ignored android/key.properties or DINARWISE_UPLOAD_* environment variables. No debug fallback is permitted.")
        }
        try {
            val file = rootProject.file(releaseStorePath!!)
            val store = KeyStore.getInstance(file, releaseStorePassword!!.toCharArray())
            val certificate = store.getCertificate(releaseKeyAlias!!) ?: error("missing certificate")
            val fingerprint = MessageDigest.getInstance("SHA-256")
                .digest(certificate.encoded).joinToString("") { "%02x".format(it.toInt() and 0xff) }
            check(fingerprint == permanentUploadSha256)
            check(store.getKey(releaseKeyAlias, releaseKeyPassword!!.toCharArray()) is PrivateKey)
        } catch (_: Exception) {
            // Do not propagate file paths, passwords or provider exception details.
            throw GradleException("Release signing validation failed. Use the existing permanent DinarWise private upload key and correct credentials; debug or replacement certificates are not accepted.")
        }
    }
}

tasks.configureEach {
    if (name.contains("ReleaseBuild", ignoreCase = true) || name.contains("SigningRelease", ignoreCase = true)) {
        if (name.startsWith("pre") || name.startsWith("validate")) {
            dependsOn(validatePermanentReleaseSigning)
        }
    }
}

android {
    namespace = "com.sl.dinarwise.expensemanager"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.sl.dinarwise.expensemanager"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true

        externalNativeBuild {
            cmake {
                arguments("-DANDROID_STL=c++_shared")
            }
        }
        ndk {
            abiFilters.addAll(listOf("arm64-v8a", "armeabi-v7a", "x86_64"))
        }
    }

    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "3.22.1"
        }
    }

    val requestedFlavor = (project.findProperty("flavor") as? String)?.lowercase()
    val isProduction = requestedFlavor == "production" ||
        project.hasProperty("production") ||
        project.hasProperty("play") ||
        gradle.startParameter.taskNames.any { it.contains("production", ignoreCase = true) }
    val isQa = requestedFlavor == "qa" ||
        gradle.startParameter.taskNames.any { it.contains("qa", ignoreCase = true) }

    if (isProduction || isQa) {
        flavorDimensions += "default"
        productFlavors {
            if (isProduction) {
                create("production") {
                    dimension = "default"
                }
            }
            if (isQa) {
                create("qa") {
                    dimension = "default"
                }
            }
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = releaseKeyAlias
            keyPassword = releaseKeyPassword
            storeFile = releaseStorePath?.takeIf { it.isNotBlank() }?.let { rootProject.file(it) }
            storePassword = releaseStorePassword
            enableV1Signing = true
            enableV2Signing = true
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    implementation("androidx.exifinterface:exifinterface:1.4.1")
    implementation("com.google.mlkit:text-recognition:16.0.1")
    implementation("cz.adaptech.tesseract4android:tesseract4android:4.9.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
